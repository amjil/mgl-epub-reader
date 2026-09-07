import 'dart:typed_data';
import 'dart:ui' as ui;

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
  final void Function(MglBlock block)? onBlockLongPress;
  final void Function(String href)? onLinkTap;

  @override
  Widget build(BuildContext context) {
    final vertical = config.writingMode == WritingMode.vertical;
    final children = [
      for (final block in page.blocks) _block(block, vertical),
    ];
    return Container(
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
      final span = _rich(block);
      child = vertical
          ? Padding(
              padding: const EdgeInsets.only(right: 12),
              child: MongolText.rich(span),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text.rich(span),
            );
    }
    final onPress = onBlockLongPress;
    final href = _firstHref(block);
    Widget wrapped = child;
    if (onPress != null || (href != null && onLinkTap != null)) {
      wrapped = GestureDetector(
        onLongPress: onPress == null ? null : () => onPress(block),
        onTap: href == null || onLinkTap == null ? null : () => onLinkTap!(href),
        behavior: HitTestBehavior.translucent,
        child: child,
      );
    }
    final label = block.plainText.trim();
    if (label.isEmpty) return wrapped;
    return Semantics(
      label: label,
      button: href != null,
      child: wrapped,
    );
  }

  String? _firstHref(MglBlock block) {
    for (final span in block.spans) {
      if (span.href != null && span.href!.isNotEmpty) return span.href;
    }
    return block.href;
  }

  TextSpan _rich(MglBlock block) {
    final children = <InlineSpan>[];
    for (final span in block.spans) {
      final style = _style(span, block);
      children.add(TextSpan(text: span.text, style: style));
    }
    if (children.isEmpty) {
      children.add(TextSpan(text: '', style: _style(null, block)));
    }
    return TextSpan(children: children);
  }

  Color? _blockBackground(MglBlock block) {
    final chapterId = page.start.chapterId;
    if (_selectionHits(block, chapterId) || _highlightHits(block, chapterId)) {
      return colors.selection;
    }
    for (final a in annotations) {
      if (annotationAppliesTo(a, chapterId: chapterId, blockId: block.id) &&
          a.style == AnnotationStyle.highlight) {
        return _annotationColor(a.color);
      }
    }
    return null;
  }

  bool _selectionHits(MglBlock block, String chapterId) {
    final sel = selection;
    if (sel == null || sel.blockId != block.id) return false;
    return sel.chapterId == chapterId;
  }

  bool _highlightHits(MglBlock block, String chapterId) {
    final hit = highlight;
    if (hit == null || hit.blockId != block.id) return false;
    return hit.chapterId == null || hit.chapterId == chapterId;
  }

  bool _blockUnderline(MglBlock block) {
    final chapterId = page.start.chapterId;
    for (final a in annotations) {
      if (!annotationAppliesTo(a, chapterId: chapterId, blockId: block.id)) {
        continue;
      }
      if (a.style == AnnotationStyle.underline ||
          a.style == AnnotationStyle.note) {
        return true;
      }
    }
    return false;
  }

  Color _annotationColor(String name) {
    return switch (name) {
      'green' => const Color(0x664CAF50),
      'blue' => const Color(0x662196F3),
      'pink' => const Color(0x66E91E63),
      _ => colors.selection,
    };
  }

  TextStyle _style(MglTextSpan? span, MglBlock block) {
    Color color = colors.foreground;
    if (span?.href != null) color = colors.link;
    if (block.type == MglBlockType.quote) color = colors.secondary;
    return blockTextStyle(
      block,
      config,
      span: span,
      color: color,
      backgroundColor: _blockBackground(block),
      extraUnderline: _blockUnderline(block),
    );
  }
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
    final i = index.clamp(0, pages.length - 1);
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
              style: TextStyle(color: widget.colors.secondary),
            )
          : Text(
              widget.alt ?? 'image',
              style: TextStyle(color: widget.colors.secondary),
            ),
    );
  }
}

/// Decode image bytes, optionally downsampling to [targetWidth].
Future<ui.Image> decodeImage(List<int> bytes, {int? targetWidth}) {
  final codec = ui.instantiateImageCodec(
    Uint8List.fromList(bytes),
    targetWidth: targetWidth,
  );
  return codec.then((c) => c.getNextFrame().then((f) => f.image));
}
