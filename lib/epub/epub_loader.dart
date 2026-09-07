import 'epub_source.dart';
import 'epub_parser.dart';

class EpubLoader {
  EpubLoader({EpubParser? parser}) : _parser = parser ?? EpubParser();

  final EpubParser _parser;

  Future<ParsedEpub> open(EpubSource source) => _parser.parse(source);

  ParsedEpub openBytes(List<int> bytes) => _parser.parseBytes(bytes);
}
