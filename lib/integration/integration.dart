import '../annotation/annotation.dart';
import '../model/book.dart';

/// Quote + source metadata for mgl-block-editor / mgl-notes-app.
class NoteFromSelection {
  const NoteFromSelection({
    required this.quote,
    required this.source,
  });

  final String quote;
  final Map<String, dynamic> source;
}

NoteFromSelection createNoteFromSelection({
  required EpubBook book,
  required ReaderSelection selection,
  String? chapterTitle,
}) {
  return NoteFromSelection(
    quote: selection.text,
    source: {
      'type': 'epub',
      'book-id': book.id,
      'title': book.title,
      'author': book.authors.isEmpty ? null : book.authors.join(', '),
      'chapter-id': selection.chapterId,
      'chapter-title': chapterTitle,
      'position': selection.start.toJson(),
    },
  );
}

/// First version: interface only. Reader core does not depend on a provider.
abstract class MglEpubAiAdapter {
  Future<String> explain(ReaderSelection selection);

  Future<String> translate(ReaderSelection selection);

  Future<String> summarize(String chapterId);

  Future<String> askBook(String question);
}
