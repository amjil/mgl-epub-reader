import 'package:flutter/painting.dart';

enum WritingMode { horizontal, vertical }

enum ReadingDirection { leftToRight, rightToLeft }

/// Stable reader location. Never persist page numbers as the source of truth.
class ReaderPosition {
  const ReaderPosition({
    required this.chapterId,
    required this.blockId,
    required this.offset,
  });

  final String chapterId;
  final String blockId;
  final int offset;

  ReaderPosition copyWith({
    String? chapterId,
    String? blockId,
    int? offset,
  }) {
    return ReaderPosition(
      chapterId: chapterId ?? this.chapterId,
      blockId: blockId ?? this.blockId,
      offset: offset ?? this.offset,
    );
  }

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'blockId': blockId,
        'offset': offset,
      };

  factory ReaderPosition.fromJson(Map<String, dynamic> json) {
    return ReaderPosition(
      chapterId: json['chapterId'] as String,
      blockId: json['blockId'] as String,
      offset: json['offset'] as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ReaderPosition &&
      other.chapterId == chapterId &&
      other.blockId == blockId &&
      other.offset == offset;

  @override
  int get hashCode => Object.hash(chapterId, blockId, offset);

  @override
  String toString() => '$chapterId/$blockId@$offset';
}

class ReaderLayoutConfig {
  const ReaderLayoutConfig({
    required this.viewport,
    this.fontSize = 22,
    this.lineHeight = 1.8,
    this.fontFamily,
    this.padding = const EdgeInsets.all(24),
    this.writingMode = WritingMode.horizontal,
    this.readingDirection = ReadingDirection.leftToRight,
  });

  final Size viewport;
  final double fontSize;
  final double lineHeight;
  final String? fontFamily;
  final EdgeInsets padding;
  final WritingMode writingMode;
  final ReadingDirection readingDirection;

  Size get contentSize => Size(
        (viewport.width - padding.horizontal).clamp(1, double.infinity),
        (viewport.height - padding.vertical).clamp(1, double.infinity),
      );

  /// Cache key. Any of these changing must invalidate pagination.
  String cacheKey({required String bookId, required String chapterId}) {
    return [
      bookId,
      chapterId,
      viewport.width.toStringAsFixed(1),
      viewport.height.toStringAsFixed(1),
      fontFamily ?? '',
      fontSize.toStringAsFixed(2),
      lineHeight.toStringAsFixed(3),
      padding.left,
      padding.top,
      padding.right,
      padding.bottom,
      writingMode.name,
      readingDirection.name,
    ].join('|');
  }

  ReaderLayoutConfig copyWith({
    Size? viewport,
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    EdgeInsets? padding,
    WritingMode? writingMode,
    ReadingDirection? readingDirection,
  }) {
    return ReaderLayoutConfig(
      viewport: viewport ?? this.viewport,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      padding: padding ?? this.padding,
      writingMode: writingMode ?? this.writingMode,
      readingDirection: readingDirection ?? this.readingDirection,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ReaderLayoutConfig &&
      other.viewport == viewport &&
      other.fontSize == fontSize &&
      other.lineHeight == lineHeight &&
      other.fontFamily == fontFamily &&
      other.padding == padding &&
      other.writingMode == writingMode &&
      other.readingDirection == readingDirection;

  @override
  int get hashCode => Object.hash(
        viewport,
        fontSize,
        lineHeight,
        fontFamily,
        padding,
        writingMode,
        readingDirection,
      );
}
