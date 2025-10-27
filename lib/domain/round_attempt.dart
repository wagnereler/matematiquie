// lib/domain/round_attempt.dart
import 'package:equatable/equatable.dart';

class RoundAttempt extends Equatable {
  final String questionText; // "7 × 4 = ?"
  final int factorA;         // 7
  final int factorB;         // 4
  final int correctAnswer;   // 28
  final int? selectedAnswer; // null se não respondeu
  final bool isCorrect;      // true/false

  const RoundAttempt({
    required this.questionText,
    required this.factorA,
    required this.factorB,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [
        questionText,
        factorA,
        factorB,
        correctAnswer,
        selectedAnswer,
        isCorrect,
      ];
}
