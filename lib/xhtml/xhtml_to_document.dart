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
  final Map<String, DocAnchor> _anchors = {};
  final List<_InlineMark> _inlineMarks = [];
  final List<String> _pendingIds = [];

  static const int _maxAnchorChars = 1600;

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
    _anchors.clear();
    _inlineMarks.clear();
    _pendingIds.clear();
    final body = document.body;
    if (body == null) {
      return MglDocument(id: chapterId, blocks: const []);
    }
    XhtmlNormalizer().normalize(body);
    return MglDocument(
      id: chapterId,
      blocks: _blocks(body),
      anchors: Map<String, DocAnchor>.from(_anchors),
    );
  }

  void _noteAnchor(String id, String blockId, String raw) {
    final key = id.trim();
    if (key.isEmpty || _anchors.containsKey(key)) return;
    final trimmed = raw.trim();
    final shown = trimmed.length > _maxAnchorChars
        ? '${trimmed.substring(0, _maxAnchorChars)}…'
        : trimmed;
    _anchors[key] = DocAnchor(
      blockId: blockId,
      text: shown,
      length: trimmed.length,
    );
  }

  void _finishBlock(html_dom.Element? node, MglBlock block) {
    if (node != null) {
      final id = _namedId(node);
      if (id.isNotEmpty) _noteAnchor(id, block.id, block.plainText);
    }
    for (final mark in _inlineMarks) {
      _noteAnchor(mark.id, block.id, mark.text);
    }
    _inlineMarks.clear();
    for (final id in _pendingIds) {
      _noteAnchor(id, block.id, block.plainText);
    }
    _pendingIds.clear();
  }

  void _attachContainer(html_dom.Element node, List<MglBlock> produced) {
    final id = _namedId(node);
    if (id.isEmpty) return;
    final leaf = _firstLeaf(produced);
    if (leaf == null) return;
    final text = produced
        .map((b) => b.plainText)
        .where((t) => t.trim().isNotEmpty)
        .join('\n');
    _noteAnchor(id, leaf.id, text);
  }

  MglBlock? _firstLeaf(List<MglBlock> blocks) {
    for (final block in blocks) {
      if (block.type == MglBlockType.list) {
        final leaf = _firstLeaf(block.children);
        if (leaf != null) return leaf;
      } else if (block.type != MglBlockType.pageBreak) {
        return block;
      }
    }
    return null;
  }

  void _captureHidden(html_dom.Element node) {
    final id = _namedId(node);
    if (id.isNotEmpty) {
      final text = node.text.replaceAll(RegExp(r'\s+'), ' ');
      _noteAnchor(id, '', text);
    }
    for (final child in node.children) {
      _captureHidden(child);
    }
  }

  String _namedId(html_dom.Element node) {
    final id = node.id.trim();
    if (id.isNotEmpty) return id;
    final name = (node.attributes['name'] ?? '').trim();
    if (name.isEmpty) return '';
    final tag = (node.localName ?? '').toLowerCase();
    if (tag == 'a' || tag == 'span') return name;
    return '';
  }

  String _attr(html_dom.Element node, String local) {
    for (final entry in node.attributes.entries) {
      final key = entry.key.toLowerCase();
      if (key == local || key.endsWith(':$local')) return entry.value;
    }
    return '';
  }

  bool _isNoteRef(html_dom.Element node) {
    final type = _attr(node, 'type').toLowerCase();
    if (type.contains('noteref') ||
        type.contains('footnote') ||
        type.contains('endnote') ||
        type.contains('rearnote')) {
      return true;
    }
    final role = _attr(node, 'role').toLowerCase();
    if (role.contains('noteref')) return true;
    final cls = node.className.toLowerCase();
    return cls.contains('noteref') ||
        cls.contains('footnote') ||
        cls.contains('endnote');
  }

  String? _normalizeHref(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final lower = trimmed.toLowerCase();
    if (lower.startsWith('http://') ||
        lower.startsWith('https://') ||
        lower.startsWith('mailto:') ||
        lower.startsWith('tel:') ||
        lower.startsWith('javascript:') ||
        lower.startsWith('data:')) {
      return trimmed;
    }
    final hash = trimmed.indexOf('#');
    final frag = hash >= 0 ? trimmed.substring(hash + 1) : '';
    final resolved = resolveHref?.call(trimmed);
    final path = (resolved == null || resolved.isEmpty)
        ? (hash >= 0 ? trimmed.substring(0, hash) : trimmed)
        : resolved;
    if (frag.isEmpty) return path.isEmpty ? null : path;
    return path.isEmpty ? '#$frag' : '$path#$frag';
  }

  List<MglBlock> _blocks(html_dom.Element parent) {
    final out = <MglBlock>[];
    final inlineBuf = <MglTextSpan>[];

    void flushInline() {
      final spans = _compact(inlineBuf);
      inlineBuf.clear();
      if (spans.isEmpty) return;
      if (spans.every((s) => s.text.trim().isEmpty)) return;
      final block = MglBlock.paragraph(id: _nextId(), spans: spans);
      _finishBlock(null, block);
      out.add(block);
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
      if (css['display'] == 'none') {
        _captureHidden(node);
        continue;
      }

      if (_isHeading(tag)) {
        flushInline();
        final heading = MglBlock.heading(
          id: _blockId(node),
          level: int.parse(tag.substring(1)),
          spans: _inlines(node, MglTextStyle.empty),
          style: blockStyleFromCss(css),
        );
        _finishBlock(node, heading);
        out.add(heading);
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
          final pre = MglBlock.code(
            id: _blockId(node),
            spans: [MglTextSpan(text: node.text)],
          );
          _finishBlock(node, pre);
          out.add(pre);
        case 'code':
          if (node.parent?.localName != 'pre') {
            flushInline();
            final code = MglBlock.code(
              id: _blockId(node),
              spans: [MglTextSpan(text: node.text)],
            );
            _finishBlock(node, code);
            out.add(code);
          }
        case 'ul':
        case 'ol':
          flushInline();
          out.add(_list(node, ordered: tag == 'ol'));
        case 'li':
          flushInline();
          final itemId = _blockId(node);
          final itemSpans = _inlines(node, MglTextStyle.empty);
          _finishBlock(
            node,
            MglBlock.listItem(id: itemId, spans: itemSpans),
          );
          out.add(
            MglBlock.listItem(
              id: itemId,
              spans: itemSpans,
              children: _nestedBlocks(node),
            ),
          );
        case 'img':
        case 'image':
          flushInline();
          final image = _image(node);
          if (image != null) {
            _finishBlock(node, image);
            out.add(image);
          }
        case 'hr':
          flushInline();
          final rule = MglBlock.horizontalRule(id: _blockId(node));
          _finishBlock(node, rule);
          out.add(rule);
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
          final produced = _blocks(node);
          _attachContainer(node, produced);
          out.addAll(produced);
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
            final produced = _blocks(node);
            _attachContainer(node, produced);
            out.addAll(produced);
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
      final block = type == MglBlockType.quote
          ? MglBlock.quote(
              id: _blockId(node),
              spans: spans,
              style: blockStyleFromCss(css),
            )
          : MglBlock.paragraph(
              id: _blockId(node),
              spans: spans,
              style: blockStyleFromCss(css),
            );
      _finishBlock(node, block);
      blocks.add(block);
    }
    for (final img in images) {
      final image = _image(img);
      if (image != null) {
        _finishBlock(img, image);
        blocks.add(image);
      }
    }
    if (blocks.isEmpty && images.isEmpty) {
      final empty = MglBlock.paragraph(
        id: _blockId(node),
        spans: spans.isEmpty ? [const MglTextSpan(text: '')] : spans,
        style: blockStyleFromCss(css),
      );
      _finishBlock(node, empty);
      blocks.add(empty);
    }
    return blocks;
  }

  MglBlock _list(html_dom.Element node, {required bool ordered}) {
    final items = <MglBlock>[];
    for (final child in node.children) {
      if (child.localName != 'li') continue;
      final itemId = _blockId(child);
      final spans = _inlines(child, MglTextStyle.empty);
      _finishBlock(child, MglBlock.listItem(id: itemId, spans: spans));
      items.add(
        MglBlock.listItem(
          id: itemId,
          spans: spans,
          children: _nestedBlocks(child),
        ),
      );
    }
    final list = MglBlock.list(id: _blockId(node), children: items, ordered: ordered);
    _attachContainer(node, items);
    return list;
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
      final rowBlock = MglBlock.paragraph(
        id: _blockId(row),
        spans: [MglTextSpan(text: text)],
      );
      _finishBlock(row, rowBlock);
      blocks.add(rowBlock);
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
      if (css['display'] == 'none') {
        _captureHidden(child);
        continue;
      }
      var style = inherited.merge(_tagStyle(tag, css));
      style = textStyleFromCss(css, style);
      final rawHref = tag == 'a' ? child.attributes['href'] : null;
      final href = _normalizeHref(rawHref);
      final note = tag == 'a' && href != null && _isNoteRef(child);
      final inner = _inlines(child, style);
      final named = _namedId(child);
      final innerText = inner.map((s) => s.text).join();
      if (named.isNotEmpty) {
        if (innerText.trim().isEmpty) {
          _pendingIds.add(named);
        } else {
          _inlineMarks.add(_InlineMark(named, innerText.trim()));
        }
      }
      if (inner.isEmpty) continue;
      if (href != null && href.isNotEmpty) {
        for (final span in inner) {
          out.add(
            MglTextSpan(
              text: span.text,
              style: span.style,
              href: href,
              note: note || span.note,
            ),
          );
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
            last.note == s.note &&
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
            note: last.note,
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

class _InlineMark {
  _InlineMark(this.id, this.text);

  final String id;
  final String text;
}
