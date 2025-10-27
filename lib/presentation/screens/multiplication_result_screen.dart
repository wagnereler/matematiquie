// lib/presentation/screens/multiplication_result_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/round_summary.dart';
import '../../domain/round_attempt.dart';

class MultiplicationResultScreen extends StatelessWidget {
  final RoundSummary summary;
  final String replayParam;

  const MultiplicationResultScreen({
    super.key,
    required this.summary,
    required this.replayParam,
  });

  @override
  Widget build(BuildContext context) {
    final acertos = summary.correct;
    final total = summary.total;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go('/play'),
        ),
        title: const Text("Resultado"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Você acertou $acertos de $total!",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: summary.attempts.length,
                itemBuilder: (context, index) {
                  final attempt = summary.attempts[index];
                  return _AttemptTile(attempt: attempt);
                },
              ),
            ),

            const SizedBox(height: 12),

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
              onPressed: () => context.go(
                '/train/multiplication/play/$replayParam',
              ),
              child: const Text("Jogar novamente"),
            ),

            const SizedBox(height: 8),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.amber.shade800, width: 2),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: Colors.amber.shade100,
              ),
              onPressed: () => context.go('/play'),
              child: const Text("Voltar"),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttemptTile extends StatelessWidget {
  final RoundAttempt attempt;
  const _AttemptTile({required this.attempt});

  @override
  Widget build(BuildContext context) {
    final color =
        attempt.isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    final borderColor =
        attempt.isCorrect ? Colors.green.shade700 : Colors.red.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                attempt.questionText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text("Sua resposta: ${attempt.selectedAnswer ?? '—'}"),
              Text("Correto: ${attempt.correctAnswer}"),
              Text(
                attempt.isCorrect ? "✔ Acertou" : "✘ Errou",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: attempt.isCorrect
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
