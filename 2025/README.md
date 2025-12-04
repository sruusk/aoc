# Advent of Code 2025 Runner

This package provides a simple runner for Advent of Code 2025 puzzles.

## Usage

```bash
 dart run bin/aoc2025.dart
```

- Pass a day number as the first argument to skip the prompt: `dart run bin/aoc2025.dart 3`.
- When no argument is provided, the runner prompts for a day between the implemented templates.

## Adding New Days

1. Create a new file under `lib/` (e.g., `lib/day05.dart`).
2. Export a `runDayXX()` function and a `dayXXTitle` describing the puzzle.
3. Register the new day in `lib/aoc2025.dart` inside `dayModules`.
4. Implement the puzzle logic inside the `runDayXX()` function.

Each template currently prints a placeholder message so you can focus on implementing puzzle logic per day.
