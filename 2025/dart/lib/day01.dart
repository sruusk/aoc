import 'package:aoc2025/io_utils.dart';

Future<void> run(void Function() startTimer) async {
  final lines = await readLines('input/day01.txt');
  startTimer();

  var dial = 50;
  var nullCount = 0;
  var part2Count = 0;

  for (var line in lines) {
    // Get the first char and parse the rest to a number
    var direction = line[0];
    var amount = int.parse(line.substring(1));

    switch (direction) {
      case 'R':
        dial += amount;
        if (dial > 99) {
          part2Count += dial ~/ 100;
          dial %= 100;
        } else if (dial == 0) {
          part2Count++;
        }
        if (dial == 0) nullCount++;
        break;
      case 'L':
        bool wasZero = dial == 0;
        dial -= amount;
        if (dial < 0) {
          part2Count += dial.abs() ~/ 100 + (wasZero ? 0 : 1);
          dial %= 100;
        } else if (dial == 0) {
          part2Count++;
        }
        if (dial == 0) nullCount++;
        break;
    }
  }

  print('Part 1 - Zeroes passed: $nullCount');
  print('Part 2 - Zeroes passed: $part2Count');
}
