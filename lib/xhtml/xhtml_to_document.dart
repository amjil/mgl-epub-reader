import 'package:html/dom.dart' as html_dom;

import '../model/document.dart';
import 'css_parser.dart';
import 'xhtml_parser.dart';

typedef HrefResolver = String Function(String href);

class XhtmlToDocument {
  XhtmlToDocument({
    required this.chapterId,
    this.stylesheet = CssStylesheet.empty,
    this.resolveHref,
    CssParser? cssParser,
  }) : _cssParser = cssParser ?? CssParser();

  final String chapterId;
  final CssStylesheet stylesheet;
  final HrefResolver? resolveHref;
  final CssParser _cssParser;

  int _seq = 0;

  String _nextId() {
    _seq += 1;
    return 'block-${_seq.toString().padLeft(4, '0')}';
  }

  String _blockId(html_dom.Element node) {
    final id = node.id.trim();
    return id.isEmpty ? _nextId() : id;
  }

  MglDocument transform(XhtmlDocument document) {
    _seq = 0;
    final body = document.body;
    if (body == null) {
      return MglDocument(id: chapterId, blocks: const []);
    }
    XhtmlNormalizer().normalize(body);
    return MglDocument(id: chapterId, blocks: _blocks(body));
  }

  List<MglBlock> _blocks(html_dom.Element parent) {
    final out = <MglBlock>[];
    final inlineBuf = <MglTextSpan>[];

    void flushInline() {
      final spans = _compact(inlineBuf);
      inlineBuf.clear();
      if (spans.isEmpty) return;
      if (spans.every((s) => s.text.trim().isEmpty)) return;
      out.add(MglBlock.paragraph(id: _nextId(), spans: spans));
    }

    for (final node in parent.nodes) {
      if (node is html_dom.Text) {
        final t = _decode(node.text);
        if (t.isEmpty) continue;
        inlineBuf.add(MglTextSpan(text: t));
        continue;
      }
      if (node is! html_dom.Element) continue;
      final tag = (node.localName ?? '').toLowerCase();
      final css = _cssFor(node, tag);
      if (css['display'] == 'none') continue;

      if (_isHeading(tag)) {
        flushInline();
        out.add(
          MglBlock.heading(
            id: _blockId(node),
            level: int.parse(tag.substring(1)),
            spans: _inlines(node, MglTextStyle.empty),
            style: blockStyleFromCss(css),
          ),
        );
        continue;
      }

      switch (tag) {
        case 'p':
          flushInline();
          out.addAll(_paragraphLike(node, MglBlockType.paragraph, css));
        case 'blockquote':
          flushInline();
          out.addAll(_paragraphLike(node, MglBlockType.quote, css));
        case 'pre':
          flushInline();
          out.add(
            MglBlock.code(
              id: _blockId(node),
              spans: [MglTextSpan(text: node.text)],
            ),
          );
        case 'code':
          if (node.parent?.localName != 'pre') {
            flushInline();
            out.add(
              MglBlock.code(
                id: _blockId(node),
                spans: [MglTextSpan(text: node.text)],
              ),
            );
          }
        case 'ul':
        case 'ol':
          flushInline();
          out.add(_list(node, ordered: tag == 'ol'));
        case 'li':
          flushInline();
          out.add(
            MglBlock.listItem(
              id: _blockId(node),
              spans: _inlines(node, MglTextStyle.empty),
              children: _nestedBlocks(node),
            ),
          );
        case 'img':
        case 'image':
          flushInline();
          final image = _image(node);
          if (image != null) out.add(image);
        case 'hr':
          flushInline();
          out.add(MglBlock.horizontalRule(id: _blockId(node)));
        case 'br':
          inlineBuf.add(const MglTextSpan(text: '\n'));
        case 'div':
        case 'section':
        case 'article':
        case 'main':
        case 'header':
        case 'footer':
        case 'aside':
        case 'figure':
        case 'figcaption':
        case 'nav':
        case 'body':
          flushInline();
          out.addAll(_blocks(node));
        case 'table':
          flushInline();
          out.addAll(_table(node));
        case 'svg':
          continue;
        default:
          if (_isInline(tag)) {
            inlineBuf.addAll(_inlines(node, _tagStyle(tag, css)));
          } else {
            flushInline();
            out.addAll(_blocks(node));
          }
      }
    }
    flushInline();
    return out;
  }

  List<MglBlock> _paragraphLike(
    html_dom.Element node,
    MglBlockType type,
    Map<String, String> css,
  ) {
    final spans = _inlines(node, MglTextStyle.empty);
    final images = node.querySelectorAll('img');
    final blocks = <MglBlock>[];
    if (spans.any((s) => s.text.trim().isNotEmpty)) {
      if (type == MglBlockType.quote) {
        blocks.add(
          MglBlock.quote(
            id: _blockId(node),
            spans: spans,
            style: blockStyleFromCss(css),
          ),
        );
      } else {
        blocks.add(
          MglBlock.paragraph(
            id: _blockId(node),
            spans: spans,
            style: blockStyleFromCss(css),
          ),
        );
      }
    }
    for (final img in images) {
      final image = _image(img);
      if (image != null) blocks.add(image);
    }
    if (blocks.isEmpty && images.isEmpty) {
      blocks.add(
        MglBlock.paragraph(
          id: _blockId(node),
          spans: spans.isEmpty ? [const MglTextSpan(text: '')] : spans,
          style: blockStyleFromCss(css),
        ),
      );
    }
    return blocks;
  }

  MglBlock _list(html_dom.Element node, {required bool ordered}) {
    final items = <MglBlock>[];
    for (final child in node.children) {
      if (child.localName != 'li') continue;
      items.add(
        MglBlock.listItem(
          id: _blockId(child),
          spans: _inlines(child, MglTextStyle.empty),
          children: _nestedBlocks(child),
        ),
      );
    }
    return MglBlock.list(id: _blockId(node), children: items, ordered: ordered);
  }

  List<MglBlock> _nestedBlocks(html_dom.Element li) {
    final nested = <MglBlock>[];
    for (final child in li.children) {
      final tag = child.localName ?? '';
      if (tag == 'ul' || tag == 'ol') {
        nested.add(_list(child, ordered: tag == 'ol'));
      }
    }
    return nested;
  }

  List<MglBlock> _table(html_dom.Element table) {
    final rows = table.querySelectorAll('tr');
    final blocks = <MglBlock>[];
    for (final row in rows) {
      final cells = row.querySelectorAll('th,td');
      final text = cells.map((c) => c.text.trim()).where((t) => t.isNotEmpty).join(' · ');
      if (text.isEmpty) continue;
      blocks.add(
        MglBlock.paragraph(
          id: _blockId(row),
          spans: [MglTextSpan(text: text)],
        ),
      );
    }
    return blocks;
  }

  MglBlock? _image(html_dom.Element node) {
    final src = node.attributes['src'] ??
        node.attributes['href'] ??
        node.attributes['xlink:href'];
    if (src == null || src.isEmpty) return null;
    final resolved = resolveHref?.call(src) ?? src;
    return MglBlock.image(
      id: _blockId(node),
      resourceId: resolved,
      width: double.tryParse(node.attributes['width'] ?? ''),
      height: double.tryParse(node.attributes['height'] ?? ''),
      alt: node.attributes['alt'],
    );
  }

  List<MglTextSpan> _inlines(html_dom.Element node, MglTextStyle inherited) {
    final out = <MglTextSpan>[];
    for (final child in node.nodes) {
      if (child is html_dom.Text) {
        final t = _decode(child.text);
        if (t.isEmpty) continue;
        out.add(MglTextSpan(text: t, style: inherited));
        continue;
      }
      if (child is! html_dom.Element) continue;
      final tag = (child.localName ?? '').toLowerCase();
      if (tag == 'br') {
        out.add(MglTextSpan(text: '\n', style: inherited));
        continue;
      }
      if (tag == 'img' || tag == 'image') continue;
      if (tag == 'ul' || tag == 'ol' || tag == 'table') continue;
      final css = _cssFor(child, tag);
      if (css['display'] == 'none') continue;
      var style = inherited.merge(_tagStyle(tag, css));
      style = textStyleFromCss(css, style);
      final href = tag == 'a' ? child.attributes['href'] : null;
      final inner = _inlines(child, style);
      if (inner.isEmpty) continue;
      if (href != null && href.isNotEmpty) {
        for (final span in inner) {
          out.add(MglTextSpan(text: span.text, style: span.style, href: href));
        }
      } else {
        out.addAll(inner);
      }
    }
    return _compact(out);
  }

  Map<String, String> _cssFor(html_dom.Element node, String tag) {
    final id = node.id.isEmpty ? null : node.id;
    final classes = node.className
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toSet();
    final fromSheet = stylesheet.match(tag: tag, id: id, classes: classes);
    final styleAttr = node.attributes['style'];
    if (styleAttr == null || styleAttr.isEmpty) return fromSheet;
    final inline = _cssParser.parseDeclarations(styleAttr);
    return {...fromSheet, ...inline};
  }

  MglTextStyle _tagStyle(String tag, Map<String, String> css) {
    var style = textStyleFromCss(css);
    switch (tag) {
      case 'strong':
      case 'b':
        style = style.merge(const MglTextStyle(bold: true));
      case 'em':
      case 'i':
      case 'cite':
        style = style.merge(const MglTextStyle(italic: true));
      case 'u':
        style = style.merge(const MglTextStyle(underline: true));
    }
    return style;
  }

  List<MglTextSpan> _compact(List<MglTextSpan> spans) {
    if (spans.isEmpty) return spans;
    final out = <MglTextSpan>[];
    for (final s in spans) {
      if (out.isNotEmpty) {
        final last = out.last;
        if (last.href == s.href &&
            last.style.bold == s.style.bold &&
            last.style.italic == s.style.italic &&
            last.style.underline == s.style.underline &&
            last.style.color == s.style.color &&
            last.style.backgroundColor == s.style.backgroundColor &&
            last.style.fontFamily == s.style.fontFamily &&
            last.style.fontSize == s.style.fontSize) {
          out[out.length - 1] = MglTextSpan(
            text: last.text + s.text,
            style: last.style,
            href: last.href,
          );
          continue;
        }
      }
      out.add(s);
    }
    return out;
  }

  bool _isHeading(String tag) =>
      tag.length == 2 && tag.startsWith('h') && '123456'.contains(tag[1]);

  bool _isInline(String tag) => const {
        'a',
        'span',
        'em',
        'strong',
        'b',
        'i',
        'u',
        'small',
        'sub',
        'sup',
        'abbr',
        'cite',
        'code',
        'q',
        'mark',
        'time',
        'ruby',
        'rt',
        'rb',
      }.contains(tag);

  String _decode(String raw) {
    return raw.replaceAll('\u00a0', ' ').replaceAll(RegExp(r'\s+'), ' ');
  }
}
