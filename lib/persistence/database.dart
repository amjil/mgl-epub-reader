import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    StoredBooks,
    ReadingProgressRows,
    BookmarkRows,
    AnnotationRows,
    CollectionRows,
  ],
)
class ReaderDatabase extends _$ReaderDatabase {
  ReaderDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _open() {
    return driftDatabase(
      name: 'mgl_epub_reader',
      native: DriftNativeOptions(
        databasePath: () async {
          final dir = await getApplicationSupportDirectory();
          return p.join(dir.path, 'mgl_epub_reader.sqlite');
        },
      ),
    );
  }
}
