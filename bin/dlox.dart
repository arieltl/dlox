import 'dart:io';

import 'package:dlox/dlox.dart' as dlox;

void main(List<String> arguments) {
  if (arguments.length > 1) {
    print('Usage: dlox [script]');
    exit(64);
  } else if (arguments.length == 1) {
    dlox.runFile(arguments[0]);
  } else {
    dlox.runPrompt();
  }
}
