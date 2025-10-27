// lib/infrastructure/players_repository.dart
import '../domain/player.dart';
import 'db/app_database.dart';
import 'package:drift/drift.dart' show Value;

class PlayersRepository {
  final AppDatabase db;
  PlayersRepository(this.db);

  Player _fromRow(PlayersTableData row) {
    return Player(
      id: row.id,
      name: row.name,
      languageCode: row.languageCode,
      mode: row.mode,
      difficultyMax: row.difficultyMax,
      hintsAvailable: row.hintsAvailable,
      roundsPlayed: row.roundsPlayed,
    );
  }

  PlayersTableData _toRow(Player p) {
    return PlayersTableData(
      id: p.id,
      name: p.name,
      languageCode: p.languageCode,
      mode: p.mode,
      difficultyMax: p.difficultyMax,
      hintsAvailable: p.hintsAvailable,
      roundsPlayed: p.roundsPlayed,
    );
  }

  Future<List<Player>> getPlayers() async {
    final rows = await db.getAllPlayers();
    return rows.map(_fromRow).toList(growable: false);
  }

  Future<Player> addPlayer({
    required String name,
    String languageCode = 'pt',
    String mode = 'mul',
    int difficultyMax = 5,
  }) async {
    final id = await db.insertPlayer(
      PlayersTableCompanion.insert(
        name: name,
        languageCode: languageCode,
        mode: mode,
        difficultyMax: difficultyMax,
        // hintsAvailable e roundsPlayed têm default no banco,
        // então não precisamos passar aqui.
      ),
    );

    return Player(
      id: id,
      name: name,
      languageCode: languageCode,
      mode: mode,
      difficultyMax: difficultyMax,
      hintsAvailable: 5,
      roundsPlayed: 0,
    );
  }

  Future<void> updatePlayer(Player updated) async {
    final row = _toRow(updated);
    await db.updatePlayerRow(row);
  }

  Future<void> deletePlayer(int id) async {
    await db.deletePlayerById(id);
  }
}
