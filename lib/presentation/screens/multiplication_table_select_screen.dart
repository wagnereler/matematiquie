// lib/presentation/screens/multiplication_table_select_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/players_cubit.dart';
import '../../domain/attempts_repository.dart';

class MultiplicationTableSelectScreen extends StatelessWidget {
  const MultiplicationTableSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activePlayer = context.watch<PlayersCubit>().state.activePlayer;
    final attemptsRepo = context.read<AttemptsRepository>();

    Future<void> _goFixedTable(int n) async {
      context.go('/train/multiplication/play?table=$n');
    }

    Future<void> _goErrors() async {
      if (activePlayer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ative um jogador para treinar os erros.")),
        );
        return;
      }

      final pairs = await attemptsRepo.getWorstPairsForPlayer(
        activePlayer.id,
        limit: 10,
      );

      if (pairs.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Ainda não temos erros suficientes.\nJogue algumas rodadas primeiro 😉"),
            ),
          );
        }
        return;
      }

      if (context.mounted) {
        context.go('/train/multiplication/play?table=errors');
      }
    }

    Future<void> _goRandom() async {
      final range = await _askRandomRangeDialog(context);
      if (range == null) return;
      final (minBase, maxBase) = range;
      if (context.mounted) {
        context.go('/train/multiplication/play?table=random_${minBase}_${maxBase}');
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Treinar multiplicação"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // centraliza verticalmente
                  children: [
                    // Linha 1: 2 3 4
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TableButton(topText: "2", bottomText: "x2", onTap: () => _goFixedTable(2)),
                        const SizedBox(width: 12),
                        _TableButton(topText: "3", bottomText: "x3", onTap: () => _goFixedTable(3)),
                        const SizedBox(width: 12),
                        _TableButton(topText: "4", bottomText: "x4", onTap: () => _goFixedTable(4)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Linha 2: 5 6 7
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TableButton(topText: "5", bottomText: "x5", onTap: () => _goFixedTable(5)),
                        const SizedBox(width: 12),
                        _TableButton(topText: "6", bottomText: "x6", onTap: () => _goFixedTable(6)),
                        const SizedBox(width: 12),
                        _TableButton(topText: "7", bottomText: "x7", onTap: () => _goFixedTable(7)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Linha 3: 8 9 Erros
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TableButton(topText: "8", bottomText: "x8", onTap: () => _goFixedTable(8)),
                        const SizedBox(width: 12),
                        _TableButton(topText: "9", bottomText: "x9", onTap: () => _goFixedTable(9)),
                        const SizedBox(width: 12),
                        _TableButton(topText: "🎯", bottomText: "Erros", onTap: _goErrors),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Linha 4: Aleatório ocupando de [8] até [Erros]
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 80), // placeholder largura do [8]
                          const SizedBox(width: 12),  // espaço entre colunas
                          Expanded(
                            child: _TableButton(
                              topText: "🎲",
                              bottomText: "Aleatório",
                              onTap: _goRandom,
                              expanded: true, // <-- deixa ocupar todo espaço disponível
                            ),
                          ),
                          const SizedBox(width: 12),  // espaço entre colunas
                          const SizedBox(width: 80), // placeholder largura do [Erros]
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "'Erros' foca nas contas que você mais errou (ex: 7×5).\n"
                        "'Aleatório' mistura tabuadas num intervalo que você escolhe.\n"
                        "Cada rodada tem 10 perguntas e salva tudo no histórico.",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// botão 80x80 (ou “expandido” horizontalmente) com topo grande e legenda embaixo
class _TableButton extends StatelessWidget {
  final String topText;
  final String bottomText;
  final VoidCallback onTap;
  final bool expanded; // quando true, ocupa toda a largura disponível

  const _TableButton({
    super.key,
    required this.topText,
    required this.bottomText,
    required this.onTap,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final btn = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber.shade600,
        foregroundColor: Colors.black,
        minimumSize: expanded
            ? const Size.fromHeight(80) // altura 80, largura cresce via Row/Expanded
            : const Size(80, 80),
        padding: const EdgeInsets.all(6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black26),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            topText,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            bottomText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.2),
          ),
        ],
      ),
    );

    // Se expandido, não fixa largura; caso contrário, 80x80
    return expanded
        ? SizedBox(height: 80, child: btn)
        : SizedBox(width: 80, height: 80, child: btn);
  }
}

/// Pede o intervalo para o treino Aleatório.
/// Retorna (minBase, maxBase) ou null se cancelar.
Future<(int, int)?> _askRandomRangeDialog(BuildContext context) async {
  final minCtrl = TextEditingController(text: "2");
  final maxCtrl = TextEditingController(text: "10");

  final result = await showDialog<(int, int)?>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("Treino aleatório"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Escolha o intervalo de tabuadas que quer misturar.\n"
              "Exemplo: de 2 até 10.\n"
              "Você também pode usar valores maiores (11 até 20, etc).",
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "De",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text("até"),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: maxCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Até",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              final minVal = int.tryParse(minCtrl.text) ?? 2;
              final maxVal = int.tryParse(maxCtrl.text) ?? 10;
              Navigator.of(ctx).pop((minVal, maxVal));
            },
            child: const Text("Jogar"),
          ),
        ],
      );
    },
  );

  return result;
}
