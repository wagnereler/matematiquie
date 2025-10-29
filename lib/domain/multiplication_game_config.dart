// lib/domain/multiplication_game_config.dart
import 'package:equatable/equatable.dart';

/// Define como o jogo de multiplicação vai rodar.
///
/// Existem dois modos:
/// 1. Modo tabuada fixa:
///    - tableBase != null (ex: tabuada do 7)
///    - focusPairs == null
///
/// 2. Modo treino de erros:
///    - tableBase == null
///    - focusPairs contém pares específicos (a, b)
///      que o jogador errou muito, ex: [(7,5), (9,6), ...]
///
/// Em ambos os casos a dificuldade (difficultyLevel)
/// controla o tempo de resposta (20s → 2s).
class MultiplicationGameConfig extends Equatable {
  final int playerId;
  final int difficultyLevel;

  /// Ex.: 7 significa "tabuada do 7"
  final int? tableBase;

  /// Lista das operações específicas que o aluno mais errou,
  /// no formato (a, b) representando "a × b".
  final List<(int, int)>? focusPairs;

  const MultiplicationGameConfig({
    required this.playerId,
    required this.difficultyLevel,
    this.tableBase,
    this.focusPairs,
  });

  bool get isErrorTraining => focusPairs != null && focusPairs!.isNotEmpty;

  @override
  List<Object?> get props => [
        playerId,
        difficultyLevel,
        tableBase,
        focusPairs,
      ];
}
