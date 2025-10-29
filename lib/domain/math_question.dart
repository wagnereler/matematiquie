// lib/domain/math_question.dart

import 'package:equatable/equatable.dart';

class MathQuestion extends Equatable {
  final int a;                 // fator 1
  final int b;                 // fator 2 (a "tabela" escolhida)
  final int correctAnswer;     // resultado correto
  final List<int> options;     // 4 opções (1 correta + 3 distratores)
  final String questionText;   // ex.: "7 × 4 = ?"

  const MathQuestion({
    required this.a,
    required this.b,
    required this.correctAnswer,
    required this.options,
    required this.questionText,
  });

  @override
  List<Object?> get props => [a, b, correctAnswer, options, questionText];
}

