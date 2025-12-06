import 'package:aoc2025/io_utils.dart';

Future<void> run(void Function() startTimer) async {
  final map = await readCharacterLines('input/day04.txt');

  startTimer();

  var accessiblePapers = 0;

  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[y].length; x++) {
      var char = map[y][x];
      if (char != '@') continue;

      var count = _countAdjacentPapers(map, x, y);
      if (count < 4) accessiblePapers++;
    }
  }

  var part2AccessiblePapers = 0;
  var foundOne = true;
  while (foundOne) {
    foundOne = false;
    for (var y = 0; y < map.length; y++) {
      for (var x = 0; x < map[y].length; x++) {
        var char = map[y][x];
        if (char != '@') continue;

        var count = _countAdjacentPapers(map, x, y);
        if (count < 4) {
          map[y][x] = 'x';
          part2AccessiblePapers++;
          foundOne = true;
        }
      }
    }
  }

  print('Accessible papers: $accessiblePapers');

  print('Part 2 Accessible papers: $part2AccessiblePapers');
}

int _countAdjacentPapers(List<List<String>> map, int x, int y) {
  final maxY = map.length;
  final maxX = map[0].length;
  var count = 0;

  for (var dy = -1; dy <= 1; dy++) {
    for (var dx = -1; dx <= 1; dx++) {
      if (dx == 0 && dy == 0) continue;

      var newX = x + dx;
      var newY = y + dy;
      if (newX < 0 || newX >= maxX || newY < 0 || newY >= maxY) {
        continue;
      }
      if (map[newY][newX] == '@') {
        count++;
      }
    }
  }

  return count;
}
