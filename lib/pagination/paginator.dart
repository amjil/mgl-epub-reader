import 'package:flutter/painting.dart';
import 'package:mongol/mongol.dart';

import '../model/document.dart';
import '../model/position.dart';
import 'block_text_style.dart';
import 'page.dart';

abstract class Paginator {
  List<MglPage> paginate(MglDocument document, ReaderLayoutConfig config);
}

class DefaultPaginator implements Paginator {
  const DefaultPaginator();

  @override
  List<MglPage> paginate(MglDocument document, ReaderLayoutConfig config) {
    final items = _flatten(document);
    if (items.isEmpty) {
      final pos = ReaderPosition(
        chapterId: document.id,
        blockId: 'block-0000',
        offset: 0,
      );
      return [MglPage(index: 0, start: pos, end: pos, blocks: const [])];
    }

    final vertical = config.writingMode == WritingMode.vertical;
    final pages = <MglPage>[];
    var remaining = vertical ? config.contentSize.width : config.contentSize.height;
    var current = <_Laid>[];
    var index = 0;

    void flush() {
      if (current.isEmpty) return;
      pages.add(
        MglPage(
          index: index,
          start: current.first.start,
          end: current.last.end,
          blocks: current.map((e) => e.block).toList(),
        ),
      );
      index += 1;
      current = [];
      remaining = vertical ? config.contentSize.width : config.contentSize.height;
    }

    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      if (item.block.type == MglBlockType.pageBreak) {
        flush();
        continue;
      }

      while (true) {
        final measured = _measure(item, config, remaining);
        if (measured.fits) {
          current.add(measured.laid);
          remaining -= measured.extent;
          break;
        }

        if (current.isNotEmpty && measured.extent > remaining) {
          flush();
          continue;
        }

        final split = _split(item, config, remaining);
        if (split == null) {
          if (current.isNotEmpty) {
            flush();
            continue;
          }
          current.add(
            _Laid(
              block: item.block,
              start: item.start,
              end: item.end,
            ),
          );
          remaining = 0;
          flush();
          break;
        }

        current.add(split.fitted);
        remaining = 0;
        flush();
        item = split.rest;
      }
    }
    flush();

    if (pages.isEmpty) {
      final pos = items.first.start;
      return [MglPage(index: 0, start: pos, end: pos, blocks: const [])];
    }
    return pages;
  }
}

class _Item {
  _Item({
    required this.block,
    required this.start,
    required this.end,
  });

  final MglBlock block;
  final ReaderPosition start;
  final ReaderPosition end;
}

class _Laid {
  _Laid({
    required this.block,
    required this.start,
    required this.end,
  });

  final MglBlock block;
  final ReaderPosition start;
  final ReaderPosition end;
}

class _Measured {
  _Measured({required this.laid, required this.extent, required this.fits});

  final _Laid laid;
  final double extent;
  final bool fits;
}

class _Split {
  _Split({required this.fitted, required this.rest});

  final _Laid fitted;
  final _Item rest;
}

List<_Item> _flatten(MglDocument document) {
  final out = <_Item>[];

  void walk(List<MglBlock> blocks) {
    for (final block in blocks) {
      if (block.type == MglBlockType.list) {
        walk(block.children);
        continue;
      }
      out.add(
        _Item(
          block: block,
          start: ReaderPosition(
            chapterId: document.id,
            blockId: block.id,
            offset: 0,
          ),
          end: ReaderPosition(
            chapterId: document.id,
            blockId: block.id,
            offset: block.textLength,
          ),
        ),
      );
      if (block.children.isNotEmpty && block.type != MglBlockType.listItem) {
        walk(block.children);
      }
    }
  }

  walk(document.blocks);
  return out;
}

TextSpan _spanFor(MglBlock block, ReaderLayoutConfig config) {
  final children = <InlineSpan>[];
  for (final span in block.spans) {
    children.add(
      TextSpan(
        text: span.text,
        style: blockTextStyle(block, config, span: span),
      ),
    );
  }
  if (children.isEmpty) {
    children.add(TextSpan(text: '', style: blockTextStyle(block, config)));
  }
  return TextSpan(children: children);
}

_Measured _measure(_Item item, ReaderLayoutConfig config, double remaining) {
  final extent = _extentOf(item.block, config);
  return _Measured(
    laid: _Laid(block: item.block, start: item.start, end: item.end),
    extent: extent,
    fits: extent <= remaining + 0.5,
  );
}

double _extentOf(MglBlock block, ReaderLayoutConfig config) {
  final vertical = config.writingMode == WritingMode.vertical;
  if (block.type == MglBlockType.horizontalRule) return 16;
  if (block.type == MglBlockType.image) {
    final w = block.width ?? (vertical ? 80 : config.contentSize.width);
    final h = block.height ?? (vertical ? config.contentSize.height : 180);
    if (vertical) {
      final scale = h > config.contentSize.height
          ? config.contentSize.height / h
          : 1.0;
      return (w * scale) + 16;
    }
    final scale = w > config.contentSize.width ? config.contentSize.width / w : 1.0;
    return (h * scale) + 16;
  }
  if (block.plainText.isEmpty) {
    return config.fontSize * config.lineHeight;
  }
  if (vertical) {
    final painter = MongolTextPainter(
      text: _spanFor(block, config),
      textAlign: MongolTextAlign.top,
    )..layout(maxHeight: config.contentSize.height);
    return painter.width + 12;
  }
  final painter = TextPainter(
    text: _spanFor(block, config),
    textDirection: config.readingDirection == ReadingDirection.rightToLeft
        ? TextDirection.rtl
        : TextDirection.ltr,
  )..layout(maxWidth: config.contentSize.width);
  return painter.height + 12;
}

_Split? _split(_Item item, ReaderLayoutConfig config, double remaining) {
  if (item.block.type == MglBlockType.image ||
      item.block.type == MglBlockType.horizontalRule ||
      item.block.textLength < 8) {
    return null;
  }
  final text = item.block.plainText;
  var lo = 1;
  var hi = text.length;
  var best = 0;
  while (lo <= hi) {
    final mid = (lo + hi) ~/ 2;
    final head = _sliceBlock(item.block, 0, mid);
    final extent = _extentOf(head, config);
    if (extent <= remaining) {
      best = mid;
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }
  }
  if (best <= 0) return null;
  best = _snap(text, best);
  if (best <= 0 || best >= text.length) return null;

  final fittedBlock = _sliceBlock(item.block, 0, best);
  final restBlock = _sliceBlock(item.block, best, text.length);
  final base = item.start.offset;
  return _Split(
    fitted: _Laid(
      block: fittedBlock,
      start: item.start,
      end: item.start.copyWith(offset: base + best),
    ),
    rest: _Item(
      block: restBlock,
      start: item.start.copyWith(offset: base + best),
      end: item.end,
    ),
  );
}

int _snap(String text, int offset) {
  if (offset >= text.length) return offset;
  var i = offset;
  while (i > 0 && !_break(text, i)) {
    i--;
  }
  return i == 0 ? offset : i;
}

bool _break(String text, int i) {
  if (i <= 0 || i >= text.length) return true;
  final c = text.codeUnitAt(i - 1);
  return c == 0x20 || c == 0x0a || c == 0x09 || c == 0x3000;
}

MglBlock _sliceBlock(MglBlock block, int start, int end) {
  return MglBlock(
    id: block.id,
    type: block.type,
    headingLevel: block.headingLevel,
    spans: _sliceSpans(block.spans, start, end),
    resourceId: block.resourceId,
    width: block.width,
    height: block.height,
    alt: block.alt,
    href: block.href,
    ordered: block.ordered,
    children: block.children,
    style: block.style,
  );
}

List<MglTextSpan> _sliceSpans(List<MglTextSpan> spans, int start, int end) {
  final out = <MglTextSpan>[];
  var cursor = 0;
  for (final span in spans) {
    final spanEnd = cursor + span.text.length;
    if (spanEnd <= start) {
      cursor = spanEnd;
      continue;
    }
    if (cursor >= end) break;
    final from = start > cursor ? start - cursor : 0;
    final to = end < spanEnd ? end - cursor : span.text.length;
    if (to > from) {
      out.add(
        MglTextSpan(
          text: span.text.substring(from, to),
          style: span.style,
          href: span.href,
        ),
      );
    }
    cursor = spanEnd;
  }
  return out;
}
