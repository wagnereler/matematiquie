// lib/application/players_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart'; // ← para Locale

import '../domain/player.dart';
import '../infrastructure/players_repository.dart';
import '../infrastructure/profile_prefs.dart';

class PlayersState extends Equatable {
  final bool loading;
  final List<Player> players;
  final int? activePlayerId;

  const PlayersState({
    required this.loading,
    required this.players,
    required this.activePlayerId,
  });

  factory PlayersState.initial() =>
      const PlayersState(loading: true, players: [], activePlayerId: null);

  PlayersState copyWith({
    bool? loading,
    List<Player>? players,
    int? activePlayerId,
  }) {
    return PlayersState(
      loading: loading ?? this.loading,
      players: players ?? this.players,
      activePlayerId: activePlayerId ?? this.activePlayerId,
    );
  }

  Player? get activePlayer =>
      players.firstWhereOrNull((p) => p.id == activePlayerId);

  @override
  List<Object?> get props => [loading, players, activePlayerId];
}

class PlayersCubit extends Cubit<PlayersState> {
  final PlayersRepository repo;
  final ProfilePrefs prefs;

  PlayersCubit({
    required this.repo,
    required this.prefs,
  }) : super(PlayersState.initial());

  // ===== Locale da UI conforme o jogador ativo =====
  Locale _localeFromCode(String? raw) {
    final x = (raw ?? 'pt').toLowerCase();
    if (x.startsWith('en')) return const Locale('en');
    if (x.startsWith('es')) return const Locale('es');
    return const Locale('pt');
  }

  /// Locale atual da interface, calculado a partir do jogador ativo.
  Locale get uiLocale =>
      _localeFromCode(state.activePlayer?.languageCode);

  // ================== Ações ==================
  Future<void> load() async {
    emit(state.copyWith(loading: true));

    final list = await repo.getPlayers();

    int? activeId = prefs.getActivePlayerId();
    if (activeId == null && list.isNotEmpty) {
      activeId = list.first.id;
      await prefs.setActivePlayerId(activeId);
    }

    emit(
      state.copyWith(
        loading: false,
        players: list,
        activePlayerId: activeId,
      ),
    );
  }

  Future<void> selectPlayer(int id) async {
    await prefs.setActivePlayerId(id);
    emit(state.copyWith(activePlayerId: id));
  }

  Future<void> addPlayer({
    required String name,
    String languageCode = 'pt',
    String mode = 'mul',
    int difficultyMax = 5,
  }) async {
    await repo.addPlayer(
      name: name,
      languageCode: languageCode,
      mode: mode,
      difficultyMax: difficultyMax,
    );
    await load();
  }

  Future<void> updatePlayer(Player updated) async {
    await repo.updatePlayer(updated);
    await load();
  }

  Future<void> removePlayer(int id) async {
    await repo.deletePlayer(id);

    final rest = await repo.getPlayers();

    int? newActiveId;
    if (rest.isEmpty) {
      await prefs.clearActivePlayerId();
      newActiveId = null;
    } else {
      if (state.activePlayerId == id) {
        newActiveId = rest.first.id;
        await prefs.setActivePlayerId(newActiveId);
      } else {
        newActiveId = state.activePlayerId;
      }
    }

    emit(
      state.copyWith(
        loading: false,
        players: rest,
        activePlayerId: newActiveId,
      ),
    );
  }
}
