import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mongol/mongol.dart';

import '../annotation/annotation.dart';
import '../model/document.dart';
import '../model/position.dart';
import '../pagination/block_text_style.dart';
import '../pagination/page.dart';

class ReaderThemeColors {
  const ReaderThemeColors({
    required this.background,
    required this.foreground,
    required this.secondary,
    required this.selection,
    required this.link,
    required this.divider,
  });

  final Color background;
  final Color foreground;
  final Color secondary;
  final Color selection;
  final Color link;
  final Color divider;

  static const light = ReaderThemeColors(
    background: Color(0xFFF6F3EC),
    foreground: Color(0xFF1A1714),
    secondary: Color(0xFF6F6962),
    selection: Color(0x66C4A035),
    link: Color(0xFF1A7AB3),
    divider: Color(0xFFE4DDD3),
  );

  static const sepia = ReaderThemeColors(
    background: Color(0xFFF4E4C1),
    foreground: Color(0xFF5B4636),
    secondary: Color(0xFF8A6E56),
    selection: Color(0x66C4A035),
    link: Color(0xFF8A4B1F),
    divider: Color(0xFFE0CDA8),
  );

  static const dark = ReaderThemeColors(
    background: Color(0xFF1C1B19),
    foreground: Color(0xFFE8E2D6),
    secondary: Color(0xFFA39C94),
    selection: Color(0x66C4A035),
    link: Color(0xFF8FCBE8),
    divider: Color(0xFF3A3732),
  );

  static const black = ReaderThemeColors(
    background: Color(0xFF000000),
    foreground: Color(0xFFEDE8DC),
    secondary: Color(0xFF9A948C),
    selection: Color(0x66C4A035),
    link: Color(0xFF8FCBE8),
    divider: Color(0xFF222222),
  );

  static ReaderThemeColors named(String name) {
    return switch (name) {
      'sepia' => sepia,
      'dark' => dark,
      'black' => black,
      _ => light,
    };
  }
}

/// One long-press selection. Passed as a single argument so the page-view
/// callback has the same shape as [MglPageView.onLinkTap].
class MglTextSelection {
  const MglTextSelection({
    required this.block,
    required this.start,
    required this.end,
    required this.text,
  });

  final MglBlock block;
  final int start;
  final int end;
  final String text;
}

class MglPageView extends StatelessWidget {
  const MglPageView({
    super.key,
    required this.page,
    required this.config,
    this.colors = ReaderThemeColors.light,
    this.loadImage,
    this.highlight,
    this.selection,
    this.annotations = const [],
    this.onTextSelect,
    this.onBlockLongPress,
    this.onLinkTap,
  });

  final MglPage page;
  final ReaderLayoutConfig config;
  final ReaderThemeColors colors;
  final Future<List<int>> Function(String resourceId)? loadImage;
  final ReaderSelectionRange? highlight;
  final ReaderSelection? selection;
  final List<Annotation> annotations;

  /// Span chosen by a long-press. Prefer this over [onBlockLongPress].
  final void Function(MglTextSelection selection)? onTextSelect;

  /// Same callback as [onTextSelect]. The previous constructor only had this
  /// name; keeping it means either name is a legal named argument.
  final void Function(MglTextSelection selection)? onBlockLongPress;

  final void Function(String href, bool note)? onLinkTap;

  @override
  Widget build(BuildContext context) {
    final vertical = config.writingMode == WritingMode.vertical;
    final children = [
      for (final block in page.blocks) _block(block, vertical),
    ];
    // Pagination measures at layout font size; disable system text scaling so
    // painted extents match the paginator.
    return MediaQuery.withNoTextScaling(
      child: Container(
        color: colors.background,
        padding: config.padding,
        child: vertical
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
      ),
    );
  }

  Widget _block(MglBlock block, bool vertical) {
    Widget child;
    if (block.type == MglBlockType.horizontalRule) {
      child = Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: vertical
            ? Container(width: 1, color: colors.divider)
            : Divider(color: colors.divider, height: 1),
      );
    } else if (block.type == MglBlockType.image && block.resourceId != null) {
      child = _ImageBlock(
        resourceId: block.resourceId!,
        alt: block.alt,
        width: block.width,
        height: block.height,
        vertical: vertical,
        loadImage: loadImage,
        colors: colors,
      );
    } else {
      child = _SelectableBlock(
        block: block,
        vertical: vertical,
        gap: blockAxisGap(config),
        insets: blockInsets(block, config),
        config: config,
        colors: colors,
        marks: _marks(block),
        onTextSelect: onTextSelect ?? onBlockLongPress,
        onLinkTap: onLinkTap,
      );
    }
    final label = block.plainText.trim();
    if (label.isEmpty) return child;
    return Semantics(
      label: label,
      button: block.spans.any((span) => span.href != null && span.href!.isNotEmpty),
      child: child,
    );
  }

  List<_Mark> _marks(MglBlock block) {
    final chapterId = page.start.chapterId;
    final out = <_Mark>[];
    final sel = selection;
    if (sel != null &&
        sel.chapterId == chapterId &&
        sel.blockId == block.id &&
        sel.endOffset > sel.startOffset) {
      out.add(_Mark(
        start: sel.startOffset,
        end: sel.endOffset,
        background: colors.selection,
      ));
    }
    final hit = highlight;
    if (hit != null &&
        hit.blockId == block.id &&
        (hit.chapterId == null || hit.chapterId == chapterId) &&
        hit.end > hit.start) {
      out.add(_Mark(start: hit.start, end: hit.end, background: colors.selection));
    }
    for (final annotation in annotations) {
      if (!annotationAppliesTo(annotation, chapterId: chapterId, blockId: block.id)) {
        continue;
      }
      final start = annotation.start.blockId == block.id
          ? annotation.start.offset
          : block.origin;
      final end = annotation.end.blockId == block.id
          ? annotation.end.offset
          : block.origin + block.textLength;
      if (end <= start) continue;
      if (annotation.style == AnnotationStyle.highlight) {
        out.add(_Mark(start: start, end: end, background: _annotationColor(annotation.color)));
      } else if (annotation.style == AnnotationStyle.underline ||
          annotation.style == AnnotationStyle.note) {
        out.add(_Mark(start: start, end: end, underline: true));
      }
    }
    return out;
  }

  Color _annotationColor(String name) {
    return switch (name) {
      'green' => const Color(0x664CAF50),
      'blue' => const Color(0x662196F3),
      'pink' => const Color(0x66E91E63),
      _ => colors.selection,
    };
  }
}

class _Mark {
  const _Mark({
    required this.start,
    required this.end,
    this.background,
    this.underline = false,
  });

  final int start;
  final int end;
  final Color? background;
  final bool underline;
}

class _SelectableBlock extends StatefulWidget {
  const _SelectableBlock({
    required this.block,
    required this.vertical,
    required this.gap,
    required this.insets,
    required this.config,
    required this.colors,
    required this.marks,
    required this.onTextSelect,
    required this.onLinkTap,
  });

  final MglBlock block;
  final bool vertical;
  final double gap;
  final EdgeInsets insets;
  final ReaderLayoutConfig config;
  final ReaderThemeColors colors;
  final List<_Mark> marks;
  final void Function(MglTextSelection selection)? onTextSelect;
  final void Function(String href, bool note)? onLinkTap;

  @override
  State<_SelectableBlock> createState() => _SelectableBlockState();
}

class _SelectableBlockState extends State<_SelectableBlock> {
  final Map<String, TapGestureRecognizer> _recognizers = {};
  int? _anchorStart;
  int? _anchorEnd;

  @override
  void dispose() {
    for (final recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    super.dispose();
  }

  TapGestureRecognizer? _recognizerFor(String? href, bool note) {
    final link = href;
    final tap = widget.onLinkTap;
    if (link == null || link.isEmpty || tap == null) return null;
    final recognizer = _recognizers.putIfAbsent(link, TapGestureRecognizer.new);
    recognizer.onTap = () => tap(link, note);
    return recognizer;
  }

  EdgeInsets get _pad => EdgeInsets.fromLTRB(
        widget.insets.left,
        widget.insets.top,
        widget.insets.right + (widget.vertical ? widget.gap : 0),
        widget.insets.bottom + (widget.vertical ? 0 : widget.gap),
      );

  TextSpan _span({bool recognizers = false}) {
    final block = widget.block;
    final children = <InlineSpan>[];
    var cursor = block.origin;
    for (final span in block.spans) {
      final end = cursor + span.text.length;
      children.addAll(_pieces(span, cursor, end, recognizers: recognizers));
      cursor = end;
    }
    if (children.isEmpty) {
      children.add(TextSpan(text: '', style: _style(null, 0, 0)));
    }
    return TextSpan(children: children);
  }

  List<InlineSpan> _pieces(
    MglTextSpan span,
    int start,
    int end, {
    required bool recognizers,
  }) {
    if (end <= start) return const [];
    final cuts = <int>{start, end};
    for (final mark in widget.marks) {
      if (mark.end <= start || mark.start >= end) continue;
      cuts.add(_clampInt(mark.start, start, end));
      cuts.add(_clampInt(mark.end, start, end));
    }
    final points = cuts.toList()..sort();
    final recognizer = recognizers ? _recognizerFor(span.href, span.note) : null;
    final out = <InlineSpan>[];
    for (var i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      if (b <= a) continue;
      out.add(TextSpan(
        text: span.text.substring(a - start, b - start),
        style: _style(span, a, b),
        recognizer: recognizer,
      ));
    }
    return out;
  }

  TextStyle _style(MglTextSpan? span, int start, int end) {
    Color color = widget.colors.foreground;
    if (span?.href != null) color = widget.colors.link;
    if (widget.block.type == MglBlockType.quote) color = widget.colors.secondary;
    Color? background;
    var underline = false;
    for (final mark in widget.marks) {
      if (mark.end <= start || mark.start >= end) continue;
      if (mark.background != null) background = mark.background;
      if (mark.underline) underline = true;
    }
    return blockTextStyle(
      widget.block,
      widget.config,
      span: span,
      color: color,
      backgroundColor: background,
      extraUnderline: underline,
    );
  }

  int? _offsetAt(Offset local, Size size) {
    final plain = widget.block.plainText;
    if (plain.isEmpty) return null;
    final pad = _pad;
    final width = size.width - pad.horizontal;
    final height = size.height - pad.vertical;
    if (width <= 0 || height <= 0) return null;
    final point = Offset(
      _clampDouble(local.dx - pad.left, 0, width),
      _clampDouble(local.dy - pad.top, 0, height),
    );
    if (local.dx < pad.left - 8 ||
        local.dy < pad.top - 8 ||
        local.dx > size.width - (widget.vertical ? widget.gap : pad.right) + 8 ||
        local.dy > size.height - (widget.vertical ? pad.bottom : widget.gap) + 8) {
      return null;
    }
    final text = _span();
    if (widget.vertical) {
      final painter = MongolTextPainter(
        text: text,
        textAlign: blockMongolAlign(widget.block),
      );
      try {
        painter.layout(maxHeight: height);
        return _bound(painter.getPositionForOffset(point).offset, plain.length);
      } finally {
        painter.dispose();
      }
    }
    final painter = TextPainter(
      text: text,
      textAlign: blockTextAlign(widget.block),
      textDirection: widget.config.readingDirection == ReadingDirection.rightToLeft
          ? TextDirection.rtl
          : TextDirection.ltr,
    );
    try {
      painter.layout(maxWidth: width);
      return _bound(painter.getPositionForOffset(point).offset, plain.length);
    } finally {
      painter.dispose();
    }
  }

  void _emit(int localStart, int localEnd) {
    final select = widget.onTextSelect;
    if (select == null) return;
    final plain = widget.block.plainText;
    final start = _bound(localStart < localEnd ? localStart : localEnd, plain.length);
    var end = _bound(localStart < localEnd ? localEnd : localStart, plain.length);
    if (end == start) {
      if (start >= plain.length) return;
      end = start + 1;
    }
    select(MglTextSelection(
      block: widget.block,
      start: widget.block.origin + start,
      end: widget.block.origin + end,
      text: plain.substring(start, end),
    ));
  }

  void _begin(Offset local, Size size) {
    final offset = _offsetAt(local, size);
    if (offset == null) return;
    final token = _tokenAt(widget.block.plainText, offset);
    _anchorStart = token.start;
    _anchorEnd = token.end;
    _emit(token.start, token.end);
  }

  void _extend(Offset local, Size size) {
    final anchorStart = _anchorStart;
    final anchorEnd = _anchorEnd;
    final offset = _offsetAt(local, size);
    if (anchorStart == null || anchorEnd == null || offset == null) return;
    final start = offset < anchorStart ? offset : anchorStart;
    final end = offset + 1 > anchorEnd ? offset + 1 : anchorEnd;
    _emit(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final span = _span(recognizers: true);
    final child = widget.vertical
        ? MongolText.rich(span, textAlign: blockMongolAlign(widget.block))
        : Text.rich(
            span,
            textAlign: blockTextAlign(widget.block),
          );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (details) {
        final box = context.findRenderObject();
        if (box is! RenderBox || !box.hasSize) return;
        _begin(details.localPosition, box.size);
      },
      onLongPressMoveUpdate: (details) {
        final box = context.findRenderObject();
        if (box is! RenderBox || !box.hasSize) return;
        _extend(details.localPosition, box.size);
      },
      child: Padding(padding: _pad, child: child),
    );
  }
}

int _bound(int value, int max) {
  if (value < 0) return 0;
  if (value > max) return max;
  return value;
}

int _clampInt(int value, int min, int max) {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

double _clampDouble(double value, double min, double max) {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

/// Long-press token. Spaces and Mongolian punctuation split tokens.
/// A spaceless run is capped so the whole paragraph is not selected at once.
TextRange _tokenAt(String text, int offset) {
  if (text.isEmpty) return const TextRange(start: 0, end: 0);
  final index = _bound(offset, text.length - 1);
  bool isBreak(int i) {
    if (i < 0 || i >= text.length) return true;
    final code = text.codeUnitAt(i);
    return code == 0x20 ||
        code == 0x0a ||
        code == 0x09 ||
        code == 0x3000 ||
        code == 0x2c ||
        code == 0x2e ||
        code == 0x3b ||
        (code >= 0x1800 && code <= 0x180A);
  }

  var start = index;
  var end = index + 1;
  if (!isBreak(index)) {
    while (start > 0 && !isBreak(start - 1)) {
      start--;
    }
    while (end < text.length && !isBreak(end)) {
      end++;
    }
  }
  const cap = 24;
  if (end - start > cap) {
    start = index - cap ~/ 2;
    if (start < 0) start = 0;
    end = start + cap;
    if (end > text.length) end = text.length;
  }
  return TextRange(start: start, end: end);
}

class ReaderViewport extends StatelessWidget {
  const ReaderViewport({
    super.key,
    required this.pages,
    required this.index,
    required this.builder,
  });

  final List<MglPage> pages;
  final int index;
  final Widget Function(MglPage page) builder;

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) return const SizedBox.expand();
    final last = pages.length - 1;
    final i = index < 0 ? 0 : (index > last ? last : index);
    return Stack(
      fit: StackFit.expand,
      children: [
        if (i > 0) Offstage(offstage: true, child: builder(pages[i - 1])),
        builder(pages[i]),
        if (i + 1 < pages.length)
          Offstage(offstage: true, child: builder(pages[i + 1])),
      ],
    );
  }
}

class ReaderSelectionRange {
  const ReaderSelectionRange({
    this.chapterId,
    required this.blockId,
    required this.start,
    required this.end,
  });

  final String? chapterId;
  final String blockId;
  final int start;
  final int end;
}

class _ImageBlock extends StatefulWidget {
  const _ImageBlock({
    required this.resourceId,
    required this.vertical,
    required this.colors,
    this.alt,
    this.width,
    this.height,
    this.loadImage,
  });

  final String resourceId;
  final String? alt;
  final double? width;
  final double? height;
  final bool vertical;
  final Future<List<int>> Function(String resourceId)? loadImage;
  final ReaderThemeColors colors;

  @override
  State<_ImageBlock> createState() => _ImageBlockState();
}

class _ImageBlockState extends State<_ImageBlock> {
  Future<List<int>>? _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(_ImageBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resourceId != widget.resourceId ||
        oldWidget.loadImage != widget.loadImage) {
      _load();
    }
  }

  void _load() {
    final loader = widget.loadImage;
    _future = loader == null ? null : loader(widget.resourceId);
  }

  @override
  Widget build(BuildContext context) {
    final future = _future;
    if (future == null) {
      return _fallback();
    }
    return FutureBuilder<List<int>>(
      future: future,
      builder: (context, snap) {
        if (!snap.hasData) return _fallback();
        return Image.memory(
          Uint8List.fromList(snap.data!),
          fit: BoxFit.contain,
          width: widget.vertical ? (widget.width ?? 80) : null,
          height: widget.vertical ? null : (widget.height ?? 180),
          cacheWidth: widget.vertical ? 320 : 960,
          errorBuilder: (_, __, ___) => _fallback(),
        );
      },
    );
  }

  Widget _fallback() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: widget.vertical
          ? MongolText(
              widget.alt ?? 'image',
              style: TextStyle(
                color: widget.colors.secondary,
                height: 1.0,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            )
          : Text(
              widget.alt ?? 'image',
              style: TextStyle(color: widget.colors.secondary),
            ),
    );
  }
}

/// Page widget ClojureDart should construct.
///
/// [MglPageView] already takes [MglPageView.onTextSelect]. This subclass repeats
/// that named parameter so a compiler still holding the pre-selection
/// `onBlockLongPress`-only signature does not reject `.onTextSelect`.
class MglReaderPage extends MglPageView {
  const MglReaderPage({
    super.key,
    required super.page,
    required super.config,
    super.colors,
    super.loadImage,
    super.highlight,
    super.selection,
    super.annotations,
    super.onTextSelect,
    super.onLinkTap,
  });
}

/// Decode image bytes, optionally downsampling to [targetWidth].
Future<ui.Image> decodeImage(List<int> bytes, {int? targetWidth}) {
  final codec = ui.instantiateImageCodec(
    Uint8List.fromList(bytes),
    targetWidth: targetWidth,
  );
  return codec.then((c) => c.getNextFrame().then((f) => f.image));
}
