import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:xml/xml.dart';

import '../model/book.dart';
import 'epub_path.dart';

class EpubNavigation {
  static List<EpubTocItem> parse({
    required String? navXhtml,
    required String? ncxXml,
    required String basePath,
  }) {
    if (navXhtml != null && navXhtml.trim().isNotEmpty) {
      final items = _parseNav(navXhtml, basePath);
      if (items.isNotEmpty) return items;
    }
    if (ncxXml != null && ncxXml.trim().isNotEmpty) {
      return _parseNcx(ncxXml, basePath);
    }
    return const [];
  }

  static List<EpubTocItem> _parseNcx(String xml, String basePath) {
    final doc = XmlDocument.parse(xml);
    final navMap = firstDescendant(doc, 'navMap');
    if (navMap == null) return const [];
    return _ncxPoints(navMap, basePath, 0).$1;
  }

  static (List<EpubTocItem>, int) _ncxPoints(
    XmlElement parent,
    String basePath,
    int counter,
  ) {
    final items = <EpubTocItem>[];
    var i = counter;
    for (final point in parent.childElements) {
      if (point.localName != 'navPoint') continue;
      i += 1;
      final label = firstDescendant(point, 'text');
      final content = firstDescendant(point, 'content');
      final href = attr(content ?? point, 'src') ?? '';
      final id = attr(point, 'id') ?? 'toc-$i';
      final nested = _ncxPoints(point, basePath, i);
      i = nested.$2;
      items.add(
        EpubTocItem(
          id: id,
          title: textOf(label).isEmpty ? 'Untitled' : textOf(label),
          href: href,
          children: nested.$1,
        ),
      );
    }
    return (items, i);
  }

  static List<EpubTocItem> _parseNav(String xhtml, String basePath) {
    final doc = html_parser.parse(xhtml);
    html_dom.Element? tocNav;
    for (final nav in doc.querySelectorAll('nav')) {
      final type = (nav.attributes['epub:type'] ??
              nav.attributes['type'] ??
              '')
          .toLowerCase();
      if (type.contains('toc') || tocNav == null) {
        tocNav = nav;
        if (type.contains('toc')) break;
      }
    }
    if (tocNav == null) return const [];
    final ol = tocNav.querySelector('ol');
    if (ol == null) return const [];
    return _navList(ol, 0).$1;
  }

  static (List<EpubTocItem>, int) _navList(html_dom.Element ol, int counter) {
    final items = <EpubTocItem>[];
    var i = counter;
    for (final li in ol.children.where((e) => e.localName == 'li')) {
      i += 1;
      final a = li.querySelector('a');
      final span = li.querySelector('span');
      final title = (a?.text ?? span?.text ?? li.text).trim();
      final href = a?.attributes['href'] ?? '';
      final nestedOl = li.children.where((e) => e.localName == 'ol');
      var children = const <EpubTocItem>[];
      if (nestedOl.isNotEmpty) {
        final nested = _navList(nestedOl.first, i);
        children = nested.$1;
        i = nested.$2;
      }
      items.add(
        EpubTocItem(
          id: a?.attributes['id'] ?? 'toc-$i',
          title: title.isEmpty ? 'Untitled' : title,
          href: href,
          children: children,
        ),
      );
    }
    return (items, i);
  }
}
