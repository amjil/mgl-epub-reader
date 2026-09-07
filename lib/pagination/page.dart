import '../model/document.dart';
import '../model/position.dart';

class MglPage {
  const MglPage({
    required this.index,
    required this.start,
    required this.end,
    required this.blocks,
  });

  final int index;
  final ReaderPosition start;
  final ReaderPosition end;
  final List<MglBlock> blocks;
}
