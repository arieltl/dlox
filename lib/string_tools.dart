extension StringTools on String {
  bool isDigit() {
    if (isEmpty || length > 1) return false;

    return codeUnitAt(0) >= '0'.codeUnitAt(0) && codeUnitAt(0) <= '9'.codeUnitAt(0);
  }

  bool isAlpha() {
    if (isEmpty || length > 1) return false;

    return (codeUnitAt(0) >= 'a'.codeUnitAt(0) && codeUnitAt(0) <= 'z'.codeUnitAt(0)) ||
        (codeUnitAt(0) >= 'A'.codeUnitAt(0) && codeUnitAt(0) <= 'Z'.codeUnitAt(0)) ||
        codeUnitAt(0) == '_'.codeUnitAt(0);
  }

  bool isAlphaNumeric() {
    return isAlpha() || isDigit();
  }
}
