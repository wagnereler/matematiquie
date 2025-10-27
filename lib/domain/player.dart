// lib/domain/player.dart
import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final int id;
  final String name;
  final String languageCode; // 'pt', 'en', 'es'
  final String mode; // 'mul', 'add', 'sub', 'div'
  final int difficultyMax; // nível 1..10 (velocidade do jogo)

  final int hintsAvailable; // 0..5
  final int roundsPlayed;   // contador de rodadas finalizadas

  const Player({
    required this.id,
    required this.name,
    required this.languageCode,
    required this.mode,
    required this.difficultyMax,
    required this.hintsAvailable,
    required this.roundsPlayed,
  });

  Player copyWith({
    int? id,
    String? name,
    String? languageCode,
    String? mode,
    int? difficultyMax,
    int? hintsAvailable,
    int? roundsPlayed,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      languageCode: languageCode ?? this.languageCode,
      mode: mode ?? this.mode,
      difficultyMax: difficultyMax ?? this.difficultyMax,
      hintsAvailable: hintsAvailable ?? this.hintsAvailable,
      roundsPlayed: roundsPlayed ?? this.roundsPlayed,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        languageCode,
        mode,
        difficultyMax,
        hintsAvailable,
        roundsPlayed,
      ];
}
