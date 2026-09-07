import 'package:drift/drift.dart';

class StoredBooks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().nullable()();
  TextColumn get author => text().nullable()();
  TextColumn get cover => text().nullable()();
  TextColumn get path => text()();
  TextColumn get language => text().nullable()();
  RealColumn get progress => real().withDefault(const Constant(0.0))();
  TextColumn get lastPositionJson => text().nullable()();
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  BoolColumn get finished => boolean().withDefault(const Constant(false))();
  TextColumn get collectionId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ReadingProgressRows extends Table {
  TextColumn get bookId => text()();
  TextColumn get chapterId => text()();
  TextColumn get blockId => text()();
  IntColumn get offset => integer()();
  RealColumn get progress => real()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {bookId};
}

class BookmarkRows extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text()();
  TextColumn get chapterId => text()();
  TextColumn get positionJson => text()();
  TextColumn get title => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AnnotationRows extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text()();
  TextColumn get chapterId => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class CollectionRows extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}
