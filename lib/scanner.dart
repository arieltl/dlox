import 'package:dlox/%20token.dart';
import 'package:dlox/dlox.dart';
import 'package:dlox/string_tools.dart';
import 'package:dlox/tokens.dart';

class Scanner {
  final String source;
  final List<Token> tokens = [];

  int _start = 0;
  int _current = 0;
  int _line = 1;

  static const Map<String, Tokens> keywords = {
    "and": Tokens.AND,
    "class": Tokens.CLASS,
    "else": Tokens.ELSE,
    "false": Tokens.FALSE,
    "for": Tokens.FOR,
    "fun": Tokens.FUN,
    "if": Tokens.IF,
    "nil": Tokens.NIL,
    "or": Tokens.OR,
    "print": Tokens.PRINT,
    "return": Tokens.RETURN,
    "super": Tokens.SUPER,
    "this": Tokens.THIS,
    "true": Tokens.TRUE,
    "var": Tokens.VAR,
    "while": Tokens.WHILE,
  };


  List<Token> scanTokens() {
    while (!_isAtEnd()) {
      // We are at the beginning of the next lexeme.
      _start = _current;
      _scanToken();
    }
    tokens.add(Token(Tokens.EOF, "", null, _line));
    return tokens;
  }

  void _scanToken(){
    String c = _advance();
    switch (c) {
      case '(':
        _addToken(Tokens.LEFT_PAREN);
      case ')':
        _addToken(Tokens.RIGHT_PAREN);
      case '{':
        _addToken(Tokens.LEFT_BRACE);
      case '}':
        _addToken(Tokens.RIGHT_BRACE);
      case ',':
        _addToken(Tokens.COMMA);
      case '.':
        _addToken(Tokens.DOT);
      case '-':
        _addToken(Tokens.MINUS);
      case '+':
        _addToken(Tokens.PLUS);
      case ';':
        _addToken(Tokens.SEMICOLON);
      case '*':
        _addToken(Tokens.STAR);
      case '!':
        _addToken(_match('=') ? Tokens.BANG_EQUAL : Tokens.BANG);
      case '=':
        _addToken(_match('=') ? Tokens.EQUAL_EQUAL : Tokens.EQUAL);
      case '<':
        _addToken(_match('=') ? Tokens.LESS_EQUAL : Tokens.LESS);
      case '>':
        _addToken(_match('=') ? Tokens.GREATER_EQUAL : Tokens.GREATER);
      case '/':
        if (_match('/')) {
          // A comment goes until the end of the line.
          while (_peek() != '\n' && !_isAtEnd()) {
            _advance();
          }
        } else {
          _addToken(Tokens.SLASH);
        }
      case ' ':
      case '\r':
      case '\t':
        // Ignore whitespace.
        break;
      case '\n':
        _line++;
        break;

      case '"':
        _string();
        break;

      default:
        if (c.isDigit()) {
          _number();
        } else if (c.isAlpha()) {
          _identifier();
        } else {
          error(_line, "Unexpected character: $c");
        }
    }
  }

  String _peek() {
    if (_isAtEnd()) return '\0';
    return source[_current];
  }

  String _peekNext() {
    if (_current + 1 >= source.length) return '\0';
    return source[_current + 1];
  }



  String _advance() {
    _current++;
    return source[_current - 1];
  }

  void _addToken(Tokens type) {
    _addTokenLiteral(type, null);
  }

  void _addTokenLiteral(Tokens type, Object? literal) {
    String text = source.substring(_start, _current);
    tokens.add(Token(type, text, literal, _line));
  }


  bool _match(String expected) {
    if (_isAtEnd()) return false;
    if (source[_current] != expected) return false;

    _current++;
    return true;
  }

  void _number() {
    while (_peek().isDigit()) {
      _advance();
    }

    // Look for a fractional part.
    if (_peek() == '.' && _peekNext().isDigit()) {
      // Consume the "."
      _advance();

      while (_peek().isDigit()) {
        _advance();
      }
    }

    _addTokenLiteral(Tokens.NUMBER, double.parse(source.substring(_start, _current)));
  }

  void _string() {
    while (_peek() != '"' && !_isAtEnd()) {
      if (_peek() == '\n') _line++;
      _advance();
    }

    // Unterminated string.
    if (_isAtEnd()) {
      error(_line, "Unterminated string.");
      return;
    }

    // The closing ".
    _advance();

    // Trim the surrounding quotes.
    String value = source.substring(_start + 1, _current - 1);
    _addTokenLiteral(Tokens.STRING, value);
  }


  void _identifier() {
    while (_peek().isAlphaNumeric()) {
      _advance();
    }

    // See if the identifier is a reserved word.
    String text = source.substring(_start, _current);
    Tokens type = keywords[text] ?? Tokens.IDENTIFIER;
    _addToken(type);
  }
  bool _isAtEnd() {
    return _current >= source.length;
  }

  Scanner(this.source);
}