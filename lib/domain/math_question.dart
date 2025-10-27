// lib/domain/math_question.dart
import 'package:equatable/equatable.dart';

class MathQuestion extends Equatable {
  final int a; // ex: 3
  final int b; // ex: 6
  final int correctAnswer; // ex: 18
  final List<int> options; // ex: [18, 20, 19, 22]

  const MathQuestion({
    required this.a,
    required this.b,
    required this.correctAnswer,
    required this.options,
  });

  String get questionText => "$a × $b = ?";

  @override
  List<Object?> get props => [a, b, correctAnswer, options];
}
