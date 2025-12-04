import 'dart:async';

import 'day01.dart' as day01;
import 'day02.dart' as day02;
import 'day03.dart' as day03;
import 'day04.dart' as day04;

typedef DayRunner = FutureOr<void> Function(void Function());

class DayModule {
  const DayModule({required this.title, required this.run});

  final String title;
  final DayRunner run;
}

final Map<int, DayModule> dayModules = Map.unmodifiable({
  1: DayModule(title: 'Day 01', run: day01.run),
  2: DayModule(title: 'Day 02', run: day02.run),
  3: DayModule(title: 'Day 03', run: day03.run),
  4: DayModule(title: 'Day 04', run: day04.run),
});
