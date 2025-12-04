import 'dart:isolate';

import 'package:aoc2025/io_utils.dart';

Future<void> run(void Function() startTimer) async {
  final banks = await readLines('input/day03.txt');

  startTimer();

  final results = await Future.wait(
    banks.map((bank) => Isolate.run(() => _processBank(bank))),
  );

  print('Processed ${results.length} banks.');

  print('Part 1 sum: ${results.map((r) => r.$1).reduce((a, b) => a + b)}');
  print('Part 2 sum: ${results.map((r) => r.$2).reduce((a, b) => a + b)}');
}


(int, int) _processBank(String bank) {
  final numbers = bank.split('').map(int.parse).toList();

  // Part 1
  final p1 = _recursiveBank(numbers, 0, 1);

  // Part 2
  final p2 = _recursiveBank(numbers, 0, 11);

  return (
    int.parse(p1),
    int.parse(p2)
  );
}

String _recursiveBank(final List<int> numbers, final int index, final int minTail) {
  if(index >= numbers.length || minTail < 0) {
    return '';
  }

  final sublist = numbers.sublist(index, numbers.length - minTail);
  final sortedSublist = List<int>.from(sublist)..sort();
  final largest = sortedSublist[sortedSublist.length - 1];
  final largestIndex = numbers.indexOf(largest, index);
  return '$largest${_recursiveBank(numbers, largestIndex + 1, minTail - 1)}';
}
