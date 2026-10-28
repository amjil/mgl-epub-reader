import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mongol/mongol.dart';

import '../model/document.dart';

/// Plain or linked preview text. Each href is its own tap target.
class LinkRichText extends StatefulWidget {
  const LinkRichText({
    super.key,
    required this.fallback,
    required this.vertical,
    this.spans,
    this.onLinkTap,
    this.color = const Color(0xFF1A1714),
    this.linkColor = const Color(0xFF1A7AB3),
  });

  final String fallback;
  final bool vertical;
  final List<MglTextSpan>? spans;
  final void Function(String href, bool note)? onLinkTap;
  final Color color;
  final Color linkColor;

  @override
  State<LinkRichText> createState() => _LinkRichTextState();
}

class _LinkRichTextState extends State<LinkRichText> {
  final Map<String, TapGestureRecognizer> _recognizers = {};

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

  TextSpan _span() {
    final source = (widget.spans ?? const <MglTextSpan>[])
        .where((s) => s.text.isNotEmpty)
        .toList();
    final pieces = source.isEmpty
        ? [MglTextSpan(text: widget.fallback)]
        : source;
    return TextSpan(
      children: [
        for (final piece in pieces)
          TextSpan(
            text: piece.text,
            style: TextStyle(
              fontFamily: 'OyunQaganTig',
              fontSize: 16,
              height: widget.vertical ? 1.0 : 1.45,
              leadingDistribution:
                  widget.vertical ? TextLeadingDistribution.even : null,
              color: piece.href == null || piece.href!.isEmpty
                  ? widget.color
                  : widget.linkColor,
              decoration: piece.href == null || piece.href!.isEmpty
                  ? TextDecoration.none
                  : TextDecoration.underline,
            ),
            recognizer: _recognizerFor(piece.href, piece.note),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final span = _span();
    if (widget.vertical) {
      return MongolText.rich(span, textAlign: MongolTextAlign.top);
    }
    return Text.rich(span);
  }
}
