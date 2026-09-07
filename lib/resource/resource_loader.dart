import '../epub/epub_container.dart';
import '../epub/epub_exception.dart';
import '../epub/epub_package.dart';
import '../epub/epub_path.dart';

abstract class EpubResourceLoader {
  Future<List<int>> load(String resourceId);
}

class ArchiveResourceLoader implements EpubResourceLoader {
  ArchiveResourceLoader({
    required this.archive,
    required this.package,
  });

  final EpubArchive archive;
  final EpubPackage package;
  final Map<String, List<int>> _memory = {};

  String? hrefFor(String resourceId) {
    final byId = package.itemById(resourceId);
    if (byId != null) return byId.href;
    return resourceId;
  }

  String absolutePath(String href) => resolveEpubHref(package.opfPath, href);

  @override
  Future<List<int>> load(String resourceId) async {
    final cached = _memory[resourceId];
    if (cached != null) return cached;
    final href = hrefFor(resourceId) ?? resourceId;
    final candidates = <String>[
      resourceId,
      href,
      absolutePath(href),
    ];
    for (final path in candidates) {
      if (archive.contains(path)) {
        final bytes = archive.read(path);
        _memory[resourceId] = bytes;
        return bytes;
      }
    }
    throw EpubResourceException('Failed to load $resourceId');
  }

  Future<List<int>> loadHref(String href) async {
    final path = absolutePath(href);
    return archive.read(path);
  }

  String? loadStringHref(String href) {
    final path = absolutePath(href);
    return archive.readStringOrNull(path);
  }
}
