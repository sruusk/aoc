import 'dart:convert';
import 'dart:io';

import 'package:aoc2025/aoc2025.dart' as aoc2025;

Future<void> main(List<String> arguments) async {
  stdout.writeln('Advent of Code 2025');

  final selectedDay = await _resolveSelectedDay(arguments);
  if (selectedDay == null) {
    stdout.writeln('No valid day selected. Exiting.');
    exit(1);
  }

  final dayModule = aoc2025.dayModules[selectedDay];
  if (dayModule == null) {
    stdout.writeln('Day $selectedDay not implemented yet.');
    exit(2);
  }

  stdout.writeln('Running Day $selectedDay: ${dayModule.title}\n');
  final stopwatch = Stopwatch();
  await Future.sync(() => dayModule.run(() => stopwatch.start()));
  stopwatch.stop();
  stdout.writeln('Finished in ${stopwatch.elapsed}');
}

Future<int?> _resolveSelectedDay(List<String> arguments) async {
  if (arguments.isNotEmpty) {
    final parsed = int.tryParse(arguments.first);
    if (parsed != null) {
      return parsed;
    }
  }

  stdout.write('Enter day number (1-${aoc2025.dayModules.length}): ');
  final input = stdin.hasTerminal
      ? stdin.readLineSync()
      : await _readLineFromStdinAsync();
  return int.tryParse((input ?? '').trim());
}

Future<String?> _readLineFromStdinAsync() async {
  return utf8.decoder.bind(stdin).transform(const LineSplitter()).first;
}
