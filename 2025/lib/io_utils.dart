import 'dart:io';

Future<List<String>> readLines(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    throw FileSystemException('File does not exist', path);
  }
  return file.readAsLines();
}

Future<List<String>> readCharacters(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    throw FileSystemException('File does not exist', path);
  }
  final contents = await file.readAsString();
  return contents.runes.map(String.fromCharCode).toList(growable: false);
}

