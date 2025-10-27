// lib/presentation/screens/statistics_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/players_cubit.dart';
import '../../infrastructure/db/app_database.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _loading = true;

  String? _playerName;
  int _total = 0;
  int _correct = 0;

  // mapa tabuadaBase -> estatísticas dessa tabuada
  final Map<int, _TabStats> _perTable = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final playersState = context.read<PlayersCubit>().state;
    final active = playersState.activePlayer;
    final db = context.read<AppDatabase>();

    if (active == null) {
      setState(() {
        _playerName = null;
        _loading = false;
        _total = 0;
        _correct = 0;
        _perTable.clear();
      });
      return;
    }

    final attempts = await db.getAttemptsForPlayer(active.id);

    int total = attempts.length;
    int correct = 0;

    final Map<int, _TabStats> perTable = {};

    for (final a in attempts) {
      if (a.isCorrect) correct++;

      perTable.putIfAbsent(
        a.tableBase,
        () => _TabStats(total: 0, correct: 0),
      );

      final stat = perTable[a.tableBase]!;
      stat.total++;
      if (a.isCorrect) {
        stat.correct++;
      }
    }

    setState(() {
      _playerName = active.name;
      _loading = false;
      _total = total;
      _correct = correct;
      _perTable
        ..clear()
        ..addAll(perTable);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasPlayer = _playerName != null;

    // monta a lista de cards por tabuada (ordenada pela tabuada)
    final List<Widget> perTableWidgets = () {
      final entries = _perTable.entries.toList();
      entries.sort((a, b) => a.key.compareTo(b.key));

      return entries.map((entry) {
        return _TabuadaCard(
          base: entry.key,
          stats: entry.value,
        );
      }).toList();
    }();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go('/'),
        ),
        title: const Text('Estatísticas'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _loadStats,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !hasPlayer
              ? const Center(
                  child: Text(
                    "Nenhum jogador ativo.\nEscolha ou crie um jogador.",
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Text(
                        "Jogador: $_playerName",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // CARTÃO RESUMO GERAL
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.amber.shade800,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Resumo geral",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("Total de perguntas: $_total"),
                            Text("Acertos: $_correct"),
                            Text(
                              _total == 0
                                  ? "Aproveitamento: —"
                                  : "Aproveitamento: "
                                      "${((_correct / _total) * 100).toStringAsFixed(1)}%",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        "Por tabuada",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (_perTable.isEmpty)
                        const Text(
                          "Ainda não temos dados por tabuada.\nJogue uma rodada!",
                          style: TextStyle(fontSize: 14),
                        )
                      else
                        Column(
                          children: perTableWidgets,
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _TabStats {
  int total;
  int correct;
  _TabStats({
    required this.total,
    required this.correct,
  });
}

class _TabuadaCard extends StatelessWidget {
  final int base;
  final _TabStats stats;
  const _TabuadaCard({
    required this.base,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final perc = stats.total == 0
        ? "-"
        : "${((stats.correct / stats.total) * 100).toStringAsFixed(1)}%";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Text(
            "× $base",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Acertos: ${stats.correct}/${stats.total} ($perc)",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
