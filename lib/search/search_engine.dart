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

  List<SearchResult> search(String query, {int limit = 40}) {
    final tokens = _tokens(query);
    if (tokens.isEmpty) return const [];
    final out = <SearchResult>[];
    for (final e in entries) {
      final hay = e.text.toLowerCase();
      if (tokens.length == 1) {
        final q = tokens.first;
        var from = 0;
        while (true) {
          final idx = hay.indexOf(q, from);
          if (idx < 0) break;
          out.add(_hit(e, idx, q.length));
          if (out.length >= limit) return out;
          from = idx + q.length;
        }
      } else if (tokens.every(hay.contains)) {
        final q = tokens.first;
        final idx = hay.indexOf(q);
        if (idx >= 0) {
          out.add(_hit(e, idx, q.length));
          if (out.length >= limit) return out;
        }
      }
    }
    return out;
  }

  static List<String> _tokens(String query) {
    return query
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static SearchResult _hit(TextIndexEntry e, int offset, int length) {
    return SearchResult(
      chapterId: e.chapterId,
      blockId: e.blockId,
      offset: offset,
      length: length,
      snippet: _snippet(e.text, offset, length),
    );
  }

  static int _clamp(int value, int max) {
    if (value < 0) return 0;
    if (value > max) return max;
    return value;
  }

  static String _snippet(String text, int offset, int length) {
    final start = _clamp(offset - 24, text.length);
    final end = _clamp(offset + length + 24, text.length);
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
  List<SearchResult> searchDocument(
    MglDocument document,
    String query, {
    int limit = 40,
  }) {
    return TextIndex.fromDocuments({document.id: document})
        .search(query, limit: limit);
  }

  List<SearchResult> searchDocuments(
    Map<String, MglDocument> documents,
    String query, {
    int limit = 40,
  }) {
    return TextIndex.fromDocuments(documents).search(query, limit: limit);
  }
}
