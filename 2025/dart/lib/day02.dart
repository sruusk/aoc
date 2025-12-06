import 'dart:isolate';
import 'package:aoc2025/io_utils.dart';

Future<void> run(void Function() startTimer) async {
  final lines = await readLines('input/day02.txt');

  startTimer();

  List<(int, int)> ranges = lines[0].split(',')
      .map((part) {
        var bounds = part.split('-').map(int.parse).toList();
        return (bounds[0], bounds[1]);
      })
      .toList();

  final results = await Future.wait(
    ranges.map((range) => Isolate.run(() => _processRange(range))),
  );

  print('Processed ${results.length} ranges.');
  var totalPart1 = results.map((r) => r.$1).reduce((a, b) => a + b);
  var totalPart2 = results.map((r) => r.$2).reduce((a, b) => a + b);
  print('Total Part 1: $totalPart1');
  print('Total Part 2: $totalPart2');
}

(int, int) _processRange((int, int) range) {
  var result = 0;
  var resultPart2 = 0;
  final (start, end) = range;
  for (int i = start; i <= end; i++) {
    if(isInvalidId(i.toString())) {
      result += i;
    }
    if(isInvalidIdPart2(i.toString())) {
      resultPart2 += i;
    }
  }
  return (result, resultPart2);
}

bool isInvalidId(String numStr) {
  var len = numStr.length;
  if(len % 2 != 0) {
    return false;
  }

  return numStr.substring(0, len ~/ 2) == numStr.substring(len ~/ 2);
}

bool isInvalidIdPart2(String numStr) {
  for (var i = 1; i <= numStr.length ~/ 2; i++) {
    if(numStr.length % i != 0) continue;
    var subStr = numStr.substring(0, i);
    var matches = RegExp(subStr).allMatches(numStr).toList();
    if(numStr.length == matches.length * subStr.length) {
      return true;
    }
  }
  return false;
}
