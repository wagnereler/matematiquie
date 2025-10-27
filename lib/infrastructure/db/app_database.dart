// lib/infrastructure/db/app_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Tabela de perfis de jogador
class PlayersTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get languageCode => text()(); // 'pt', 'en', 'es'

  TextColumn get mode => text()(); // 'add', 'sub', 'mul', 'div'

  IntColumn get difficultyMax =>
      integer()(); // nível 1..10 (controla velocidade)

  /// Quantas dicas pedagógicas o jogador ainda tem (0..5)
  IntColumn get hintsAvailable =>
      integer().withDefault(const Constant(5))();

  /// Quantas rodadas completas (10 questões) já jogou
  IntColumn get roundsPlayed =>
      integer().withDefault(const Constant(0))();
}

/// Tabela de tentativas/respostas do jogo.
/// Cada linha = 1 pergunta respondida (ou não respondida a tempo).
class AttemptsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get playerId =>
      integer()(); // jogador ativo no momento da pergunta

  TextColumn get mode => text()(); // 'mul', etc.

  // fatores da pergunta
  IntColumn get factorA => integer()(); // ex: 7 em "7 × 4 = ?"
  IntColumn get factorB => integer()(); // ex: 4 em "7 × 4 = ?"

  // pra consulta rápida da tabuada base (normalmente factorB, mas deixamos explícito)
  IntColumn get tableBase => integer()();

  IntColumn get correctAnswer => integer()(); // resposta certa

  IntColumn get selectedAnswer => integer()
      .nullable()(); // o que o jogador escolheu (null = estourou tempo)

  BoolColumn get isCorrect =>
      boolean()(); // true/false

  DateTimeColumn get timestamp =>
      dateTime()(); // quando aconteceu
}

@DriftDatabase(tables: [PlayersTable, AttemptsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// IMPORTANTE: sempre que mudar tabela/coluna, aumente esse número.
  @override
  int get schemaVersion => 3;

  /// Migração entre versões
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          // v1 -> v2: criamos AttemptsTable
          if (from < 2) {
            await migrator.createTable(attemptsTable);
          }

          // v2 -> v3: adicionamos dicas e contador de partidas no jogador
          if (from < 3) {
            await migrator.addColumn(
                playersTable, playersTable.hintsAvailable);
            await migrator.addColumn(
                playersTable, playersTable.roundsPlayed);
          }
        },
      );

  // -----------------------
  // PLAYERS (CRUD)
  // -----------------------

  Future<List<PlayersTableData>> getAllPlayers() =>
      select(playersTable).get();

  Future<int> insertPlayer(PlayersTableCompanion entry) =>
      into(playersTable).insert(entry);

  Future<void> updatePlayerRow(PlayersTableData row) =>
      update(playersTable).replace(row);

  Future<void> deletePlayerById(int id) =>
      (delete(playersTable)..where((tbl) => tbl.id.equals(id))).go();

  // -----------------------
  // ATTEMPTS (CRUD)
  // -----------------------

  Future<int> insertAttempt(AttemptsTableCompanion entry) =>
      into(attemptsTable).insert(entry);

  Future<List<AttemptsTableData>> getAttemptsForPlayer(int playerId) {
    return (select(attemptsTable)
          ..where((tbl) => tbl.playerId.equals(playerId)))
        .get();
  }
}

/// Abre/Cria o arquivo SQLite localmente.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'matematiquei.db'));
    return NativeDatabase.createInBackground(file);
  });
}
