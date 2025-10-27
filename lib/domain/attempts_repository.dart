// lib/domain/attempts_repository.dart
abstract class AttemptsRepository {
  Future<void> logAttempt({
    required int playerId,
    required String mode, // 'mul', 'add', 'sub', 'div'
    required int factorA,
    required int factorB,
    required int tableBase,
    required int correctAnswer,
    required int? selectedAnswer,
    required bool isCorrect,
    required DateTime timestamp,
  });
}
