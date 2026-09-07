import '../model/document.dart';
import '../model/position.dart';

class SearchResult {
  const SearchResult({
    required this.chapterId,
    required this.blockId,
    required this.offset,
    required this.length,
    required this.snippet,
  });

  final String chapterId;
  final String blockId;
  final int offset;
  final int length;
  final String snippet;

  ReaderPosition get position => ReaderPosition(
        chapterId: chapterId,
        blockId: blockId,
        offset: offset,
      );
}

class TextIndex {
  TextIndex(this.entries);

  final List<TextIndexEntry> entries;

  factory TextIndex.fromDocuments(Map<String, MglDocument> documents) {
    final entries = <TextIndexEntry>[];
    for (final doc in documents.values) {
      for (final block in doc.flatten) {
        final text = block.plainText;
        if (text.trim().isEmpty) continue;
        entries.add(TextIndexEntry(doc.id, block.id, text));
      }
    }
    return TextIndex(entries);
  }

  List<SearchResult> search(String query, {int limit = 50}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final out = <SearchResult>[];
    for (final e in entries) {
      var from = 0;
      final hay = e.text.toLowerCase();
      while (true) {
        final idx = hay.indexOf(q, from);
        if (idx < 0) break;
        out.add(
          SearchResult(
            chapterId: e.chapterId,
            blockId: e.blockId,
            offset: idx,
            length: query.trim().length,
            snippet: _snippet(e.text, idx, query.trim().length),
          ),
        );
        if (out.length >= limit) return out;
        from = idx + q.length;
      }
    }
    return out;
  }

  static String _snippet(String text, int offset, int length) {
    final start = (offset - 24).clamp(0, text.length);
    final end = (offset + length + 24).clamp(0, text.length);
    var s = text.substring(start, end).replaceAll(RegExp(r'\s+'), ' ');
    if (start > 0) s = '…$s';
    if (end < text.length) s = '$s…';
    return s;
  }
}

class TextIndexEntry {
  TextIndexEntry(this.chapterId, this.blockId, this.text);

  final String chapterId;
  final String blockId;
  final String text;
}

class SearchEngine {
  List<SearchResult> searchDocuments(
    Map<String, MglDocument> documents,
    String query, {
    int limit = 50,
  }) {
    return TextIndex.fromDocuments(documents).search(query, limit: limit);
  }
}
