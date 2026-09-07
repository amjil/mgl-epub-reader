import '../model/position.dart';

enum AnnotationStyle { highlight, underline, note }

class ReaderSelection {
  const ReaderSelection({
    required this.chapterId,
    required this.blockId,
    required this.startOffset,
    required this.endOffset,
    required this.text,
  });

  final String chapterId;
  final String blockId;
  final int startOffset;
  final int endOffset;
  final String text;

  ReaderPosition get start => ReaderPosition(
        chapterId: chapterId,
        blockId: blockId,
        offset: startOffset,
      );

  ReaderPosition get end => ReaderPosition(
        chapterId: chapterId,
        blockId: blockId,
        offset: endOffset,
      );
}

class Annotation {
  const Annotation({
    required this.id,
    required this.bookId,
    required this.chapterId,
    required this.start,
    required this.end,
    required this.style,
    this.color = 'yellow',
    this.note,
    required this.createdAt,
  });

  final String id;
  final String bookId;
  final String chapterId;
  final ReaderPosition start;
  final ReaderPosition end;
  final AnnotationStyle style;
  final String color;
  final String? note;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookId': bookId,
        'chapterId': chapterId,
        'start': start.toJson(),
        'end': end.toJson(),
        'style': style.name,
        'color': color,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Annotation.fromJson(Map<String, dynamic> json) {
    return Annotation(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      chapterId: json['chapterId'] as String,
      start: ReaderPosition.fromJson(json['start'] as Map<String, dynamic>),
      end: ReaderPosition.fromJson(json['end'] as Map<String, dynamic>),
      style: AnnotationStyle.values.byName(json['style'] as String),
      color: json['color'] as String? ?? 'yellow',
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

/// Block ids restart per chapter (`block-0001`, …), so chapter must be checked.
bool annotationAppliesTo(
  Annotation annotation, {
  required String chapterId,
  required String blockId,
}) {
  if (annotation.chapterId != chapterId) return false;
  return annotation.start.blockId == blockId ||
      annotation.end.blockId == blockId;
}

class Bookmark {
  const Bookmark({
    required this.id,
    required this.bookId,
    required this.chapterId,
    required this.position,
    this.title,
    required this.createdAt,
  });

  final String id;
  final String bookId;
  final String chapterId;
  final ReaderPosition position;
  final String? title;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookId': bookId,
        'chapterId': chapterId,
        'position': position.toJson(),
        'title': title,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      chapterId: json['chapterId'] as String,
      position: ReaderPosition.fromJson(
        json['position'] as Map<String, dynamic>,
      ),
      title: json['title'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class ReadingProgress {
  const ReadingProgress({
    required this.bookId,
    required this.chapterId,
    required this.blockId,
    required this.offset,
    required this.progress,
    required this.updatedAt,
  });

  final String bookId;
  final String chapterId;
  final String blockId;
  final int offset;
  final double progress;
  final DateTime updatedAt;

  ReaderPosition get position => ReaderPosition(
        chapterId: chapterId,
        blockId: blockId,
        offset: offset,
      );

  Map<String, dynamic> toJson() => {
        'bookId': bookId,
        'chapterId': chapterId,
        'blockId': blockId,
        'offset': offset,
        'progress': progress,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      bookId: json['bookId'] as String,
      chapterId: json['chapterId'] as String,
      blockId: json['blockId'] as String,
      offset: json['offset'] as int,
      progress: (json['progress'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
