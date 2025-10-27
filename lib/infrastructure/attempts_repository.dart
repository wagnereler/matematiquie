// lib/infrastructure/attempts_repository.dart
import '../domain/attempts_repository.dart';
import 'db/app_database.dart';
import 'package:drift/drift.dart' show Value;

class AttemptsRepositoryDrift implements AttemptsRepository {
  final AppDatabase db;
  AttemptsRepositoryDrift(this.db);

  @override
  Future<void> logAttempt({
    required int playerId,
    required String mode,
    required int factorA,
    required int factorB,
    required int tableBase,
    required int correctAnswer,
    required int? selectedAnswer,
    required bool isCorrect,
    required DateTime timestamp,
  }) async {
    await db.insertAttempt(
      AttemptsTableCompanion.insert(
        playerId: playerId,
        mode: mode,
        factorA: factorA,
        factorB: factorB,
        tableBase: tableBase,
        correctAnswer: correctAnswer,
        selectedAnswer: selectedAnswer == null
            ? const Value.absent()
            : Value(selectedAnswer),
        isCorrect: isCorrect,
        timestamp: timestamp,
      ),
    );
  }
}
