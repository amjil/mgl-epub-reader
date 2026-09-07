import '../model/book.dart';
import 'epub_container.dart';
import 'epub_exception.dart';
import 'epub_navigation.dart';
import 'epub_package.dart';
import 'epub_path.dart';
import 'epub_source.dart';

class ParsedEpub {
  ParsedEpub({
    required this.archive,
    required this.container,
    required this.package,
    required this.book,
  });

  final EpubArchive archive;
  final EpubContainer container;
  final EpubPackage package;
  final EpubBook book;

  String resolveFromOpf(String href) =>
      resolveEpubHref(package.opfPath, href);
}

class EpubParser {
  Future<ParsedEpub> parse(EpubSource source) async {
    final bytes = await source.read();
    return parseBytes(bytes);
  }

  ParsedEpub parseBytes(List<int> bytes) {
    final archive = EpubArchive.fromBytes(bytes);
    final container = EpubContainer.parse(archive);
    final opfXml = archive.readString(container.rootfilePath);
    final package = EpubPackage.parse(opfXml, container.rootfilePath);

    String? navXml;
    String? ncxXml;
    final navItem = package.navItem;
    if (navItem != null) {
      navXml = archive.readStringOrNull(resolveEpubHref(package.opfPath, navItem.href));
    }
    final ncxItem = package.ncxItem;
    if (ncxItem != null) {
      ncxXml = archive.readStringOrNull(resolveEpubHref(package.opfPath, ncxItem.href));
    }

    final toc = EpubNavigation.parse(
      navXhtml: navXml,
      ncxXml: ncxXml,
      basePath: package.opfPath,
    );

    final titleByHref = <String, String>{};
    void collectTitles(List<EpubTocItem> items) {
      for (final item in items) {
        final href = stripFragment(item.href);
        if (href.isNotEmpty && !titleByHref.containsKey(href)) {
          titleByHref[href] = item.title;
        }
        collectTitles(item.children);
      }
    }

    collectTitles(toc);

    final chapters = <EpubChapter>[];
    var order = 0;
    for (final ref in package.spine) {
      final item = package.itemById(ref.idref);
      if (item == null || !item.isXhtml) continue;
      order += 1;
      final title = titleByHref[item.href] ??
          titleByHref[stripFragment(item.href)] ??
          item.id;
      chapters.add(
        EpubChapter(
          id: item.id,
          title: title,
          href: item.href,
          order: order,
          linear: ref.linear,
        ),
      );
    }
    if (chapters.isEmpty) {
      throw EpubSpineException('No readable XHTML chapters in spine');
    }

    final resources = <String, EpubResource>{};
    for (final item in package.manifest.values) {
      resources[item.id] = EpubResource(
        id: item.id,
        href: item.href,
        mediaType: item.mediaType,
        properties: item.properties,
      );
    }

    final meta = package.metadata;
    final book = EpubBook(
      id: meta.identifier ?? container.rootfilePath,
      title: meta.title,
      authors: meta.authors,
      language: meta.language,
      publisher: meta.publisher,
      description: meta.description,
      date: meta.date,
      cover: meta.cover,
      chapters: chapters,
      toc: toc,
      resources: resources,
    );

    return ParsedEpub(
      archive: archive,
      container: container,
      package: package,
      book: book,
    );
  }
}
