// lib/presentation/screens/player_select_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:math_lite/l10n/l10n.dart';
import '../../application/players_cubit.dart';
import '../../domain/player.dart';

class PlayerSelectScreen extends StatelessWidget {
  const PlayerSelectScreen({super.key});

  String _modeLabel(BuildContext context, String code) {
    final l10n = context.l10n;
    switch (code) {
      case 'mul':
        return l10n.mode_multiplication;
      case 'add':
        return l10n.mode_addition;
      case 'sub':
        return l10n.mode_subtraction;
      case 'div':
        return l10n.mode_division;
      default:
        return code;
    }
  }

  String _langLabel(BuildContext context, String code) {
    final l10n = context.l10n;
    switch (code) {
      case 'pt':
        return l10n.lang_portuguese;
      case 'en':
        return l10n.lang_english;
      case 'es':
        return l10n.lang_spanish;
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go('/'),
        ),
        title: Text(l10n.players_title),
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
              Text(
                l10n.players_list,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              for (final p in state.players)
                _PlayerCard(
                  player: p,
                  isActive: p.id == state.activePlayerId,
                  langLabel: _langLabel(context, p.languageCode),
                  modeLabel: _modeLabel(context, p.mode),
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

              Text(
                l10n.players_info,
                style: const TextStyle(fontSize: 14, height: 1.4),
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
                  child: Text("➕ ${l10n.players_new}"),
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
  final String langLabel;
  final String modeLabel;
  final VoidCallback onActivate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PlayerCard({
    required this.player,
    required this.isActive,
    required this.langLabel,
    required this.modeLabel,
    required this.onActivate,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
              isActive
                  ? "${player.name} (${l10n.players_current})"
                  : player.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                IconButton(
                  tooltip: l10n.tooltip_activate,
                  onPressed: onActivate,
                  icon: const Icon(Icons.check_circle_outline),
                ),
                IconButton(
                  tooltip: l10n.tooltip_edit,
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: l10n.tooltip_delete,
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text("${l10n.label_language}: $langLabel"),
            Text("${l10n.label_mode}: $modeLabel"),
            Text(l10n.difficulty_fmt(player.difficultyMax)),
          ],
        ),
      ),
    );
  }
}

Future<void> _showAddPlayerDialog(BuildContext context) async {
  final cubit = context.read<PlayersCubit>();
  final l10n = context.l10n;

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
                Text(
                  l10n.players_add_title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.label_name,
                    hintText: l10n.name_hint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: lang,
                        decoration: InputDecoration(
                          labelText: l10n.label_language,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: 'pt', child: Text(l10n.lang_portuguese)),
                          DropdownMenuItem(
                              value: 'en', child: Text(l10n.lang_english)),
                          DropdownMenuItem(
                              value: 'es', child: Text(l10n.lang_spanish)),
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
                        decoration: InputDecoration(
                          labelText: l10n.label_mode,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: 'mul',
                              child: Text(l10n.mode_multiplication)),
                          DropdownMenuItem(
                              value: 'add',
                              child: Text(l10n.mode_addition)),
                          DropdownMenuItem(
                              value: 'sub',
                              child: Text(l10n.mode_subtraction)),
                          DropdownMenuItem(
                              value: 'div',
                              child: Text(l10n.mode_division)),
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
                  decoration: InputDecoration(
                    labelText: l10n.difficulty_hint,
                    border: const OutlineInputBorder(),
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
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },
                  child: Text(l10n.save_player),
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
  final l10n = context.l10n;

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
                Text(
                  l10n.players_edit_title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.label_name,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: lang,
                        decoration: InputDecoration(
                          labelText: l10n.label_language,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: 'pt', child: Text(l10n.lang_portuguese)),
                          DropdownMenuItem(
                              value: 'en', child: Text(l10n.lang_english)),
                          DropdownMenuItem(
                              value: 'es', child: Text(l10n.lang_spanish)),
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
                        decoration: InputDecoration(
                          labelText: l10n.label_mode,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: 'mul',
                              child: Text(l10n.mode_multiplication)),
                          DropdownMenuItem(
                              value: 'add',
                              child: Text(l10n.mode_addition)),
                          DropdownMenuItem(
                              value: 'sub',
                              child: Text(l10n.mode_subtraction)),
                          DropdownMenuItem(
                              value: 'div',
                              child: Text(l10n.mode_division)),
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
                  decoration: InputDecoration(
                    labelText: l10n.difficulty_hint,
                    border: const OutlineInputBorder(),
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
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },
                  child: Text(l10n.save_changes),
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
  final l10n = context.l10n;

  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(l10n.players_delete_title),
        content: Text(
          l10n.players_delete_confirm_fmt(player.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
