import '../epub/epub_exception.dart';
import '../epub/epub_loader.dart';
import '../epub/epub_parser.dart';
import '../epub/epub_path.dart';
import '../epub/epub_source.dart';
import '../model/book.dart';
import '../model/document.dart';
import '../model/position.dart';
import '../pagination/layout_cache.dart';
import '../pagination/page.dart';
import '../pagination/paginator.dart';
import '../resource/resource_loader.dart';
import '../search/search_engine.dart';
import '../resource/font_loader.dart';
import '../xhtml/css_parser.dart';
import '../xhtml/xhtml_parser.dart';
import '../xhtml/xhtml_to_document.dart';

abstract class MglEpubEngine {
  Future<EpubBook> open(List<int> bytes);

  Future<EpubChapter> loadChapter(String chapterId);

  Future<List<MglPage>> paginate(
    String chapterId,
    ReaderLayoutConfig config,
  );

  Future<List<int>> loadResource(String resourceId);

  Future<List<SearchResult>> search(String query);
}

class MglEpubEngineImpl implements MglEpubEngine {
  MglEpubEngineImpl({
    EpubLoader? loader,
    Paginator? paginator,
  })  : _loader = loader ?? EpubLoader(),
        _paginator = paginator ?? const DefaultPaginator();

  final EpubLoader _loader;
  final Paginator _paginator;
  final XhtmlParser _xhtmlParser = XhtmlParser();
  final CssParser _cssParser = CssParser();
  final SearchEngine _search = SearchEngine();
  final FontResolver _fonts = FontResolver();

  ParsedEpub? _parsed;
  ArchiveResourceLoader? _resources;
  CachedPaginator? _cachedPaginator;
  final Map<String, MglDocument> _documents = {};
  final Map<String, Object> _chapterErrors = {};

  EpubBook? get book => _parsed?.book;

  ArchiveResourceLoader? get resources => _resources;

  Future<EpubBook> openSource(EpubSource source) async {
    return open(await source.read());
  }

  @override
  Future<EpubBook> open(List<int> bytes) async {
    close();
    _parsed = _loader.openBytes(bytes);
    _resources = ArchiveResourceLoader(
      archive: _parsed!.archive,
      package: _parsed!.package,
    );
    _cachedPaginator = CachedPaginator(
      inner: _paginator,
      bookId: _parsed!.book.id,
    );
    await _loadEmbeddedFonts();
    return _parsed!.book;
  }

  Future<List<int>?> loadCoverBytes() async {
    final parsed = _parsed;
    final resources = _resources;
    if (parsed == null || resources == null) return null;
    final href = parsed.book.cover;
    if (href == null || href.isEmpty) return null;
    try {
      return await resources.loadHref(href);
    } catch (_) {
      try {
        return await resources.load(href);
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> _loadEmbeddedFonts() async {
    final parsed = _parsed;
    final resources = _resources;
    if (parsed == null || resources == null) return;
    for (final item in parsed.package.manifest.values) {
      if (!item.isFont) continue;
      try {
        await _fonts.loadEmbedded(
          family: item.id,
          resourceId: item.id,
          loader: resources,
        );
      } catch (_) {
        // Unknown or corrupt fonts must not block opening the book.
      }
    }
  }

  void close() {
    _parsed = null;
    _resources = null;
    _cachedPaginator?.cache.clear();
    _cachedPaginator = null;
    _documents.clear();
    _chapterErrors.clear();
  }

  @override
  Future<EpubChapter> loadChapter(String chapterId) async {
    final parsed = _require();
    final chapter = parsed.book.chapterById(chapterId);
    if (chapter == null) {
      throw EpubException('Unknown chapter: $chapterId');
    }
    final doc = await _documentFor(chapter);
    return chapter.withDocument(doc);
  }

  Future<MglDocument> documentFor(String chapterId) async {
    final chapter = await loadChapter(chapterId);
    return chapter.document!;
  }

  @override
  Future<List<MglPage>> paginate(
    String chapterId,
    ReaderLayoutConfig config,
  ) async {
    final doc = await documentFor(chapterId);
    return (_cachedPaginator ?? _paginator).paginate(doc, config);
  }

  @override
  Future<List<int>> loadResource(String resourceId) async {
    final loader = _resources;
    if (loader == null) {
      throw EpubResourceException('No open book');
    }
    return loader.load(resourceId);
  }

  @override
  Future<List<SearchResult>> search(String query) async {
    final parsed = _require();
    for (final chapter in parsed.book.chapters) {
      if (!_documents.containsKey(chapter.id)) {
        try {
          await _documentFor(chapter);
        } catch (_) {
          // Skip unreadable chapters; search still runs on loaded ones.
        }
      }
    }
    return _search.searchDocuments(_documents, query);
  }

  int pageIndexFor(List<MglPage> pages, ReaderPosition position) {
    for (var i = 0; i < pages.length; i++) {
      if (_contains(pages[i], position)) return i;
    }
    return 0;
  }

  bool _contains(MglPage page, ReaderPosition pos) {
    if (page.start.chapterId != pos.chapterId) return false;
    if (page.start.blockId == pos.blockId && page.end.blockId == pos.blockId) {
      return pos.offset >= page.start.offset && pos.offset <= page.end.offset;
    }
    final ids = page.blocks.map((b) => b.id).toList();
    final startIdx = ids.indexOf(page.start.blockId);
    final endIdx = ids.lastIndexOf(page.end.blockId);
    final idx = ids.indexOf(pos.blockId);
    if (idx < 0) return false;
    if (idx == startIdx && pos.offset < page.start.offset) return false;
    if (idx == endIdx && pos.offset > page.end.offset) return false;
    return idx >= startIdx && idx <= endIdx;
  }

  ParsedEpub _require() {
    final parsed = _parsed;
    if (parsed == null) {
      throw EpubException('No open book');
    }
    return parsed;
  }

  Future<MglDocument> _documentFor(EpubChapter chapter) async {
    final cached = _documents[chapter.id];
    if (cached != null) return cached;
    try {
      final parsed = _require();
      final abs = resolveEpubHref(parsed.package.opfPath, chapter.href);
      final xhtml = parsed.archive.readString(abs);
      final xdoc = _xhtmlParser.parse(xhtml, href: abs);
      final sheet = _stylesheetFor(xdoc, abs);
      final transformer = XhtmlToDocument(
        chapterId: chapter.id,
        stylesheet: sheet,
        resolveHref: (href) => resolveEpubHref(abs, href),
      );
      final doc = transformer.transform(xdoc);
      _documents[chapter.id] = doc;
      return doc;
    } catch (e) {
      _chapterErrors[chapter.id] = e;
      // Do not cache the fallback: a later retry can succeed if the archive
      // read was transient, and a cached dummy would hide the real chapter.
      return MglDocument(
        id: chapter.id,
        blocks: [
          MglBlock.paragraph(
            id: 'block-0001',
            spans: [
              MglTextSpan(
                text: 'Chapter unavailable',
              ),
            ],
          ),
        ],
      );
    }
  }

  CssStylesheet _stylesheetFor(XhtmlDocument xdoc, String chapterPath) {
    final parsed = _require();
    final rules = <CssRule>[];
    final parser = _cssParser;
    for (final el in xdoc.document.querySelectorAll('style')) {
      rules.addAll(parser.parse(el.text).rules);
    }
    for (final link in xdoc.document.querySelectorAll('link')) {
      final rel = (link.attributes['rel'] ?? '').toLowerCase();
      if (!rel.contains('stylesheet')) continue;
      final href = link.attributes['href'];
      if (href == null) continue;
      final path = resolveEpubHref(chapterPath, href);
      final css = parsed.archive.readStringOrNull(path);
      if (css == null) continue;
      rules.addAll(parser.parse(css).rules);
    }
    return CssStylesheet(rules);
  }

  EpubChapter? nextChapter(String chapterId) {
    final chapters = _require().book.chapters;
    final i = chapters.indexWhere((c) => c.id == chapterId);
    if (i < 0 || i + 1 >= chapters.length) return null;
    return chapters[i + 1];
  }

  EpubChapter? previousChapter(String chapterId) {
    final chapters = _require().book.chapters;
    final i = chapters.indexWhere((c) => c.id == chapterId);
    if (i <= 0) return null;
    return chapters[i - 1];
  }

  EpubChapter? chapterByHref(String href) => _require().book.chapterByHref(href);

  double progressFor({
    required String chapterId,
    required int pageIndex,
    required int pageCount,
  }) {
    final chapters = _require().book.chapters;
    if (chapters.isEmpty) return 0;
    final i = chapters.indexWhere((c) => c.id == chapterId);
    if (i < 0) return 0;
    final chapterShare = 1 / chapters.length;
    final within = pageCount <= 1 ? 0.0 : pageIndex / (pageCount - 1);
    return ((i + within) * chapterShare).clamp(0.0, 1.0);
  }
}
