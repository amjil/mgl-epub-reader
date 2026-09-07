import '../model/position.dart';
import 'page.dart';
import 'paginator.dart';

class LayoutCache {
  final Map<String, List<MglPage>> _pages = {};
  ReaderLayoutConfig? _config;

  List<MglPage>? get(String key) => _pages[key];

  void put(String key, List<MglPage> pages) => _pages[key] = pages;

  void invalidateIfConfigChanged(ReaderLayoutConfig config) {
    if (_config != null && _config != config) {
      _pages.clear();
    }
    _config = config;
  }

  void clear() {
    _pages.clear();
    _config = null;
  }
}

class CachedPaginator implements Paginator {
  CachedPaginator({Paginator? inner, required this.bookId})
      : _inner = inner ?? const DefaultPaginator();

  final Paginator _inner;
  final String bookId;
  final LayoutCache cache = LayoutCache();

  @override
  List<MglPage> paginate(document, ReaderLayoutConfig config) {
    cache.invalidateIfConfigChanged(config);
    final key = config.cacheKey(bookId: bookId, chapterId: document.id);
    final hit = cache.get(key);
    if (hit != null) return hit;
    final pages = _inner.paginate(document, config);
    cache.put(key, pages);
    return pages;
  }
}
