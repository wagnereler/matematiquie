// lib/presentation/screens/addition_result_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_lite/l10n/l10n.dart';

import '../../domain/round_summary.dart';
import '../../domain/round_attempt.dart';

class AdditionResultScreen extends StatelessWidget {
  final RoundSummary summary;
  final int parcels;
  final int level;
  final int decimals;

  const AdditionResultScreen({
    super.key,
    required this.summary,
    required this.parcels,
    required this.level,
    required this.decimals,
  });

  int _countCorrect() => summary.attempts.where((a) => a.isCorrect).length;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final correct = _countCorrect();
    final total = summary.attempts.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
        ),
        title: Text(l10n.result_title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              l10n.result_performance_title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            Text(
              l10n.score_fmt(correct, total),
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
                  ? l10n.praise_perfect
                  : (correct >= total * 0.7
                      ? l10n.praise_good
                      : l10n.praise_try_more),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.3),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),

            // Lista das tentativas
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
                        context.go(
                          '/train/addition/game',
                          extra: {
                            'parcels': parcels,
                            'level': level,
                            'decimals': decimals,
                          },
                        );
                      },
                      label: Text(l10n.play_again),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                      onPressed: () => context.go('/'),
                      label: Text(l10n.back_home),
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

class _AttemptRow extends StatelessWidget {
  final RoundAttempt attempt;
  final int number;
  const _AttemptRow({required this.attempt, required this.number});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wasAnswered = attempt.selectedAnswer != null;
    final wasCorrect = attempt.isCorrect;
    final userAnswerText =
        wasAnswered ? "${attempt.selectedAnswer}" : l10n.no_answer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.attempt_question_fmt(number, attempt.questionText),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              l10n.you_answered_fmt(userAnswerText),
              style: TextStyle(
                fontSize: 15,
                color: wasCorrect ? Colors.green.shade700 : Colors.red.shade700,
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
          l10n.correct_fmt("${attempt.correctAnswer}"),
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
    );
  }
}
