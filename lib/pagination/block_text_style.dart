import 'package:flutter/painting.dart';

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
