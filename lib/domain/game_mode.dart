// lib/domain/game_mode.dart
class GameModeX {
  final String code; // 'add', 'sub', 'mul', 'div'
  const GameModeX(this.code);

  static GameModeX fromCode(String code) {
    return GameModeX(code);
  }

  String get symbol {
    switch (code) {
      case 'add':
        return '+';
      case 'sub':
        return '−';
      case 'mul':
        return '×';
      case 'div':
        return '÷';
      default:
        return '?';
    }
  }

  String get labelPt {
    switch (code) {
      case 'add':
        return 'Adição';
      case 'sub':
        return 'Subtração';
      case 'mul':
        return 'Multiplicação';
      case 'div':
        return 'Divisão';
      default:
        return 'Desconhecido';
    }
  }

  String get labelEn {
    switch (code) {
      case 'add':
        return 'Addition';
      case 'sub':
        return 'Subtraction';
      case 'mul':
        return 'Multiplication';
      case 'div':
        return 'Division';
      default:
        return 'Unknown';
    }
  }

  String get labelEs {
    switch (code) {
      case 'add':
        return 'Suma';
      case 'sub':
        return 'Resta';
      case 'mul':
        return 'Multiplicación';
      case 'div':
        return 'División';
      default:
        return 'Desconocido';
    }
  }
}
