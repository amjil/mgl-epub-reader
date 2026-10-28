import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../annotation/annotation.dart';
import '../engine/epub_engine.dart';
import '../epub/epub_source.dart';
import '../integration/integration.dart';
import '../model/book.dart';
import '../model/link.dart';
import '../model/position.dart';
import '../pagination/page.dart';
import '../persistence/database.dart';
import '../persistence/repositories.dart';
import '../search/search_engine.dart';
import '../ui/page_view.dart';

/// UI-facing API. Prefer this over talking to parser / Drift directly.
class EpubBridge {
  EpubBridge({
    MglEpubEngineImpl? engine,
    ReaderDatabase? database,
  })  : engine = engine ?? MglEpubEngineImpl(),
        db = database ?? ReaderDatabase();

  final MglEpubEngineImpl engine;
  final ReaderDatabase db;

  late final BookRepository books = BookRepository(db);
  late final ProgressRepository progress = ProgressRepository(db);
  late final BookmarkRepository bookmarks = BookmarkRepository(db);
  late final AnnotationRepository annotations = AnnotationRepository(db);

  factory EpubBridge.create({
    MglEpubEngineImpl? engine,
    ReaderDatabase? database,
  }) {
    return EpubBridge(engine: engine, database: database);
  }

  Future<void> initialize() async {
    await db.customSelect('SELECT 1').get();
  }

  Future<void> dispose() async {
    engine.close();
    await db.close();
  }

  Future<List<LibraryBook>> listBooks() => books.list();

  Future<LibraryBook> importPath(String path) async {
    return importBytes(await File(path).readAsBytes());
  }

  Future<LibraryBook> importBytes(List<int> bytes) async {
    final parsed = await engine.open(bytes);
    final cover = await engine.loadCoverBytes();
    final row = await books.importBytes(bytes, parsed, coverBytes: cover);
    engine.close();
    return row;
  }

  Future<EpubBook> openLibraryBook(String id) async {
    final row = await books.byId(id);
    if (row == null) {
      throw StateError('Unknown book $id');
    }
    final file = File(row.path);
    if (!await file.exists()) {
      throw StateError(
        'Book file is missing. Import the EPUB again.\n${file.path}',
      );
    }
    final book = await engine.openSource(FileEpubSource(file.path));
    await books.touch(id);
    return book;
  }

  Future<EpubChapter> loadChapter(String chapterId) =>
      engine.loadChapter(chapterId);

  Future<List<MglPage>> paginate(
    String chapterId,
    ReaderLayoutConfig config,
  ) {
    return engine.paginate(chapterId, config);
  }

  Future<List<int>> loadResource(String resourceId) =>
      engine.loadResource(resourceId);

  Future<List<SearchResult>> search(String query) => engine.search(query);

  Future<List<SearchResult>> searchChapter(
    String chapterId,
    String query, {
    int limit = 40,
  }) {
    return engine.searchChapter(chapterId, query, limit: limit);
  }

  List<String> embeddedFontFamilies() => engine.embeddedFontFamilies();

  Future<void> saveProgress(ReadingProgress value) async {
    await progress.save(value);
    await books.touch(
      value.bookId,
      progress: value.progress,
      position: value.position,
    );
  }

  Future<ReadingProgress?> loadProgress(String bookId) => progress.load(bookId);

  Future<Bookmark> addBookmark({
    required String bookId,
    required ReaderPosition position,
    String? title,
  }) {
    return bookmarks.add(bookId: bookId, position: position, title: title);
  }

  Future<List<Bookmark>> listBookmarks(String bookId) => bookmarks.list(bookId);

  Future<void> removeBookmark(String id) => bookmarks.remove(id);

  Future<void> renameBookmark(String id, String title) =>
      bookmarks.rename(id, title);

  Future<Annotation> addAnnotation(Annotation annotation) =>
      annotations.add(annotation);

  Future<List<Annotation>> listAnnotations(String bookId) =>
      annotations.list(bookId);

  Future<void> removeAnnotation(String id) => annotations.remove(id);

  Future<void> setFavorite(String id, bool favorite) =>
      books.setFavorite(id, favorite);

  Future<void> setFinished(String id, bool finished) =>
      books.setFinished(id, finished);

  Future<List<Shelf>> listShelves() => books.listShelves();

  Future<Shelf> createShelf(String name) => books.createShelf(name);

  Future<void> deleteShelf(String id) => books.deleteShelf(id);

  Future<void> setBookShelf(String bookId, String? shelfId) =>
      books.setCollection(bookId, shelfId);

  Future<void> removeBook(String id) async {
    if (engine.book?.id == id) {
      engine.close();
    }
    await books.remove(id);
  }

  EpubChapter? chapterByHref(String href) => engine.chapterByHref(href);

  Future<String?> anchorBlockId(String chapterId, String fragment) =>
      engine.anchorBlockId(chapterId, fragment);

  Future<LinkResolution> resolveLink(
    String href, {
    required String fromChapterId,
    bool note = false,
  }) {
    return engine.resolveLink(
      href,
      fromChapterId: fromChapterId,
      note: note,
    );
  }

  Future<void> shareText(String text) async {
    await Share.share(text);
  }

  Future<bool> openExternalUrl(String href) async {
    final uri = Uri.tryParse(href.trim());
    if (uri == null || !uri.hasScheme) return false;
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' &&
        scheme != 'https' &&
        scheme != 'mailto' &&
        scheme != 'tel') {
      return false;
    }
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  NoteFromSelection noteFromSelection(
    ReaderSelection selection, [
    String? chapterTitle,
  ]) {
    final book = engine.book;
    if (book == null) {
      throw StateError('No open book');
    }
    return createNoteFromSelection(
      book: book,
      selection: selection,
      chapterTitle: chapterTitle,
    );
  }

  ReaderThemeColors themeNamed(String name) => ReaderThemeColors.named(name);
}
