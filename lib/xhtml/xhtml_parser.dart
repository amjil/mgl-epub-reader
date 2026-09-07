import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;

class XhtmlDocument {
  XhtmlDocument(this.document, {this.href = ''});

  final html_dom.Document document;
  final String href;

  html_dom.Element? get body => document.body ?? document.documentElement;

  Iterable<html_dom.Element> get stylesheets =>
      document.querySelectorAll('link[rel="stylesheet"], style');
}

class XhtmlParser {
  XhtmlDocument parse(String input, {String href = ''}) {
    return XhtmlDocument(html_parser.parse(input), href: href);
  }
}

class XhtmlNormalizer {
  html_dom.Element normalize(html_dom.Element root) {
    _strip(root, {'script', 'noscript'});
    return root;
  }

  void _strip(html_dom.Node node, Set<String> tags) {
    if (node is! html_dom.Element) return;
    final remove = <html_dom.Node>[];
    for (final child in node.nodes) {
      if (child is html_dom.Element && tags.contains(child.localName)) {
        remove.add(child);
      } else {
        _strip(child, tags);
      }
    }
    for (final n in remove) {
      n.remove();
    }
  }
}
