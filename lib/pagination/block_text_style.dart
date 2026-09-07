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
  return TextStyle(
    fontSize: size,
    height: config.lineHeight,
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
