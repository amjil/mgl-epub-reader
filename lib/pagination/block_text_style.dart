import 'package:flutter/painting.dart';
import 'package:mongol/mongol.dart';

import '../model/document.dart';
import '../model/position.dart';

double headingScale(int? level) {
  return switch (level) {
    1 => 1.6,
    2 => 1.4,
    3 => 1.25,
    4 => 1.1,
    5 => 1.0,
    6 => 0.95,
    _ => 1.0,
  };
}

/// CSS margins, padding, and text-indent as padding around the block.
///
/// Lengths are already in pixels. Each edge is capped so a stylesheet cannot
/// push the column off the page. Vertical text indents from the top of the
/// column; horizontal text indents from the line start.
EdgeInsets blockInsets(MglBlock block, ReaderLayoutConfig config) {
  final style = block.style;
  if (style == null) return EdgeInsets.zero;
  double px(double? value) {
    if (value == null || value.isNaN || value <= 0) return 0;
    return value > 64 ? 64 : value;
  }

  final indent = px(style.textIndent);
  final top = px(style.marginTop) + px(style.paddingTop);
  final bottom = px(style.marginBottom) + px(style.paddingBottom);
  final start = px(style.marginStart);
  final end = px(style.marginEnd);
  final vertical = config.writingMode == WritingMode.vertical;
  if (vertical) {
    return EdgeInsets.only(
      top: top + indent,
      bottom: bottom,
      left: start,
      right: end,
    );
  }
  final rtl = config.readingDirection == ReadingDirection.rightToLeft;
  return EdgeInsets.only(
    top: top,
    bottom: bottom,
    left: start + (rtl ? 0 : indent),
    right: end + (rtl ? indent : 0),
  );
}

/// CSS `text-align` for horizontal lines. Unset and `start` follow direction.
TextAlign blockTextAlign(MglBlock block) {
  return switch (block.style?.textAlign) {
    'center' => TextAlign.center,
    'right' => TextAlign.right,
    'end' => TextAlign.end,
    'justify' => TextAlign.justify,
    'left' => TextAlign.left,
    _ => TextAlign.start,
  };
}

/// CSS `text-align` along a vertical column (top is the start of the column).
MongolTextAlign blockMongolAlign(MglBlock block) {
  return switch (block.style?.textAlign) {
    'center' => MongolTextAlign.center,
    'justify' => MongolTextAlign.justify,
    'right' || 'end' || 'bottom' => MongolTextAlign.bottom,
    _ => MongolTextAlign.top,
  };
}

/// Space after a block along the reading axis.
///
/// Vertical Mongolian keeps the glyph box at 1em (see [blockTextStyle]) and
/// puts [ReaderLayoutConfig.lineHeight] into the gap between columns.
/// Horizontal text already includes line-height in the line box, so this is
/// only the extra paragraph gap.
double blockAxisGap(ReaderLayoutConfig config) {
  if (config.writingMode == WritingMode.vertical) {
    final extra = config.fontSize * (config.lineHeight - 1);
    return extra < 8 ? 8 : extra;
  }
  return 12;
}

/// Shared by the paginator and [MglPageView] so measured extent matches paint.
TextStyle blockTextStyle(
  MglBlock block,
  ReaderLayoutConfig config, {
  MglTextSpan? span,
  Color? color,
  Color? backgroundColor,
  bool extraUnderline = false,
}) {
  var size = config.fontSize * headingScale(block.headingLevel);
  if (span?.style.fontSize != null) size = span!.style.fontSize!;
  final underline = (span?.style.underline ?? false) || extraUnderline;
  final vertical = config.writingMode == WritingMode.vertical;
  // OyunQaganTig draws the vertical stem on the em-box baseline. A TextStyle
  // height above 1 (the reader line-height, default 1.8) inflates that box and
  // shifts the alphabetic baseline, so neighbouring runs no longer share one
  // column. Column spacing is [blockAxisGap], not the glyph line box.
  return TextStyle(
    inherit: false,
    fontSize: size,
    height: vertical ? 1.0 : config.lineHeight,
    leadingDistribution: vertical ? TextLeadingDistribution.even : null,
    fontFamily: span?.style.fontFamily ?? config.fontFamily ?? 'OyunQaganTig',
    fontWeight: (span?.style.bold ?? false) || block.type == MglBlockType.heading
        ? FontWeight.bold
        : FontWeight.normal,
    fontStyle: (span?.style.italic ?? false) || block.type == MglBlockType.quote
        ? FontStyle.italic
        : FontStyle.normal,
    decoration: underline ? TextDecoration.underline : TextDecoration.none,
    color: color,
    backgroundColor: backgroundColor,
  );
}
