class MglTextStyle {
  const MglTextStyle({
    this.fontFamily,
    this.fontSize,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.color,
    this.backgroundColor,
  });

  final String? fontFamily;
  final double? fontSize;
  final bool bold;
  final bool italic;
  final bool underline;
  final String? color;
  final String? backgroundColor;

  MglTextStyle merge(MglTextStyle other) {
    return MglTextStyle(
      fontFamily: other.fontFamily ?? fontFamily,
      fontSize: other.fontSize ?? fontSize,
      bold: bold || other.bold,
      italic: italic || other.italic,
      underline: underline || other.underline,
      color: other.color ?? color,
      backgroundColor: other.backgroundColor ?? backgroundColor,
    );
  }

  static const empty = MglTextStyle();
}

class MglTextSpan {
  const MglTextSpan({
    required this.text,
    this.style = MglTextStyle.empty,
    this.href,
  });

  final String text;
  final MglTextStyle style;
  final String? href;
}

class MglBlockStyle {
  const MglBlockStyle({
    this.textAlign,
    this.textIndent,
    this.lineHeight,
    this.marginTop,
    this.marginBottom,
    this.marginStart,
    this.marginEnd,
    this.paddingTop,
    this.paddingBottom,
    this.display,
  });

  final String? textAlign;
  final double? textIndent;
  final double? lineHeight;
  final double? marginTop;
  final double? marginBottom;
  final double? marginStart;
  final double? marginEnd;
  final double? paddingTop;
  final double? paddingBottom;
  final String? display;
}

enum MglBlockType {
  heading,
  paragraph,
  quote,
  image,
  list,
  listItem,
  table,
  code,
  pageBreak,
  horizontalRule,
}

/// Unified block. Typed factories match the spec names (MglHeading, …).
class MglBlock {
  const MglBlock({
    required this.id,
    required this.type,
    this.headingLevel,
    this.spans = const [],
    this.resourceId,
    this.width,
    this.height,
    this.alt,
    this.href,
    this.ordered = false,
    this.children = const [],
    this.style,
  });

  factory MglBlock.heading({
    required String id,
    required int level,
    required List<MglTextSpan> spans,
    MglBlockStyle? style,
  }) {
    return MglBlock(
      id: id,
      type: MglBlockType.heading,
      headingLevel: level,
      spans: spans,
      style: style,
    );
  }

  factory MglBlock.paragraph({
    required String id,
    required List<MglTextSpan> spans,
    MglBlockStyle? style,
  }) {
    return MglBlock(
      id: id,
      type: MglBlockType.paragraph,
      spans: spans,
      style: style,
    );
  }

  factory MglBlock.quote({
    required String id,
    required List<MglTextSpan> spans,
    MglBlockStyle? style,
  }) {
    return MglBlock(
      id: id,
      type: MglBlockType.quote,
      spans: spans,
      style: style,
    );
  }

  factory MglBlock.image({
    required String id,
    required String resourceId,
    double? width,
    double? height,
    String? alt,
  }) {
    return MglBlock(
      id: id,
      type: MglBlockType.image,
      resourceId: resourceId,
      width: width,
      height: height,
      alt: alt,
    );
  }

  factory MglBlock.list({
    required String id,
    required List<MglBlock> children,
    bool ordered = false,
  }) {
    return MglBlock(
      id: id,
      type: MglBlockType.list,
      children: children,
      ordered: ordered,
    );
  }

  factory MglBlock.listItem({
    required String id,
    required List<MglTextSpan> spans,
    List<MglBlock> children = const [],
  }) {
    return MglBlock(
      id: id,
      type: MglBlockType.listItem,
      spans: spans,
      children: children,
    );
  }

  factory MglBlock.code({
    required String id,
    required List<MglTextSpan> spans,
  }) {
    return MglBlock(id: id, type: MglBlockType.code, spans: spans);
  }

  factory MglBlock.pageBreak({required String id}) {
    return MglBlock(id: id, type: MglBlockType.pageBreak);
  }

  factory MglBlock.horizontalRule({required String id}) {
    return MglBlock(id: id, type: MglBlockType.horizontalRule);
  }

  final String id;
  final MglBlockType type;
  final int? headingLevel;
  final List<MglTextSpan> spans;
  final String? resourceId;
  final double? width;
  final double? height;
  final String? alt;
  final String? href;
  final bool ordered;
  final List<MglBlock> children;
  final MglBlockStyle? style;

  String get plainText => spans.map((s) => s.text).join();

  int get textLength => plainText.length;
}

class MglDocument {
  const MglDocument({
    required this.id,
    required this.blocks,
  });

  final String id;
  final List<MglBlock> blocks;

  MglBlock? blockById(String id) {
    MglBlock? walk(List<MglBlock> items) {
      for (final b in items) {
        if (b.id == id) return b;
        final child = walk(b.children);
        if (child != null) return child;
      }
      return null;
    }

    return walk(blocks);
  }

  Iterable<MglBlock> get flatten sync* {
    Iterable<MglBlock> walk(List<MglBlock> items) sync* {
      for (final b in items) {
        yield b;
        yield* walk(b.children);
      }
    }

    yield* walk(blocks);
  }
}
