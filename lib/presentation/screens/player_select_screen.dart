// lib/presentation/screens/player_select_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/players_cubit.dart';
import '../../domain/player.dart';
import '../../domain/game_mode.dart';

class PlayerSelectScreen extends StatelessWidget {
  const PlayerSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go('/'),
        ),
        title: const Text('Escolher jogador'),
      ),
      body: BlocBuilder<PlayersCubit, PlayersState>(
        builder: (context, state) {
          final cubit = context.read<PlayersCubit>();

          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Jogadores",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              for (final p in state.players)
                _PlayerCard(
                  player: p,
                  isActive: p.id == state.activePlayerId,
                  onActivate: () => cubit.selectPlayer(p.id),
                  onEdit: () async {
                    await _showEditPlayerDialog(context, p);
                  },
                  onDelete: () async {
                    final confirmed = await _confirmDelete(context, p);
                    if (confirmed == true) {
                      await cubit.removePlayer(p.id);
                    }
                  },
                ),

              const SizedBox(height: 24),
              const Divider(height: 32),

              const Text(
                "Cada jogador pode ter idioma, modo preferido e "
                "dificuldade própria (1 a 10). Isso ajuda o adulto a "
                "personalizar o treino sem misturar progresso das crianças.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),

              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    await _showAddPlayerDialog(context);
                  },
                  child: const Text("➕ Novo jogador"),
                ),
              ),

              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final Player player;
  final bool isActive;
  final VoidCallback onActivate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PlayerCard({
    required this.player,
    required this.isActive,
    required this.onActivate,
    required this.onEdit,
    required this.onDelete,
  });

  String _langLabel(String code) {
    switch (code) {
      case 'pt':
        return 'Português';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gm = GameModeX.fromCode(player.mode);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isActive ? Colors.amber.shade100 : Colors.white,
        border: Border.all(
          color: isActive ? Colors.orange.shade800 : Colors.black12,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isActive ? "${player.name} (ATUAL)" : player.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                IconButton(
                  tooltip: 'Ativar',
                  onPressed: onActivate,
                  icon: const Icon(Icons.check_circle_outline),
                ),
                IconButton(
                  tooltip: 'Editar',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Excluir',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text("Idioma: ${_langLabel(player.languageCode)}"),
            Text("Modo: ${gm.labelPt}"),
            Text("Dificuldade: nível ${player.difficultyMax}/10"),
          ],
        ),
      ),
    );
  }
}

Future<void> _showAddPlayerDialog(BuildContext context) async {
  final cubit = context.read<PlayersCubit>();

  final nameCtrl = TextEditingController();
  String lang = 'pt';
  String mode = 'mul';
  int difficulty = 5;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Novo jogador",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    hintText: "Ex.: Ana, João...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: lang,
                        decoration: const InputDecoration(
                          labelText: "Idioma",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'pt', child: Text('Português')),
                          DropdownMenuItem(
                              value: 'en', child: Text('English')),
                          DropdownMenuItem(
                              value: 'es', child: Text('Español')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              lang = v;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: mode,
                        decoration: const InputDecoration(
                          labelText: "Modo",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'mul', child: Text('Multiplicação')),
                          DropdownMenuItem(
                              value: 'add', child: Text('Adição')),
                          DropdownMenuItem(
                              value: 'sub', child: Text('Subtração')),
                          DropdownMenuItem(
                              value: 'div', child: Text('Divisão')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              mode = v;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<int>(
                  value: difficulty,
                  decoration: const InputDecoration(
                    labelText: "Dificuldade (1 fácil, 10 rápido)",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (int i = 1; i <= 10; i++)
                      DropdownMenuItem(value: i, child: Text(i.toString())),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        difficulty = v;
                      });
                    }
                  },
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade600,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    if (nameCtrl.text.trim().isEmpty) return;
                    await cubit.addPlayer(
                      name: nameCtrl.text.trim(),
                      languageCode: lang,
                      mode: mode,
                      difficultyMax: difficulty,
                    );
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("Salvar jogador"),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

Future<void> _showEditPlayerDialog(BuildContext context, Player player) async {
  final cubit = context.read<PlayersCubit>();

  final nameCtrl = TextEditingController(text: player.name);
  String lang = player.languageCode;
  String mode = player.mode;
  int difficulty = player.difficultyMax;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Editar jogador",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: lang,
                        decoration: const InputDecoration(
                          labelText: "Idioma",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'pt', child: Text('Português')),
                          DropdownMenuItem(
                              value: 'en', child: Text('English')),
                          DropdownMenuItem(
                              value: 'es', child: Text('Español')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              lang = v;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: mode,
                        decoration: const InputDecoration(
                          labelText: "Modo",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'mul', child: Text('Multiplicação')),
                          DropdownMenuItem(
                              value: 'add', child: Text('Adição')),
                          DropdownMenuItem(
                              value: 'sub', child: Text('Subtração')),
                          DropdownMenuItem(
                              value: 'div', child: Text('Divisão')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              mode = v;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<int>(
                  value: difficulty,
                  decoration: const InputDecoration(
                    labelText: "Dificuldade (1 fácil, 10 rápido)",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (int i = 1; i <= 10; i++)
                      DropdownMenuItem(value: i, child: Text(i.toString())),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        difficulty = v;
                      });
                    }
                  },
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade600,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    await cubit.updatePlayer(
                      player.copyWith(
                        name: nameCtrl.text.trim(),
                        languageCode: lang,
                        mode: mode,
                        difficultyMax: difficulty,
                      ),
                    );
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("Salvar alterações"),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

Future<bool?> _confirmDelete(BuildContext context, Player player) async {
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("Excluir jogador"),
        content: Text(
            "Tem certeza que deseja excluir '${player.name}'? Isso não pode ser desfeito."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              "Excluir",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
