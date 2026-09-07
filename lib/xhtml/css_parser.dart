import '../model/document.dart';

/// MVP CSS. Unknown properties are ignored — never fail the book.
class CssRule {
  const CssRule(this.selectors, this.declarations);

  final List<String> selectors;
  final Map<String, String> declarations;
}

class CssStylesheet {
  const CssStylesheet(this.rules);

  final List<CssRule> rules;

  static const empty = CssStylesheet([]);

  Map<String, String> match({
    required String tag,
    String? id,
    Set<String> classes = const {},
  }) {
    final out = <String, String>{};
    for (final rule in rules) {
      for (final sel in rule.selectors) {
        if (_matches(sel, tag: tag, id: id, classes: classes)) {
          out.addAll(rule.declarations);
        }
      }
    }
    return out;
  }

  static bool _matches(
    String selector, {
    required String tag,
    String? id,
    required Set<String> classes,
  }) {
    final sel = selector.trim();
    if (sel.isEmpty || sel == '*') return true;
    if (sel.startsWith('.')) {
      return classes.contains(sel.substring(1));
    }
    if (sel.startsWith('#')) {
      return id != null && id == sel.substring(1);
    }
    if (sel.contains('.')) {
      final parts = sel.split('.');
      if (parts.first.isNotEmpty && parts.first.toLowerCase() != tag) {
        return false;
      }
      for (final c in parts.skip(1)) {
        if (!classes.contains(c)) return false;
      }
      return true;
    }
    if (sel.contains('#')) {
      final parts = sel.split('#');
      if (parts.first.isNotEmpty && parts.first.toLowerCase() != tag) {
        return false;
      }
      return id != null && id == parts.last;
    }
    return sel.toLowerCase() == tag;
  }
}

class CssParser {
  CssStylesheet parse(String css) {
    final stripped = _stripComments(css);
    final rules = <CssRule>[];
    final re = RegExp(r'([^{]+)\{([^}]*)\}', dotAll: true);
    for (final m in re.allMatches(stripped)) {
      final selectors = m
          .group(1)!
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty && !s.startsWith('@'))
          .toList();
      if (selectors.isEmpty) continue;
      rules.add(CssRule(selectors, parseDeclarations(m.group(2)!)));
    }
    return CssStylesheet(rules);
  }

  Map<String, String> parseDeclarations(String body) {
    final out = <String, String>{};
    for (final part in body.split(';')) {
      final idx = part.indexOf(':');
      if (idx <= 0) continue;
      final name = part.substring(0, idx).trim().toLowerCase();
      final value = part.substring(idx + 1).trim();
      if (name.isEmpty || value.isEmpty) continue;
      if (_supported.contains(name)) {
        out[name] = _trimValue(value);
      }
    }
    return out;
  }

  static const _supported = {
    'font-family',
    'font-size',
    'font-weight',
    'font-style',
    'text-decoration',
    'color',
    'background-color',
    'text-align',
    'text-indent',
    'line-height',
    'margin',
    'margin-top',
    'margin-bottom',
    'margin-left',
    'margin-right',
    'padding',
    'padding-top',
    'padding-bottom',
    'padding-left',
    'padding-right',
    'display',
  };

  String _stripComments(String css) =>
      css.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');

  String _trimValue(String value) {
    var v = value.trim();
    if (v.endsWith('!important')) {
      v = v.substring(0, v.length - '!important'.length).trim();
    }
    if ((v.startsWith('"') && v.endsWith('"')) ||
        (v.startsWith("'") && v.endsWith("'"))) {
      v = v.substring(1, v.length - 1);
    }
    return v;
  }
}

MglTextStyle textStyleFromCss(Map<String, String> css, [MglTextStyle base = MglTextStyle.empty]) {
  var style = base;
  final family = css['font-family'];
  final size = _parseFontSize(css['font-size']);
  final weight = css['font-weight'];
  final fontStyle = css['font-style'];
  final deco = css['text-decoration'];
  return MglTextStyle(
    fontFamily: family != null ? family.split(',').first.trim() : style.fontFamily,
    fontSize: size ?? style.fontSize,
    bold: style.bold || weight == 'bold' || (int.tryParse(weight ?? '') ?? 0) >= 600,
    italic: style.italic || fontStyle == 'italic' || fontStyle == 'oblique',
    underline: style.underline || (deco?.contains('underline') ?? false),
    color: css['color'] ?? style.color,
    backgroundColor: css['background-color'] ?? style.backgroundColor,
  );
}

MglBlockStyle? blockStyleFromCss(Map<String, String> css) {
  if (css.isEmpty) return null;
  double? box(String key) => _parseLength(css[key]);
  return MglBlockStyle(
    textAlign: css['text-align'],
    textIndent: _parseLength(css['text-indent']),
    lineHeight: _parseLineHeight(css['line-height']),
    marginTop: box('margin-top') ?? _parseLength(css['margin']),
    marginBottom: box('margin-bottom') ?? _parseLength(css['margin']),
    marginStart: box('margin-left') ?? _parseLength(css['margin']),
    marginEnd: box('margin-right') ?? _parseLength(css['margin']),
    paddingTop: box('padding-top') ?? _parseLength(css['padding']),
    paddingBottom: box('padding-bottom') ?? _parseLength(css['padding']),
    display: css['display'],
  );
}

double? _parseFontSize(String? raw) {
  if (raw == null) return null;
  final n = double.tryParse(raw.replaceAll(RegExp(r'[a-z%]+'), ''));
  if (n == null) return null;
  if (raw.endsWith('%')) return null;
  if (raw.endsWith('em') || raw.endsWith('rem')) return 16 * n;
  return n;
}

double? _parseLength(String? raw) {
  if (raw == null) return null;
  final first = raw.split(RegExp(r'\s+')).first;
  return double.tryParse(first.replaceAll(RegExp(r'[a-z%]+'), ''));
}

double? _parseLineHeight(String? raw) {
  if (raw == null) return null;
  return double.tryParse(raw.replaceAll(RegExp(r'[a-z%]+'), ''));
}
