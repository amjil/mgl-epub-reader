import 'package:flutter/services.dart';

import '../epub/epub_exception.dart';
import '../resource/resource_loader.dart';

class FontResolver {
  FontResolver({this.systemFamily = 'OyunQaganTig'});

  final String systemFamily;
  final Map<String, String> _loaded = {};

  String get defaultFamily => systemFamily;

  List<String> get loadedFamilies => _loaded.values.toSet().toList();

  Future<String?> loadEmbedded({
    required String family,
    required String resourceId,
    required ArchiveResourceLoader loader,
  }) async {
    if (_loaded.containsKey(resourceId)) return _loaded[resourceId];
    try {
      final bytes = await loader.load(resourceId);
      final data = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
      final fontLoader = FontLoader(family);
      fontLoader.addFont(Future.value(ByteData.sublistView(data)));
      await fontLoader.load();
      _loaded[resourceId] = family;
      return family;
    } catch (e) {
      throw EpubResourceException('Failed to load font $resourceId', e);
    }
  }
}

class ImageLoader {
  ImageLoader(this._loader);

  final ArchiveResourceLoader _loader;
  final Map<String, List<int>> _cache = {};

  Future<List<int>> load(String resourceId) async {
    final cached = _cache[resourceId];
    if (cached != null) return cached;
    final bytes = await _loader.load(resourceId);
    _cache[resourceId] = bytes;
    return bytes;
  }

  void clear() => _cache.clear();
}
