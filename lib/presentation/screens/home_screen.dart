// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/players_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _bigButton({
    required IconData icon,
    required String label,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.black.withOpacity(0.15),
              width: 1,
            ),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playersState = context.watch<PlayersCubit>().state;
    final activePlayer = playersState.activePlayer;

    final playerName = activePlayer?.name ?? "Nenhum jogador ativo";
    final playerLevel = activePlayer != null
        ? "Nível: ${activePlayer.difficultyMax}"
        : "Escolha um jogador";
    final playerHints = activePlayer != null
        ? "Dicas: ${activePlayer.hintsAvailable}/5"
        : "";

    // texto abaixo dos botões
    final footerMessage = activePlayer != null
        ? "Pratique todos os dias um pouquinho.\nComece devagar, priorize o acerto 😊"
        : "Crie ou ative um jogador para salvar progresso.\nCada jogador tem nível e dicas próprias 😉";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Matematiquei",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFFF8E6), // tom clarinho amarelo/bege
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- BLOCO DO JOGADOR ATIVO + BOTÃO TROCAR ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // infos do jogador (mantemos o mesmo estilo centralizado do print)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Jogador: $playerName",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activePlayer != null
                              ? "$playerLevel  •  $playerHints"
                              : playerLevel,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // botão de trocar/cadastrar jogador
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      side: const BorderSide(color: Colors.black45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      foregroundColor: Colors.black87,
                    ),
                    onPressed: () {
                      // abre a tela de seleção/cadastro de jogador
                      context.go('/players');
                    },
                    child: Text(
                      activePlayer != null
                          ? "Trocar"
                          : "Escolher / Cadastrar",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- BOTÃO TREINAR ---
              _bigButton(
                icon: Icons.play_arrow_rounded,
                label: "Treinar",
                background: Colors.amber.shade600,
                foreground: Colors.black,
                onTap: () {
                  context.go('/train/multiplication/select');
                },
              ),

              const SizedBox(height: 16),

              // --- BOTÃO ESTATÍSTICAS ---
              _bigButton(
                icon: Icons.bar_chart_rounded,
                label: "Estatísticas",
                background: const Color(0xFF3A3F45),
                foreground: Colors.white,
                onTap: () {
                  context.go('/stats');
                },
              ),

              const SizedBox(height: 32),

              Text(
                footerMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
