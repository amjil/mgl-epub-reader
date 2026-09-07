import '../epub/epub_path.dart';
import '../model/document.dart';
import '../model/position.dart';

class EpubMetadata {
  const EpubMetadata({
    this.identifier,
    this.title,
    this.authors = const [],
    this.language,
    this.publisher,
    this.description,
    this.date,
    this.cover,
  });

  final String? identifier;
  final String? title;
  final List<String> authors;
  final String? language;
  final String? publisher;
  final String? description;
  final DateTime? date;
  final String? cover;
}

class EpubManifestItem {
  const EpubManifestItem({
    required this.id,
    required this.href,
    required this.mediaType,
    this.properties = const {},
  });

  final String id;
  final String href;
  final String mediaType;
  final Set<String> properties;

  bool get isXhtml =>
      mediaType.contains('xhtml') ||
      mediaType == 'text/html' ||
      mediaType == 'application/xhtml+xml';

  bool get isNcx => mediaType == 'application/x-dtbncx+xml';

  bool get isNav => properties.contains('nav');

  bool get isCoverImage => properties.contains('cover-image');

  bool get isFont {
    final m = mediaType.toLowerCase();
    final h = href.toLowerCase();
    return m.contains('font') ||
        m.contains('opentype') ||
        m.contains('truetype') ||
        m.contains('woff') ||
        h.endsWith('.ttf') ||
        h.endsWith('.otf') ||
        h.endsWith('.woff') ||
        h.endsWith('.woff2');
  }
}

class EpubSpineItem {
  const EpubSpineItem({
    required this.idref,
    this.linear = true,
  });

  final String idref;
  final bool linear;
}

class EpubTocItem {
  const EpubTocItem({
    required this.id,
    required this.title,
    required this.href,
    this.children = const [],
  });

  final String id;
  final String title;
  final String href;
  final List<EpubTocItem> children;
}

class EpubResource {
  const EpubResource({
    required this.id,
    required this.href,
    required this.mediaType,
    this.properties = const {},
  });

  final String id;
  final String href;
  final String mediaType;
  final Set<String> properties;
}

class EpubChapter {
  const EpubChapter({
    required this.id,
    required this.title,
    required this.href,
    required this.order,
    this.linear = true,
    this.document,
  });

  final String id;
  final String title;
  final String href;
  final int order;
  final bool linear;
  final MglDocument? document;

  EpubChapter withDocument(MglDocument document) {
    return EpubChapter(
      id: id,
      title: title,
      href: href,
      order: order,
      linear: linear,
      document: document,
    );
  }
}

class EpubBook {
  const EpubBook({
    required this.id,
    this.title,
    this.authors = const [],
    this.language,
    this.publisher,
    this.description,
    this.date,
    this.cover,
    this.chapters = const [],
    this.toc = const [],
    this.resources = const {},
  });

  final String id;
  final String? title;
  final List<String> authors;
  final String? language;
  final String? publisher;
  final String? description;
  final DateTime? date;
  final String? cover;
  final List<EpubChapter> chapters;
  final List<EpubTocItem> toc;
  final Map<String, EpubResource> resources;

  bool get isMongolian {
    final lang = (language ?? '').toLowerCase();
    return lang.startsWith('mn') || lang.contains('mongol');
  }

  WritingMode get defaultWritingMode =>
      isMongolian ? WritingMode.vertical : WritingMode.horizontal;

  EpubChapter? chapterById(String id) {
    for (final c in chapters) {
      if (c.id == id) return c;
    }
    return null;
  }

  EpubChapter? chapterByHref(String href) {
    for (final c in chapters) {
      if (hrefsMatch(c.href, href)) return c;
    }
    return null;
  }
}
