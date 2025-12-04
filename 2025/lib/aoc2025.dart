import 'dart:async';

import 'day01.dart' as day01;
import 'day02.dart' as day02;
import 'day03.dart' as day03;
import 'day04.dart' as day04;
import 'day05.dart' as day05;
import 'day06.dart' as day06;

typedef DayRunner = FutureOr<void> Function(void Function());

class DayModule {
  const DayModule({required this.title, required this.run});

  final String title;
  final DayRunner run;
}

final Map<int, DayModule> dayModules = Map.unmodifiable({
  1: DayModule(title: 'Secret Entrance', run: day01.run),
  2: DayModule(title: 'Gift Shop', run: day02.run),
  3: DayModule(title: 'Lobby', run: day03.run),
  4: DayModule(title: 'Printing Department', run: day04.run),
  5: DayModule(title: 'TBD', run: day05.run),
  6: DayModule(title: 'TBD', run: day06.run),
});
