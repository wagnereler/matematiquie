// lib/presentation/screens/multiplication_result_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/round_summary.dart';
import '../../domain/round_attempt.dart';

/// Tela que aparece depois de terminar a rodada (10 perguntas)
/// Mostra:
///  - pontuação final
///  - lista de respostas
///  - botões "Jogar de novo" e "Voltar"
class MultiplicationResultScreen extends StatelessWidget {
  final RoundSummary summary;
  final String replayParam; // ex: "7" ou "random_2_10"

  const MultiplicationResultScreen({
    super.key,
    required this.summary,
    required this.replayParam,
  });

  int _countCorrect() {
    return summary.attempts.where((a) => a.isCorrect).length;
  }

  @override
  Widget build(BuildContext context) {
    final correct = _countCorrect();
    final total = summary.attempts.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            // força voltar pra Home e não pra rotas antigas como /play
            context.go('/');
          },
        ),
        title: const Text('Resultado'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              "Seu desempenho",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            // pontuação grande
            Text(
              "$correct / $total acertos",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: correct >= (total * 0.7)
                    ? Colors.green.shade700
                    : Colors.red.shade700,
              ),
            ),

            const SizedBox(height: 8),
            Text(
              correct == total
                  ? "Excelente! Você acertou todas 👏"
                  : correct >= total * 0.7
                      ? "Muito bom! Continue praticando 👌"
                      : "Tudo bem errar 🙂 Vamos treinar mais um pouquinho.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.3),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),

            // Lista de perguntas/respostas
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: summary.attempts.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 16, thickness: 0.5),
                itemBuilder: (context, index) {
                  final attempt = summary.attempts[index];
                  return _AttemptRow(attempt: attempt, number: index + 1);
                },
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Botão "Jogar novamente"
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade600,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        // Vai direto pro jogo novamente com mesmo parâmetro
                        //
                        // Nossa rota de jogo deve aceitar algo como:
                        // /train/multiplication/game/:tableParam
                        // Ex: /train/multiplication/game/7
                        // ou  /train/multiplication/game/random_2_10
                        context.go(
                          '/train/multiplication/game/$replayParam',
                        );
                      },
                      label: const Text("Jogar de novo"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Botão "Voltar"
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.home_outlined),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.amber.shade800),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        // Em vez de tentar voltar pra rota anterior (que às vezes é /play),
                        // manda pra Home de forma direta e segura.
                        context.go('/');
                      },
                      label: const Text("Voltar para início"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Linha individual mostrando cada tentativa:
///   Pergunta "3 × 7 = ?"
///   Você respondeu: 21 (✅ ou ❌)
///   Correto era: 21
class _AttemptRow extends StatelessWidget {
  final RoundAttempt attempt;
  final int number;

  const _AttemptRow({
    required this.attempt,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    final wasAnswered = attempt.selectedAnswer != null;
    final wasCorrect = attempt.isCorrect;
    final userAnswerText =
        wasAnswered ? "${attempt.selectedAnswer}" : "— (sem resposta)";
    final qText = attempt.questionText; // já é tipo "3 × 7 = ?"

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pergunta $number: $qText",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              "Você respondeu: $userAnswerText",
              style: TextStyle(
                fontSize: 15,
                color: wasCorrect
                    ? Colors.green.shade700
                    : Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              wasCorrect ? Icons.check_circle : Icons.cancel,
              color: wasCorrect ? Colors.green.shade700 : Colors.red.shade700,
              size: 18,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "Correto: ${attempt.correctAnswer}",
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
    );
  }
}
