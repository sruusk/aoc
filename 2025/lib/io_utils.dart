import 'dart:io';

Future<List<String>> readLines(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    throw FileSystemException('File does not exist', path);
  }
  return file.readAsLines();
}

Future<List<List<String>>> readCharacterLines(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    throw FileSystemException('File does not exist', path);
  }
  final contents = await file.readAsLines();
  return contents.map((line) => line.split('')).toList();
}

