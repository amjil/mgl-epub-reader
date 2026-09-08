import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../annotation/annotation.dart';
import '../model/book.dart';
import '../model/position.dart';
import 'database.dart';

class LibraryBook {
  const LibraryBook({
    required this.id,
    this.title,
    this.author,
    this.cover,
    required this.path,
    this.language,
    this.progress = 0,
    this.lastPosition,
    this.lastOpenedAt,
    this.favorite = false,
    this.finished = false,
  });

  final String id;
  final String? title;
  final String? author;
  final String? cover;
  final String path;
  final String? language;
  final double progress;
  final ReaderPosition? lastPosition;
  final DateTime? lastOpenedAt;
  final bool favorite;
  final bool finished;
}

class BookRepository {
  BookRepository(this.db);

  final ReaderDatabase db;

  Future<List<LibraryBook>> list() async {
    final rows = await db.select(db.storedBooks).get();
    rows.sort((a, b) {
      final at = a.lastOpenedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bt = b.lastOpenedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bt.compareTo(at);
    });
    final dir = await _booksDir();
    final out = <LibraryBook>[];
    for (final row in rows) {
      out.add(await _resolved(_fromRow(row), dir));
    }
    return out;
  }

  Future<Directory> _booksDir() async {
    final support = await getApplicationSupportDirectory();
    final dir = Directory(p.join(support.path, 'mgl_epub_reader', 'books'));
    await dir.create(recursive: true);
    return dir;
  }

  /// Resolve a stored path (relative or stale absolute) against the current
  /// books directory. iOS container UUIDs change; picker temp files vanish.
  File locateBookFile(Directory dir, String stored, String id) {
    return _locate(
      dir,
      stored,
      fallbacks: ['$id.epub'],
    );
  }

  File? locateCoverFile(Directory dir, String? stored, String id) {
    if (stored == null || stored.isEmpty) return null;
    final file = _locate(
      dir,
      stored,
      fallbacks: [
        '$id.cover.jpg',
        '$id.cover.png',
        '$id.cover.gif',
        '$id.cover.webp',
      ],
    );
    return file.existsSync() ? file : null;
  }

  File _locate(
    Directory dir,
    String stored, {
    required List<String> fallbacks,
  }) {
    final candidates = <String>[
      stored,
      if (!p.isAbsolute(stored)) p.join(dir.path, stored),
      p.join(dir.path, p.basename(stored)),
      ...fallbacks.map((name) => p.join(dir.path, name)),
    ];
    for (final candidate in candidates) {
      final file = File(candidate);
      if (file.existsSync()) return file;
      try {
        final resolved = File(file.resolveSymbolicLinksSync());
        if (resolved.existsSync()) return resolved;
      } on FileSystemException {
        // ignore dangling / inaccessible links
      }
    }
    final expected = p.isAbsolute(stored)
        ? p.join(dir.path, p.basename(stored))
        : p.join(dir.path, stored);
    return File(expected);
  }

  Future<LibraryBook> _resolved(LibraryBook book, Directory dir) async {
    final epub = locateBookFile(dir, book.path, book.id);
    final coverFile = locateCoverFile(dir, book.cover, book.id);
    final epubStored = p.basename(epub.path);
    final coverStored = coverFile == null ? book.cover : p.basename(coverFile.path);
    final changed = epubStored != book.path || coverStored != book.cover;
    if (changed && epub.existsSync()) {
      await (db.update(db.storedBooks)..where((t) => t.id.equals(book.id)))
          .write(
        StoredBooksCompanion(
          path: Value(epubStored),
          cover: Value(coverStored),
        ),
      );
    }
    return LibraryBook(
      id: book.id,
      title: book.title,
      author: book.author,
      cover: coverFile?.path,
      path: epub.path,
      language: book.language,
      progress: book.progress,
      lastPosition: book.lastPosition,
      lastOpenedAt: book.lastOpenedAt,
      favorite: book.favorite,
      finished: book.finished,
    );
  }

  Future<LibraryBook> importFile(
    String sourcePath,
    EpubBook book, {
    List<int>? coverBytes,
  }) async {
    return importBytes(
      await File(sourcePath).readAsBytes(),
      book,
      coverBytes: coverBytes,
    );
  }

  Future<LibraryBook> importBytes(
    List<int> bytes,
    EpubBook book, {
    List<int>? coverBytes,
  }) async {
    final dir = await _booksDir();
    final id = book.id.isNotEmpty
        ? _safeId(book.id)
        : sha1.convert(bytes).toString();
    final destName = '$id.epub';
    final dest = p.join(dir.path, destName);
    await File(dest).writeAsBytes(bytes, flush: true);
    String? coverName;
    if (coverBytes != null && coverBytes.isNotEmpty) {
      coverName = '$id.cover${_coverExt(book.cover)}';
      await File(p.join(dir.path, coverName)).writeAsBytes(coverBytes, flush: true);
    }
    await db.into(db.storedBooks).insertOnConflictUpdate(
          StoredBooksCompanion(
            id: Value(id),
            title: Value(book.title),
            author: Value(book.authors.isEmpty ? null : book.authors.join(', ')),
            cover: Value(coverName),
            path: Value(destName),
            language: Value(book.language),
            lastOpenedAt: Value(DateTime.now()),
          ),
        );
    return (await byId(id))!;
  }

  Future<LibraryBook?> byId(String id) async {
    final row = await (db.select(db.storedBooks)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return _resolved(_fromRow(row), await _booksDir());
  }

  Future<void> touch(
    String id, {
    double? progress,
    ReaderPosition? position,
  }) async {
    await (db.update(db.storedBooks)..where((t) => t.id.equals(id))).write(
      StoredBooksCompanion(
        lastOpenedAt: Value(DateTime.now()),
        progress: progress == null ? const Value.absent() : Value(progress),
        lastPositionJson: position == null
            ? const Value.absent()
            : Value(jsonEncode(position.toJson())),
      ),
    );
  }

  Future<void> setFavorite(String id, bool favorite) async {
    await (db.update(db.storedBooks)..where((t) => t.id.equals(id))).write(
      StoredBooksCompanion(favorite: Value(favorite)),
    );
  }

  Future<void> setFinished(String id, bool finished) async {
    await (db.update(db.storedBooks)..where((t) => t.id.equals(id))).write(
      StoredBooksCompanion(finished: Value(finished)),
    );
  }

  Future<void> remove(String id) async {
    final row = await byId(id);
    if (row != null) {
      final file = File(row.path);
      if (await file.exists()) await file.delete();
      final cover = row.cover;
      if (cover != null && cover.isNotEmpty) {
        final coverFile = File(cover);
        if (await coverFile.exists()) await coverFile.delete();
      }
    }
    await (db.delete(db.storedBooks)..where((t) => t.id.equals(id))).go();
    await (db.delete(db.readingProgressRows)..where((t) => t.bookId.equals(id)))
        .go();
    await (db.delete(db.bookmarkRows)..where((t) => t.bookId.equals(id))).go();
    await (db.delete(db.annotationRows)..where((t) => t.bookId.equals(id))).go();
  }

  LibraryBook _fromRow(StoredBook row) {
    ReaderPosition? pos;
    final raw = row.lastPositionJson;
    if (raw != null && raw.isNotEmpty) {
      pos = ReaderPosition.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
    return LibraryBook(
      id: row.id,
      title: row.title,
      author: row.author,
      cover: row.cover,
      path: row.path,
      language: row.language,
      progress: row.progress,
      lastPosition: pos,
      lastOpenedAt: row.lastOpenedAt,
      favorite: row.favorite,
      finished: row.finished,
    );
  }

  String _safeId(String id) => id.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');

  String _coverExt(String? href) {
    final lower = (href ?? '').toLowerCase();
    if (lower.endsWith('.png')) return '.png';
    if (lower.endsWith('.gif')) return '.gif';
    if (lower.endsWith('.webp')) return '.webp';
    return '.jpg';
  }
}

class ProgressRepository {
  ProgressRepository(this.db);

  final ReaderDatabase db;

  Future<void> save(ReadingProgress progress) async {
    await db.into(db.readingProgressRows).insertOnConflictUpdate(
          ReadingProgressRowsCompanion(
            bookId: Value(progress.bookId),
            chapterId: Value(progress.chapterId),
            blockId: Value(progress.blockId),
            offset: Value(progress.offset),
            progress: Value(progress.progress),
            updatedAt: Value(progress.updatedAt),
          ),
        );
  }

  Future<ReadingProgress?> load(String bookId) async {
    final row = await (db.select(db.readingProgressRows)
          ..where((t) => t.bookId.equals(bookId)))
        .getSingleOrNull();
    if (row == null) return null;
    return ReadingProgress(
      bookId: row.bookId,
      chapterId: row.chapterId,
      blockId: row.blockId,
      offset: row.offset,
      progress: row.progress,
      updatedAt: row.updatedAt,
    );
  }
}

class BookmarkRepository {
  BookmarkRepository(this.db);

  final ReaderDatabase db;
  final _uuid = const Uuid();

  Future<Bookmark> add({
    required String bookId,
    required ReaderPosition position,
    String? title,
  }) async {
    final bookmark = Bookmark(
      id: _uuid.v4(),
      bookId: bookId,
      chapterId: position.chapterId,
      position: position,
      title: title,
      createdAt: DateTime.now(),
    );
    await db.into(db.bookmarkRows).insert(
          BookmarkRowsCompanion.insert(
            id: bookmark.id,
            bookId: bookmark.bookId,
            chapterId: bookmark.chapterId,
            positionJson: jsonEncode(bookmark.position.toJson()),
            title: Value(bookmark.title),
            createdAt: bookmark.createdAt,
          ),
        );
    return bookmark;
  }

  Future<List<Bookmark>> list(String bookId) async {
    final rows = await (db.select(db.bookmarkRows)
          ..where((t) => t.bookId.equals(bookId)))
        .get();
    return rows
        .map(
          (row) => Bookmark(
            id: row.id,
            bookId: row.bookId,
            chapterId: row.chapterId,
            position: ReaderPosition.fromJson(
              jsonDecode(row.positionJson) as Map<String, dynamic>,
            ),
            title: row.title,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  Future<void> remove(String id) async {
    await (db.delete(db.bookmarkRows)..where((t) => t.id.equals(id))).go();
  }
}

class AnnotationRepository {
  AnnotationRepository(this.db);

  final ReaderDatabase db;
  final _uuid = const Uuid();

  Future<Annotation> add(Annotation draft) async {
    final annotation = Annotation(
      id: draft.id.isEmpty ? _uuid.v4() : draft.id,
      bookId: draft.bookId,
      chapterId: draft.chapterId,
      start: draft.start,
      end: draft.end,
      style: draft.style,
      color: draft.color,
      note: draft.note,
      createdAt: draft.createdAt,
    );
    await db.into(db.annotationRows).insert(
          AnnotationRowsCompanion.insert(
            id: annotation.id,
            bookId: annotation.bookId,
            chapterId: annotation.chapterId,
            payloadJson: jsonEncode(annotation.toJson()),
            createdAt: annotation.createdAt,
          ),
        );
    return annotation;
  }

  Future<List<Annotation>> list(String bookId) async {
    final rows = await (db.select(db.annotationRows)
          ..where((t) => t.bookId.equals(bookId)))
        .get();
    return rows
        .map(
          (row) => Annotation.fromJson(
            jsonDecode(row.payloadJson) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> remove(String id) async {
    await (db.delete(db.annotationRows)..where((t) => t.id.equals(id))).go();
  }
}
