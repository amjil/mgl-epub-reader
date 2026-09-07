import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

List<XmlElement> elementsByLocal(XmlNode node, String localName) {
  return node.childElements.where((e) => e.localName == localName).toList();
}

List<XmlElement> descendantsByLocal(XmlNode node, String localName) {
  return node.descendants
      .whereType<XmlElement>()
      .where((e) => e.localName == localName)
      .toList();
}

XmlElement? firstDescendant(XmlNode node, String localName) {
  final found = descendantsByLocal(node, localName);
  return found.isEmpty ? null : found.first;
}

String? attr(XmlElement el, String name) {
  for (final a in el.attributes) {
    if (a.localName == name) return a.value;
  }
  return null;
}

String textOf(XmlElement? el) => el?.innerText.trim() ?? '';

/// Resolve an EPUB href relative to a file (usually the OPF or chapter).
String resolveEpubHref(String basePath, String href) {
  final hash = href.indexOf('#');
  final pathPart = hash >= 0 ? href.substring(0, hash) : href;
  if (pathPart.isEmpty) {
    return p.normalize(basePath.replaceAll('\\', '/'));
  }
  final baseDir = p.posix.dirname(basePath.replaceAll('\\', '/'));
  if (baseDir == '.' || baseDir == '/') {
    return p.posix.normalize(pathPart);
  }
  return p.posix.normalize(p.posix.join(baseDir, pathPart));
}

String stripFragment(String href) {
  final hash = href.indexOf('#');
  return hash >= 0 ? href.substring(0, hash) : href;
}

/// TOC hrefs often include a fragment or a path relative to the OPF.
bool hrefsMatch(String a, String b) {
  String norm(String href) => stripFragment(href).replaceAll('\\', '/');
  final left = norm(a);
  final right = norm(b);
  if (left.isEmpty || right.isEmpty) return false;
  if (left == right) return true;
  if (left.endsWith('/$right') || right.endsWith('/$left')) return true;
  return p.posix.basename(left) == p.posix.basename(right);
}

String? fragmentOf(String href) {
  final hash = href.indexOf('#');
  return hash >= 0 ? href.substring(hash + 1) : null;
}

DateTime? tryParseDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  return DateTime.tryParse(raw.trim());
}

String posixJoin(String a, String b) => p.posix.normalize(p.posix.join(a, b));
