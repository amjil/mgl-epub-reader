// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StoredBooksTable extends StoredBooks
    with TableInfo<$StoredBooksTable, StoredBook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredBooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverMeta = const VerificationMeta('cover');
  @override
  late final GeneratedColumn<String> cover = GeneratedColumn<String>(
      'cover', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
      'progress', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _lastPositionJsonMeta =
      const VerificationMeta('lastPositionJson');
  @override
  late final GeneratedColumn<String> lastPositionJson = GeneratedColumn<String>(
      'last_position_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastOpenedAtMeta =
      const VerificationMeta('lastOpenedAt');
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
      'last_opened_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _favoriteMeta =
      const VerificationMeta('favorite');
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
      'favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _finishedMeta =
      const VerificationMeta('finished');
  @override
  late final GeneratedColumn<bool> finished = GeneratedColumn<bool>(
      'finished', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("finished" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _collectionIdMeta =
      const VerificationMeta('collectionId');
  @override
  late final GeneratedColumn<String> collectionId = GeneratedColumn<String>(
      'collection_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        author,
        cover,
        path,
        language,
        progress,
        lastPositionJson,
        lastOpenedAt,
        favorite,
        finished,
        collectionId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_books';
  @override
  VerificationContext validateIntegrity(Insertable<StoredBook> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover']!, _coverMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('last_position_json')) {
      context.handle(
          _lastPositionJsonMeta,
          lastPositionJson.isAcceptableOrUnknown(
              data['last_position_json']!, _lastPositionJsonMeta));
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
          _lastOpenedAtMeta,
          lastOpenedAt.isAcceptableOrUnknown(
              data['last_opened_at']!, _lastOpenedAtMeta));
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    }
    if (data.containsKey('finished')) {
      context.handle(_finishedMeta,
          finished.isAcceptableOrUnknown(data['finished']!, _finishedMeta));
    }
    if (data.containsKey('collection_id')) {
      context.handle(
          _collectionIdMeta,
          collectionId.isAcceptableOrUnknown(
              data['collection_id']!, _collectionIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredBook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredBook(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      cover: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover']),
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language']),
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}progress'])!,
      lastPositionJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_position_json']),
      lastOpenedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_opened_at']),
      favorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}favorite'])!,
      finished: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}finished'])!,
      collectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}collection_id']),
    );
  }

  @override
  $StoredBooksTable createAlias(String alias) {
    return $StoredBooksTable(attachedDatabase, alias);
  }
}

class StoredBook extends DataClass implements Insertable<StoredBook> {
  final String id;
  final String? title;
  final String? author;
  final String? cover;
  final String path;
  final String? language;
  final double progress;
  final String? lastPositionJson;
  final DateTime? lastOpenedAt;
  final bool favorite;
  final bool finished;
  final String? collectionId;
  const StoredBook(
      {required this.id,
      this.title,
      this.author,
      this.cover,
      required this.path,
      this.language,
      required this.progress,
      this.lastPositionJson,
      this.lastOpenedAt,
      required this.favorite,
      required this.finished,
      this.collectionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || cover != null) {
      map['cover'] = Variable<String>(cover);
    }
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    map['progress'] = Variable<double>(progress);
    if (!nullToAbsent || lastPositionJson != null) {
      map['last_position_json'] = Variable<String>(lastPositionJson);
    }
    if (!nullToAbsent || lastOpenedAt != null) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    }
    map['favorite'] = Variable<bool>(favorite);
    map['finished'] = Variable<bool>(finished);
    if (!nullToAbsent || collectionId != null) {
      map['collection_id'] = Variable<String>(collectionId);
    }
    return map;
  }

  StoredBooksCompanion toCompanion(bool nullToAbsent) {
    return StoredBooksCompanion(
      id: Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      cover:
          cover == null && nullToAbsent ? const Value.absent() : Value(cover),
      path: Value(path),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      progress: Value(progress),
      lastPositionJson: lastPositionJson == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPositionJson),
      lastOpenedAt: lastOpenedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedAt),
      favorite: Value(favorite),
      finished: Value(finished),
      collectionId: collectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(collectionId),
    );
  }

  factory StoredBook.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredBook(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      cover: serializer.fromJson<String?>(json['cover']),
      path: serializer.fromJson<String>(json['path']),
      language: serializer.fromJson<String?>(json['language']),
      progress: serializer.fromJson<double>(json['progress']),
      lastPositionJson: serializer.fromJson<String?>(json['lastPositionJson']),
      lastOpenedAt: serializer.fromJson<DateTime?>(json['lastOpenedAt']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      finished: serializer.fromJson<bool>(json['finished']),
      collectionId: serializer.fromJson<String?>(json['collectionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String?>(title),
      'author': serializer.toJson<String?>(author),
      'cover': serializer.toJson<String?>(cover),
      'path': serializer.toJson<String>(path),
      'language': serializer.toJson<String?>(language),
      'progress': serializer.toJson<double>(progress),
      'lastPositionJson': serializer.toJson<String?>(lastPositionJson),
      'lastOpenedAt': serializer.toJson<DateTime?>(lastOpenedAt),
      'favorite': serializer.toJson<bool>(favorite),
      'finished': serializer.toJson<bool>(finished),
      'collectionId': serializer.toJson<String?>(collectionId),
    };
  }

  StoredBook copyWith(
          {String? id,
          Value<String?> title = const Value.absent(),
          Value<String?> author = const Value.absent(),
          Value<String?> cover = const Value.absent(),
          String? path,
          Value<String?> language = const Value.absent(),
          double? progress,
          Value<String?> lastPositionJson = const Value.absent(),
          Value<DateTime?> lastOpenedAt = const Value.absent(),
          bool? favorite,
          bool? finished,
          Value<String?> collectionId = const Value.absent()}) =>
      StoredBook(
        id: id ?? this.id,
        title: title.present ? title.value : this.title,
        author: author.present ? author.value : this.author,
        cover: cover.present ? cover.value : this.cover,
        path: path ?? this.path,
        language: language.present ? language.value : this.language,
        progress: progress ?? this.progress,
        lastPositionJson: lastPositionJson.present
            ? lastPositionJson.value
            : this.lastPositionJson,
        lastOpenedAt:
            lastOpenedAt.present ? lastOpenedAt.value : this.lastOpenedAt,
        favorite: favorite ?? this.favorite,
        finished: finished ?? this.finished,
        collectionId:
            collectionId.present ? collectionId.value : this.collectionId,
      );
  StoredBook copyWithCompanion(StoredBooksCompanion data) {
    return StoredBook(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      cover: data.cover.present ? data.cover.value : this.cover,
      path: data.path.present ? data.path.value : this.path,
      language: data.language.present ? data.language.value : this.language,
      progress: data.progress.present ? data.progress.value : this.progress,
      lastPositionJson: data.lastPositionJson.present
          ? data.lastPositionJson.value
          : this.lastPositionJson,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      finished: data.finished.present ? data.finished.value : this.finished,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredBook(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('cover: $cover, ')
          ..write('path: $path, ')
          ..write('language: $language, ')
          ..write('progress: $progress, ')
          ..write('lastPositionJson: $lastPositionJson, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('favorite: $favorite, ')
          ..write('finished: $finished, ')
          ..write('collectionId: $collectionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      author,
      cover,
      path,
      language,
      progress,
      lastPositionJson,
      lastOpenedAt,
      favorite,
      finished,
      collectionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredBook &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.cover == this.cover &&
          other.path == this.path &&
          other.language == this.language &&
          other.progress == this.progress &&
          other.lastPositionJson == this.lastPositionJson &&
          other.lastOpenedAt == this.lastOpenedAt &&
          other.favorite == this.favorite &&
          other.finished == this.finished &&
          other.collectionId == this.collectionId);
}

class StoredBooksCompanion extends UpdateCompanion<StoredBook> {
  final Value<String> id;
  final Value<String?> title;
  final Value<String?> author;
  final Value<String?> cover;
  final Value<String> path;
  final Value<String?> language;
  final Value<double> progress;
  final Value<String?> lastPositionJson;
  final Value<DateTime?> lastOpenedAt;
  final Value<bool> favorite;
  final Value<bool> finished;
  final Value<String?> collectionId;
  final Value<int> rowid;
  const StoredBooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.cover = const Value.absent(),
    this.path = const Value.absent(),
    this.language = const Value.absent(),
    this.progress = const Value.absent(),
    this.lastPositionJson = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
    this.favorite = const Value.absent(),
    this.finished = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredBooksCompanion.insert({
    required String id,
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.cover = const Value.absent(),
    required String path,
    this.language = const Value.absent(),
    this.progress = const Value.absent(),
    this.lastPositionJson = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
    this.favorite = const Value.absent(),
    this.finished = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        path = Value(path);
  static Insertable<StoredBook> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? cover,
    Expression<String>? path,
    Expression<String>? language,
    Expression<double>? progress,
    Expression<String>? lastPositionJson,
    Expression<DateTime>? lastOpenedAt,
    Expression<bool>? favorite,
    Expression<bool>? finished,
    Expression<String>? collectionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (cover != null) 'cover': cover,
      if (path != null) 'path': path,
      if (language != null) 'language': language,
      if (progress != null) 'progress': progress,
      if (lastPositionJson != null) 'last_position_json': lastPositionJson,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
      if (favorite != null) 'favorite': favorite,
      if (finished != null) 'finished': finished,
      if (collectionId != null) 'collection_id': collectionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredBooksCompanion copyWith(
      {Value<String>? id,
      Value<String?>? title,
      Value<String?>? author,
      Value<String?>? cover,
      Value<String>? path,
      Value<String?>? language,
      Value<double>? progress,
      Value<String?>? lastPositionJson,
      Value<DateTime?>? lastOpenedAt,
      Value<bool>? favorite,
      Value<bool>? finished,
      Value<String?>? collectionId,
      Value<int>? rowid}) {
    return StoredBooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      cover: cover ?? this.cover,
      path: path ?? this.path,
      language: language ?? this.language,
      progress: progress ?? this.progress,
      lastPositionJson: lastPositionJson ?? this.lastPositionJson,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      favorite: favorite ?? this.favorite,
      finished: finished ?? this.finished,
      collectionId: collectionId ?? this.collectionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (cover.present) {
      map['cover'] = Variable<String>(cover.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (lastPositionJson.present) {
      map['last_position_json'] = Variable<String>(lastPositionJson.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (finished.present) {
      map['finished'] = Variable<bool>(finished.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<String>(collectionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredBooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('cover: $cover, ')
          ..write('path: $path, ')
          ..write('language: $language, ')
          ..write('progress: $progress, ')
          ..write('lastPositionJson: $lastPositionJson, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('favorite: $favorite, ')
          ..write('finished: $finished, ')
          ..write('collectionId: $collectionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingProgressRowsTable extends ReadingProgressRows
    with TableInfo<$ReadingProgressRowsTable, ReadingProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _blockIdMeta =
      const VerificationMeta('blockId');
  @override
  late final GeneratedColumn<String> blockId = GeneratedColumn<String>(
      'block_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _offsetMeta = const VerificationMeta('offset');
  @override
  late final GeneratedColumn<int> offset = GeneratedColumn<int>(
      'offset', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
      'progress', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [bookId, chapterId, blockId, offset, progress, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_progress_rows';
  @override
  VerificationContext validateIntegrity(Insertable<ReadingProgressRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('block_id')) {
      context.handle(_blockIdMeta,
          blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta));
    } else if (isInserting) {
      context.missing(_blockIdMeta);
    }
    if (data.containsKey('offset')) {
      context.handle(_offsetMeta,
          offset.isAcceptableOrUnknown(data['offset']!, _offsetMeta));
    } else if (isInserting) {
      context.missing(_offsetMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bookId};
  @override
  ReadingProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingProgressRow(
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
      blockId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}block_id'])!,
      offset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}offset'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}progress'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ReadingProgressRowsTable createAlias(String alias) {
    return $ReadingProgressRowsTable(attachedDatabase, alias);
  }
}

class ReadingProgressRow extends DataClass
    implements Insertable<ReadingProgressRow> {
  final String bookId;
  final String chapterId;
  final String blockId;
  final int offset;
  final double progress;
  final DateTime updatedAt;
  const ReadingProgressRow(
      {required this.bookId,
      required this.chapterId,
      required this.blockId,
      required this.offset,
      required this.progress,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book_id'] = Variable<String>(bookId);
    map['chapter_id'] = Variable<String>(chapterId);
    map['block_id'] = Variable<String>(blockId);
    map['offset'] = Variable<int>(offset);
    map['progress'] = Variable<double>(progress);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReadingProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressRowsCompanion(
      bookId: Value(bookId),
      chapterId: Value(chapterId),
      blockId: Value(blockId),
      offset: Value(offset),
      progress: Value(progress),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingProgressRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingProgressRow(
      bookId: serializer.fromJson<String>(json['bookId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      blockId: serializer.fromJson<String>(json['blockId']),
      offset: serializer.fromJson<int>(json['offset']),
      progress: serializer.fromJson<double>(json['progress']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookId': serializer.toJson<String>(bookId),
      'chapterId': serializer.toJson<String>(chapterId),
      'blockId': serializer.toJson<String>(blockId),
      'offset': serializer.toJson<int>(offset),
      'progress': serializer.toJson<double>(progress),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReadingProgressRow copyWith(
          {String? bookId,
          String? chapterId,
          String? blockId,
          int? offset,
          double? progress,
          DateTime? updatedAt}) =>
      ReadingProgressRow(
        bookId: bookId ?? this.bookId,
        chapterId: chapterId ?? this.chapterId,
        blockId: blockId ?? this.blockId,
        offset: offset ?? this.offset,
        progress: progress ?? this.progress,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ReadingProgressRow copyWithCompanion(ReadingProgressRowsCompanion data) {
    return ReadingProgressRow(
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      offset: data.offset.present ? data.offset.value : this.offset,
      progress: data.progress.present ? data.progress.value : this.progress,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressRow(')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('blockId: $blockId, ')
          ..write('offset: $offset, ')
          ..write('progress: $progress, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(bookId, chapterId, blockId, offset, progress, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressRow &&
          other.bookId == this.bookId &&
          other.chapterId == this.chapterId &&
          other.blockId == this.blockId &&
          other.offset == this.offset &&
          other.progress == this.progress &&
          other.updatedAt == this.updatedAt);
}

class ReadingProgressRowsCompanion extends UpdateCompanion<ReadingProgressRow> {
  final Value<String> bookId;
  final Value<String> chapterId;
  final Value<String> blockId;
  final Value<int> offset;
  final Value<double> progress;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReadingProgressRowsCompanion({
    this.bookId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.blockId = const Value.absent(),
    this.offset = const Value.absent(),
    this.progress = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingProgressRowsCompanion.insert({
    required String bookId,
    required String chapterId,
    required String blockId,
    required int offset,
    required double progress,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : bookId = Value(bookId),
        chapterId = Value(chapterId),
        blockId = Value(blockId),
        offset = Value(offset),
        progress = Value(progress),
        updatedAt = Value(updatedAt);
  static Insertable<ReadingProgressRow> custom({
    Expression<String>? bookId,
    Expression<String>? chapterId,
    Expression<String>? blockId,
    Expression<int>? offset,
    Expression<double>? progress,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookId != null) 'book_id': bookId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (blockId != null) 'block_id': blockId,
      if (offset != null) 'offset': offset,
      if (progress != null) 'progress': progress,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingProgressRowsCompanion copyWith(
      {Value<String>? bookId,
      Value<String>? chapterId,
      Value<String>? blockId,
      Value<int>? offset,
      Value<double>? progress,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ReadingProgressRowsCompanion(
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
      blockId: blockId ?? this.blockId,
      offset: offset ?? this.offset,
      progress: progress ?? this.progress,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<String>(blockId.value);
    }
    if (offset.present) {
      map['offset'] = Variable<int>(offset.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressRowsCompanion(')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('blockId: $blockId, ')
          ..write('offset: $offset, ')
          ..write('progress: $progress, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarkRowsTable extends BookmarkRows
    with TableInfo<$BookmarkRowsTable, BookmarkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarkRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionJsonMeta =
      const VerificationMeta('positionJson');
  @override
  late final GeneratedColumn<String> positionJson = GeneratedColumn<String>(
      'position_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bookId, chapterId, positionJson, title, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmark_rows';
  @override
  VerificationContext validateIntegrity(Insertable<BookmarkRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('position_json')) {
      context.handle(
          _positionJsonMeta,
          positionJson.isAcceptableOrUnknown(
              data['position_json']!, _positionJsonMeta));
    } else if (isInserting) {
      context.missing(_positionJsonMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
      positionJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}position_json'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BookmarkRowsTable createAlias(String alias) {
    return $BookmarkRowsTable(attachedDatabase, alias);
  }
}

class BookmarkRow extends DataClass implements Insertable<BookmarkRow> {
  final String id;
  final String bookId;
  final String chapterId;
  final String positionJson;
  final String? title;
  final DateTime createdAt;
  const BookmarkRow(
      {required this.id,
      required this.bookId,
      required this.chapterId,
      required this.positionJson,
      this.title,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['chapter_id'] = Variable<String>(chapterId);
    map['position_json'] = Variable<String>(positionJson);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookmarkRowsCompanion toCompanion(bool nullToAbsent) {
    return BookmarkRowsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      chapterId: Value(chapterId),
      positionJson: Value(positionJson),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      createdAt: Value(createdAt),
    );
  }

  factory BookmarkRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkRow(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      positionJson: serializer.fromJson<String>(json['positionJson']),
      title: serializer.fromJson<String?>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'chapterId': serializer.toJson<String>(chapterId),
      'positionJson': serializer.toJson<String>(positionJson),
      'title': serializer.toJson<String?>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BookmarkRow copyWith(
          {String? id,
          String? bookId,
          String? chapterId,
          String? positionJson,
          Value<String?> title = const Value.absent(),
          DateTime? createdAt}) =>
      BookmarkRow(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        chapterId: chapterId ?? this.chapterId,
        positionJson: positionJson ?? this.positionJson,
        title: title.present ? title.value : this.title,
        createdAt: createdAt ?? this.createdAt,
      );
  BookmarkRow copyWithCompanion(BookmarkRowsCompanion data) {
    return BookmarkRow(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      positionJson: data.positionJson.present
          ? data.positionJson.value
          : this.positionJson,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkRow(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('positionJson: $positionJson, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, chapterId, positionJson, title, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkRow &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.chapterId == this.chapterId &&
          other.positionJson == this.positionJson &&
          other.title == this.title &&
          other.createdAt == this.createdAt);
}

class BookmarkRowsCompanion extends UpdateCompanion<BookmarkRow> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> chapterId;
  final Value<String> positionJson;
  final Value<String?> title;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BookmarkRowsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.positionJson = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarkRowsCompanion.insert({
    required String id,
    required String bookId,
    required String chapterId,
    required String positionJson,
    this.title = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        bookId = Value(bookId),
        chapterId = Value(chapterId),
        positionJson = Value(positionJson),
        createdAt = Value(createdAt);
  static Insertable<BookmarkRow> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? chapterId,
    Expression<String>? positionJson,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (positionJson != null) 'position_json': positionJson,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarkRowsCompanion copyWith(
      {Value<String>? id,
      Value<String>? bookId,
      Value<String>? chapterId,
      Value<String>? positionJson,
      Value<String?>? title,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return BookmarkRowsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
      positionJson: positionJson ?? this.positionJson,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (positionJson.present) {
      map['position_json'] = Variable<String>(positionJson.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkRowsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('positionJson: $positionJson, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnnotationRowsTable extends AnnotationRows
    with TableInfo<$AnnotationRowsTable, AnnotationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnnotationRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bookId, chapterId, payloadJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'annotation_rows';
  @override
  VerificationContext validateIntegrity(Insertable<AnnotationRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnnotationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnnotationRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AnnotationRowsTable createAlias(String alias) {
    return $AnnotationRowsTable(attachedDatabase, alias);
  }
}

class AnnotationRow extends DataClass implements Insertable<AnnotationRow> {
  final String id;
  final String bookId;
  final String chapterId;
  final String payloadJson;
  final DateTime createdAt;
  const AnnotationRow(
      {required this.id,
      required this.bookId,
      required this.chapterId,
      required this.payloadJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['chapter_id'] = Variable<String>(chapterId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AnnotationRowsCompanion toCompanion(bool nullToAbsent) {
    return AnnotationRowsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      chapterId: Value(chapterId),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
    );
  }

  factory AnnotationRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnnotationRow(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'chapterId': serializer.toJson<String>(chapterId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AnnotationRow copyWith(
          {String? id,
          String? bookId,
          String? chapterId,
          String? payloadJson,
          DateTime? createdAt}) =>
      AnnotationRow(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        chapterId: chapterId ?? this.chapterId,
        payloadJson: payloadJson ?? this.payloadJson,
        createdAt: createdAt ?? this.createdAt,
      );
  AnnotationRow copyWithCompanion(AnnotationRowsCompanion data) {
    return AnnotationRow(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnnotationRow(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, chapterId, payloadJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnnotationRow &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.chapterId == this.chapterId &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt);
}

class AnnotationRowsCompanion extends UpdateCompanion<AnnotationRow> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> chapterId;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AnnotationRowsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnnotationRowsCompanion.insert({
    required String id,
    required String bookId,
    required String chapterId,
    required String payloadJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        bookId = Value(bookId),
        chapterId = Value(chapterId),
        payloadJson = Value(payloadJson),
        createdAt = Value(createdAt);
  static Insertable<AnnotationRow> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? chapterId,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnnotationRowsCompanion copyWith(
      {Value<String>? id,
      Value<String>? bookId,
      Value<String>? chapterId,
      Value<String>? payloadJson,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AnnotationRowsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnotationRowsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectionRowsTable extends CollectionRows
    with TableInfo<$CollectionRowsTable, CollectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collection_rows';
  @override
  VerificationContext validateIntegrity(Insertable<CollectionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CollectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $CollectionRowsTable createAlias(String alias) {
    return $CollectionRowsTable(attachedDatabase, alias);
  }
}

class CollectionRow extends DataClass implements Insertable<CollectionRow> {
  final String id;
  final String name;
  const CollectionRow({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  CollectionRowsCompanion toCompanion(bool nullToAbsent) {
    return CollectionRowsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory CollectionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  CollectionRow copyWith({String? id, String? name}) => CollectionRow(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  CollectionRow copyWithCompanion(CollectionRowsCompanion data) {
    return CollectionRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionRow(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionRow &&
          other.id == this.id &&
          other.name == this.name);
}

class CollectionRowsCompanion extends UpdateCompanion<CollectionRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const CollectionRowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectionRowsCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<CollectionRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectionRowsCompanion copyWith(
      {Value<String>? id, Value<String>? name, Value<int>? rowid}) {
    return CollectionRowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionRowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ReaderDatabase extends GeneratedDatabase {
  _$ReaderDatabase(QueryExecutor e) : super(e);
  $ReaderDatabaseManager get managers => $ReaderDatabaseManager(this);
  late final $StoredBooksTable storedBooks = $StoredBooksTable(this);
  late final $ReadingProgressRowsTable readingProgressRows =
      $ReadingProgressRowsTable(this);
  late final $BookmarkRowsTable bookmarkRows = $BookmarkRowsTable(this);
  late final $AnnotationRowsTable annotationRows = $AnnotationRowsTable(this);
  late final $CollectionRowsTable collectionRows = $CollectionRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        storedBooks,
        readingProgressRows,
        bookmarkRows,
        annotationRows,
        collectionRows
      ];
}

typedef $$StoredBooksTableCreateCompanionBuilder = StoredBooksCompanion
    Function({
  required String id,
  Value<String?> title,
  Value<String?> author,
  Value<String?> cover,
  required String path,
  Value<String?> language,
  Value<double> progress,
  Value<String?> lastPositionJson,
  Value<DateTime?> lastOpenedAt,
  Value<bool> favorite,
  Value<bool> finished,
  Value<String?> collectionId,
  Value<int> rowid,
});
typedef $$StoredBooksTableUpdateCompanionBuilder = StoredBooksCompanion
    Function({
  Value<String> id,
  Value<String?> title,
  Value<String?> author,
  Value<String?> cover,
  Value<String> path,
  Value<String?> language,
  Value<double> progress,
  Value<String?> lastPositionJson,
  Value<DateTime?> lastOpenedAt,
  Value<bool> favorite,
  Value<bool> finished,
  Value<String?> collectionId,
  Value<int> rowid,
});

class $$StoredBooksTableFilterComposer
    extends Composer<_$ReaderDatabase, $StoredBooksTable> {
  $$StoredBooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastPositionJson => $composableBuilder(
      column: $table.lastPositionJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
      column: $table.lastOpenedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get finished => $composableBuilder(
      column: $table.finished, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get collectionId => $composableBuilder(
      column: $table.collectionId, builder: (column) => ColumnFilters(column));
}

class $$StoredBooksTableOrderingComposer
    extends Composer<_$ReaderDatabase, $StoredBooksTable> {
  $$StoredBooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastPositionJson => $composableBuilder(
      column: $table.lastPositionJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
      column: $table.lastOpenedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get favorite => $composableBuilder(
      column: $table.favorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get finished => $composableBuilder(
      column: $table.finished, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get collectionId => $composableBuilder(
      column: $table.collectionId,
      builder: (column) => ColumnOrderings(column));
}

class $$StoredBooksTableAnnotationComposer
    extends Composer<_$ReaderDatabase, $StoredBooksTable> {
  $$StoredBooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get cover =>
      $composableBuilder(column: $table.cover, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get lastPositionJson => $composableBuilder(
      column: $table.lastPositionJson, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
      column: $table.lastOpenedAt, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<bool> get finished =>
      $composableBuilder(column: $table.finished, builder: (column) => column);

  GeneratedColumn<String> get collectionId => $composableBuilder(
      column: $table.collectionId, builder: (column) => column);
}

class $$StoredBooksTableTableManager extends RootTableManager<
    _$ReaderDatabase,
    $StoredBooksTable,
    StoredBook,
    $$StoredBooksTableFilterComposer,
    $$StoredBooksTableOrderingComposer,
    $$StoredBooksTableAnnotationComposer,
    $$StoredBooksTableCreateCompanionBuilder,
    $$StoredBooksTableUpdateCompanionBuilder,
    (
      StoredBook,
      BaseReferences<_$ReaderDatabase, $StoredBooksTable, StoredBook>
    ),
    StoredBook,
    PrefetchHooks Function()> {
  $$StoredBooksTableTableManager(_$ReaderDatabase db, $StoredBooksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredBooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredBooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredBooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<double> progress = const Value.absent(),
            Value<String?> lastPositionJson = const Value.absent(),
            Value<DateTime?> lastOpenedAt = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> finished = const Value.absent(),
            Value<String?> collectionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StoredBooksCompanion(
            id: id,
            title: title,
            author: author,
            cover: cover,
            path: path,
            language: language,
            progress: progress,
            lastPositionJson: lastPositionJson,
            lastOpenedAt: lastOpenedAt,
            favorite: favorite,
            finished: finished,
            collectionId: collectionId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> title = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            required String path,
            Value<String?> language = const Value.absent(),
            Value<double> progress = const Value.absent(),
            Value<String?> lastPositionJson = const Value.absent(),
            Value<DateTime?> lastOpenedAt = const Value.absent(),
            Value<bool> favorite = const Value.absent(),
            Value<bool> finished = const Value.absent(),
            Value<String?> collectionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StoredBooksCompanion.insert(
            id: id,
            title: title,
            author: author,
            cover: cover,
            path: path,
            language: language,
            progress: progress,
            lastPositionJson: lastPositionJson,
            lastOpenedAt: lastOpenedAt,
            favorite: favorite,
            finished: finished,
            collectionId: collectionId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StoredBooksTableProcessedTableManager = ProcessedTableManager<
    _$ReaderDatabase,
    $StoredBooksTable,
    StoredBook,
    $$StoredBooksTableFilterComposer,
    $$StoredBooksTableOrderingComposer,
    $$StoredBooksTableAnnotationComposer,
    $$StoredBooksTableCreateCompanionBuilder,
    $$StoredBooksTableUpdateCompanionBuilder,
    (
      StoredBook,
      BaseReferences<_$ReaderDatabase, $StoredBooksTable, StoredBook>
    ),
    StoredBook,
    PrefetchHooks Function()>;
typedef $$ReadingProgressRowsTableCreateCompanionBuilder
    = ReadingProgressRowsCompanion Function({
  required String bookId,
  required String chapterId,
  required String blockId,
  required int offset,
  required double progress,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ReadingProgressRowsTableUpdateCompanionBuilder
    = ReadingProgressRowsCompanion Function({
  Value<String> bookId,
  Value<String> chapterId,
  Value<String> blockId,
  Value<int> offset,
  Value<double> progress,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ReadingProgressRowsTableFilterComposer
    extends Composer<_$ReaderDatabase, $ReadingProgressRowsTable> {
  $$ReadingProgressRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get blockId => $composableBuilder(
      column: $table.blockId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get offset => $composableBuilder(
      column: $table.offset, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ReadingProgressRowsTableOrderingComposer
    extends Composer<_$ReaderDatabase, $ReadingProgressRowsTable> {
  $$ReadingProgressRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get blockId => $composableBuilder(
      column: $table.blockId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get offset => $composableBuilder(
      column: $table.offset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ReadingProgressRowsTableAnnotationComposer
    extends Composer<_$ReaderDatabase, $ReadingProgressRowsTable> {
  $$ReadingProgressRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get blockId =>
      $composableBuilder(column: $table.blockId, builder: (column) => column);

  GeneratedColumn<int> get offset =>
      $composableBuilder(column: $table.offset, builder: (column) => column);

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReadingProgressRowsTableTableManager extends RootTableManager<
    _$ReaderDatabase,
    $ReadingProgressRowsTable,
    ReadingProgressRow,
    $$ReadingProgressRowsTableFilterComposer,
    $$ReadingProgressRowsTableOrderingComposer,
    $$ReadingProgressRowsTableAnnotationComposer,
    $$ReadingProgressRowsTableCreateCompanionBuilder,
    $$ReadingProgressRowsTableUpdateCompanionBuilder,
    (
      ReadingProgressRow,
      BaseReferences<_$ReaderDatabase, $ReadingProgressRowsTable,
          ReadingProgressRow>
    ),
    ReadingProgressRow,
    PrefetchHooks Function()> {
  $$ReadingProgressRowsTableTableManager(
      _$ReaderDatabase db, $ReadingProgressRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingProgressRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingProgressRowsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingProgressRowsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> bookId = const Value.absent(),
            Value<String> chapterId = const Value.absent(),
            Value<String> blockId = const Value.absent(),
            Value<int> offset = const Value.absent(),
            Value<double> progress = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadingProgressRowsCompanion(
            bookId: bookId,
            chapterId: chapterId,
            blockId: blockId,
            offset: offset,
            progress: progress,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String bookId,
            required String chapterId,
            required String blockId,
            required int offset,
            required double progress,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadingProgressRowsCompanion.insert(
            bookId: bookId,
            chapterId: chapterId,
            blockId: blockId,
            offset: offset,
            progress: progress,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReadingProgressRowsTableProcessedTableManager = ProcessedTableManager<
    _$ReaderDatabase,
    $ReadingProgressRowsTable,
    ReadingProgressRow,
    $$ReadingProgressRowsTableFilterComposer,
    $$ReadingProgressRowsTableOrderingComposer,
    $$ReadingProgressRowsTableAnnotationComposer,
    $$ReadingProgressRowsTableCreateCompanionBuilder,
    $$ReadingProgressRowsTableUpdateCompanionBuilder,
    (
      ReadingProgressRow,
      BaseReferences<_$ReaderDatabase, $ReadingProgressRowsTable,
          ReadingProgressRow>
    ),
    ReadingProgressRow,
    PrefetchHooks Function()>;
typedef $$BookmarkRowsTableCreateCompanionBuilder = BookmarkRowsCompanion
    Function({
  required String id,
  required String bookId,
  required String chapterId,
  required String positionJson,
  Value<String?> title,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$BookmarkRowsTableUpdateCompanionBuilder = BookmarkRowsCompanion
    Function({
  Value<String> id,
  Value<String> bookId,
  Value<String> chapterId,
  Value<String> positionJson,
  Value<String?> title,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$BookmarkRowsTableFilterComposer
    extends Composer<_$ReaderDatabase, $BookmarkRowsTable> {
  $$BookmarkRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get positionJson => $composableBuilder(
      column: $table.positionJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BookmarkRowsTableOrderingComposer
    extends Composer<_$ReaderDatabase, $BookmarkRowsTable> {
  $$BookmarkRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get positionJson => $composableBuilder(
      column: $table.positionJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BookmarkRowsTableAnnotationComposer
    extends Composer<_$ReaderDatabase, $BookmarkRowsTable> {
  $$BookmarkRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get positionJson => $composableBuilder(
      column: $table.positionJson, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BookmarkRowsTableTableManager extends RootTableManager<
    _$ReaderDatabase,
    $BookmarkRowsTable,
    BookmarkRow,
    $$BookmarkRowsTableFilterComposer,
    $$BookmarkRowsTableOrderingComposer,
    $$BookmarkRowsTableAnnotationComposer,
    $$BookmarkRowsTableCreateCompanionBuilder,
    $$BookmarkRowsTableUpdateCompanionBuilder,
    (
      BookmarkRow,
      BaseReferences<_$ReaderDatabase, $BookmarkRowsTable, BookmarkRow>
    ),
    BookmarkRow,
    PrefetchHooks Function()> {
  $$BookmarkRowsTableTableManager(_$ReaderDatabase db, $BookmarkRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarkRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarkRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarkRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> bookId = const Value.absent(),
            Value<String> chapterId = const Value.absent(),
            Value<String> positionJson = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BookmarkRowsCompanion(
            id: id,
            bookId: bookId,
            chapterId: chapterId,
            positionJson: positionJson,
            title: title,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String bookId,
            required String chapterId,
            required String positionJson,
            Value<String?> title = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BookmarkRowsCompanion.insert(
            id: id,
            bookId: bookId,
            chapterId: chapterId,
            positionJson: positionJson,
            title: title,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BookmarkRowsTableProcessedTableManager = ProcessedTableManager<
    _$ReaderDatabase,
    $BookmarkRowsTable,
    BookmarkRow,
    $$BookmarkRowsTableFilterComposer,
    $$BookmarkRowsTableOrderingComposer,
    $$BookmarkRowsTableAnnotationComposer,
    $$BookmarkRowsTableCreateCompanionBuilder,
    $$BookmarkRowsTableUpdateCompanionBuilder,
    (
      BookmarkRow,
      BaseReferences<_$ReaderDatabase, $BookmarkRowsTable, BookmarkRow>
    ),
    BookmarkRow,
    PrefetchHooks Function()>;
typedef $$AnnotationRowsTableCreateCompanionBuilder = AnnotationRowsCompanion
    Function({
  required String id,
  required String bookId,
  required String chapterId,
  required String payloadJson,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$AnnotationRowsTableUpdateCompanionBuilder = AnnotationRowsCompanion
    Function({
  Value<String> id,
  Value<String> bookId,
  Value<String> chapterId,
  Value<String> payloadJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$AnnotationRowsTableFilterComposer
    extends Composer<_$ReaderDatabase, $AnnotationRowsTable> {
  $$AnnotationRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AnnotationRowsTableOrderingComposer
    extends Composer<_$ReaderDatabase, $AnnotationRowsTable> {
  $$AnnotationRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AnnotationRowsTableAnnotationComposer
    extends Composer<_$ReaderDatabase, $AnnotationRowsTable> {
  $$AnnotationRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AnnotationRowsTableTableManager extends RootTableManager<
    _$ReaderDatabase,
    $AnnotationRowsTable,
    AnnotationRow,
    $$AnnotationRowsTableFilterComposer,
    $$AnnotationRowsTableOrderingComposer,
    $$AnnotationRowsTableAnnotationComposer,
    $$AnnotationRowsTableCreateCompanionBuilder,
    $$AnnotationRowsTableUpdateCompanionBuilder,
    (
      AnnotationRow,
      BaseReferences<_$ReaderDatabase, $AnnotationRowsTable, AnnotationRow>
    ),
    AnnotationRow,
    PrefetchHooks Function()> {
  $$AnnotationRowsTableTableManager(
      _$ReaderDatabase db, $AnnotationRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnnotationRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnnotationRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnnotationRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> bookId = const Value.absent(),
            Value<String> chapterId = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AnnotationRowsCompanion(
            id: id,
            bookId: bookId,
            chapterId: chapterId,
            payloadJson: payloadJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String bookId,
            required String chapterId,
            required String payloadJson,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AnnotationRowsCompanion.insert(
            id: id,
            bookId: bookId,
            chapterId: chapterId,
            payloadJson: payloadJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AnnotationRowsTableProcessedTableManager = ProcessedTableManager<
    _$ReaderDatabase,
    $AnnotationRowsTable,
    AnnotationRow,
    $$AnnotationRowsTableFilterComposer,
    $$AnnotationRowsTableOrderingComposer,
    $$AnnotationRowsTableAnnotationComposer,
    $$AnnotationRowsTableCreateCompanionBuilder,
    $$AnnotationRowsTableUpdateCompanionBuilder,
    (
      AnnotationRow,
      BaseReferences<_$ReaderDatabase, $AnnotationRowsTable, AnnotationRow>
    ),
    AnnotationRow,
    PrefetchHooks Function()>;
typedef $$CollectionRowsTableCreateCompanionBuilder = CollectionRowsCompanion
    Function({
  required String id,
  required String name,
  Value<int> rowid,
});
typedef $$CollectionRowsTableUpdateCompanionBuilder = CollectionRowsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<int> rowid,
});

class $$CollectionRowsTableFilterComposer
    extends Composer<_$ReaderDatabase, $CollectionRowsTable> {
  $$CollectionRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$CollectionRowsTableOrderingComposer
    extends Composer<_$ReaderDatabase, $CollectionRowsTable> {
  $$CollectionRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$CollectionRowsTableAnnotationComposer
    extends Composer<_$ReaderDatabase, $CollectionRowsTable> {
  $$CollectionRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$CollectionRowsTableTableManager extends RootTableManager<
    _$ReaderDatabase,
    $CollectionRowsTable,
    CollectionRow,
    $$CollectionRowsTableFilterComposer,
    $$CollectionRowsTableOrderingComposer,
    $$CollectionRowsTableAnnotationComposer,
    $$CollectionRowsTableCreateCompanionBuilder,
    $$CollectionRowsTableUpdateCompanionBuilder,
    (
      CollectionRow,
      BaseReferences<_$ReaderDatabase, $CollectionRowsTable, CollectionRow>
    ),
    CollectionRow,
    PrefetchHooks Function()> {
  $$CollectionRowsTableTableManager(
      _$ReaderDatabase db, $CollectionRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectionRowsCompanion(
            id: id,
            name: name,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectionRowsCompanion.insert(
            id: id,
            name: name,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CollectionRowsTableProcessedTableManager = ProcessedTableManager<
    _$ReaderDatabase,
    $CollectionRowsTable,
    CollectionRow,
    $$CollectionRowsTableFilterComposer,
    $$CollectionRowsTableOrderingComposer,
    $$CollectionRowsTableAnnotationComposer,
    $$CollectionRowsTableCreateCompanionBuilder,
    $$CollectionRowsTableUpdateCompanionBuilder,
    (
      CollectionRow,
      BaseReferences<_$ReaderDatabase, $CollectionRowsTable, CollectionRow>
    ),
    CollectionRow,
    PrefetchHooks Function()>;

class $ReaderDatabaseManager {
  final _$ReaderDatabase _db;
  $ReaderDatabaseManager(this._db);
  $$StoredBooksTableTableManager get storedBooks =>
      $$StoredBooksTableTableManager(_db, _db.storedBooks);
  $$ReadingProgressRowsTableTableManager get readingProgressRows =>
      $$ReadingProgressRowsTableTableManager(_db, _db.readingProgressRows);
  $$BookmarkRowsTableTableManager get bookmarkRows =>
      $$BookmarkRowsTableTableManager(_db, _db.bookmarkRows);
  $$AnnotationRowsTableTableManager get annotationRows =>
      $$AnnotationRowsTableTableManager(_db, _db.annotationRows);
  $$CollectionRowsTableTableManager get collectionRows =>
      $$CollectionRowsTableTableManager(_db, _db.collectionRows);
}
