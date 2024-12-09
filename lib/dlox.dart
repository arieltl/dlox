import 'dart:io';

import 'package:dlox/%20token.dart';
import 'package:dlox/scanner.dart';


bool hadError = false;

void runFile(String path) {
  var file = File(path);
  var source = file.readAsStringSync();
  run(source);
  if (hadError) exit(65);
}

void run(String source) {
  Scanner scanner = Scanner(source);
  List<Token> tokens = scanner.scanTokens();
  for (Token token in tokens) {
    print(token);
  }
}

void runPrompt() {
  String?  line;
  stdout.write('> ');
  while ((line = stdin.readLineSync()) != null) {
    run(line!);
    hadError = false;
    stdout.write('> ');
  }
}

void error(int line, String message) {
  report(line, '', message);
}

void report(int line, String where, String message) {
  stderr.writeln('[line $line] Error$where: $message');
  hadError = true;
}