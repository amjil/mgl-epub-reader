import 'document.dart';

/// Where an activated EPUB hyperlink should go.
class LinkResolution {
  const LinkResolution({
    required this.kind,
    required this.href,
    this.text,
    this.chapterId,
    this.blockId,
    this.spans = const [],
  });

  /// `external` opens the system browser. `note` is a short preview.
  /// `jump` moves the reader. `missing` is a preview that explains the miss.
  final String kind;
  final String href;
  final String? text;
  final String? chapterId;
  final String? blockId;
  final List<MglTextSpan> spans;
}
