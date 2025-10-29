// lib/domain/attempts_repository.dart
import 'package:drift/drift.dart';
import '../infrastructure/db/app_database.dart';

/// Responsável por:
///  - registrar cada tentativa do jogador no banco local
///  - calcular em quais contas (ex: 7×5, 9×6...) o jogador mais erra
class AttemptsRepository {
  final AppDatabase db;
  AttemptsRepository(this.db);

  /// Salva 1 tentativa de resposta (acertou, errou ou estourou tempo).
  Future<void> logAttempt({
    required int playerId,
    required String mode, // 'mul', 'add', 'sub', 'div'
    required int factorA,
    required int factorB,
    required int tableBase,
    required int correctAnswer,
    required int? selectedAnswer, // null = não respondeu a tempo
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
        selectedAnswer: selectedAnswer != null
            ? Value(selectedAnswer)
            : const Value.absent(),
        isCorrect: isCorrect,
        timestamp: timestamp,
      ),
    );
  }

  /// Retorna uma lista de pares (a,b) tipo [(7,5), (9,6), ...]
  /// que representam contas a×b que o jogador MAIS errou.
  ///
  /// Observação importante:
  /// - não é "tabuada que ele mais erra", é a operação exata
  ///   (ex: 7×5 especificamente).
  Future<List<(int, int)>> getWorstPairsForPlayer(
    int playerId, {
    int limit = 8,
  }) async {
    // busca TODAS as tentativas desse jogador
    final rows = await db.getAttemptsForPlayer(playerId);

    // agrega por par (a,b)
    final Map<(int, int), _PairStats> stats = {};

    for (final row in rows) {
      if (row.mode != 'mul') continue; // aqui queremos só multiplicação

      final key = (row.factorA, row.factorB);
      stats.putIfAbsent(key, () => _PairStats());

      stats[key]!.total += 1;
      if (!row.isCorrect) {
        stats[key]!.wrong += 1;
      }
    }

    // mantemos apenas pares com pelo menos 1 erro
    final entries = stats.entries.where((e) => e.value.wrong > 0).toList();

    // agora ordena:
    //  1. maior taxa de erro
    //  2. depois maior número de erros absolutos
    //  3. depois mais tentativas totais
    entries.sort((a, b) {
      final s1 = a.value;
      final s2 = b.value;

      final rateDiff = s2.errorRate.compareTo(s1.errorRate);
      if (rateDiff != 0) return rateDiff;

      final wrongDiff = s2.wrong.compareTo(s1.wrong);
      if (wrongDiff != 0) return wrongDiff;

      return s2.total.compareTo(s1.total);
    });

    // pega só os top N pares
    final worstPairs = entries
        .take(limit)
        .map<(int, int)>((e) => e.key)
        .toList();

    return worstPairs;
  }
}

/// Estatística de erro/acerto pra um par específico (a×b)
class _PairStats {
  int total = 0;
  int wrong = 0;

  double get errorRate {
    if (total == 0) return 0;
    return wrong / total;
  }
}
