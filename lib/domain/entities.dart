// /lib/domain/entities.dart
import 'package:equatable/equatable.dart';

enum GameMode { add, sub, mul, div }

class Question extends Equatable {
  final GameMode mode;
  final int a;      // pode ser o fator desconhecido na divisão
  final int b;      // fator/tabela
  final int result; // resultado da operação (para exibição)
  final bool unknownIsLeft; // só usado na "divisão" do tipo ? × b = result
  final List<int> options;  // 4 alternativas (embaralhadas)
  final int correct;

  const Question({
    required this.mode,
    required this.a,
    required this.b,
    required this.result,
    required this.unknownIsLeft,
    required this.options,
    required this.correct,
  });

  @override
  List<Object?> get props => [mode, a, b, result, unknownIsLeft, options, correct];
}
