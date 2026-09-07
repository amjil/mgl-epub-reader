import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

import 'epub_exception.dart';
import 'epub_path.dart';

/// In-memory EPUB ZIP. Paths are normalized to posix, leading `./` stripped.
class EpubArchive {
  EpubArchive(this._archive);

  final Archive _archive;
  Map<String, ArchiveFile>? _index;

  factory EpubArchive.fromBytes(List<int> bytes) {
    late Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (e) {
      throw EpubInvalidArchiveException('Not a valid ZIP/EPUB archive', e);
    }
    if (archive.files.isEmpty) {
      throw EpubInvalidArchiveException('Empty EPUB archive');
    }
    return EpubArchive(archive);
  }

  Map<String, ArchiveFile> get _files {
    if (_index != null) return _index!;
    final map = <String, ArchiveFile>{};
    for (final file in _archive.files) {
      if (!file.isFile) continue;
      map[_norm(file.name)] = file;
    }
    _index = map;
    return map;
  }

  static String _norm(String name) {
    var n = name.replaceAll('\\', '/');
    if (n.startsWith('./')) n = n.substring(2);
    if (n.startsWith('/')) n = n.substring(1);
    return n;
  }

  bool contains(String path) => _files.containsKey(_norm(path));

  /// Try id, manifest href, then a raw archive path.
  String? findPath(String key) {
    if (contains(key)) return _norm(key);
    return findIgnoreCase(key);
  }

  List<int> read(String path) {
    final file = _files[_norm(path)];
    if (file == null) {
      throw EpubResourceException('Missing resource: $path');
    }
    return file.content;
  }

  String readString(String path) => utf8.decode(read(path));

  String? readStringOrNull(String path) {
    if (!contains(path)) return null;
    return readString(path);
  }

  String? findIgnoreCase(String path) {
    final wanted = _norm(path).toLowerCase();
    for (final key in _files.keys) {
      if (key.toLowerCase() == wanted) return key;
    }
    return null;
  }
}

class EpubContainer {
  EpubContainer({required this.rootfilePath});

  final String rootfilePath;

  static const containerPath = 'META-INF/container.xml';

  factory EpubContainer.parse(EpubArchive archive) {
    final xml = archive.readStringOrNull(containerPath);
    if (xml == null) {
      throw EpubContainerException('Missing META-INF/container.xml');
    }
    try {
      final doc = XmlDocument.parse(xml);
      final rootfile = firstDescendant(doc, 'rootfile');
      if (rootfile == null) {
        throw EpubContainerException('container.xml has no rootfile');
      }
      final fullPath = attr(rootfile, 'full-path');
      if (fullPath == null || fullPath.isEmpty) {
        throw EpubContainerException('container.xml has no rootfile full-path');
      }
      return EpubContainer(rootfilePath: EpubArchive._norm(fullPath));
    } catch (e) {
      if (e is EpubException) rethrow;
      throw EpubContainerException('Invalid container.xml', e);
    }
  }
}
