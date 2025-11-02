// lib/presentation/screens/play_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_lite/l10n/l10n.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/')),
        title: Text(l10n.play_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              l10n.play_chooseType,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Multiplicação
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade600,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () => context.go('/train/multiplication/select'),
              child: Text(l10n.play_multiplication),
            ),

            const SizedBox(height: 12),

            // Adição (vai para a tela de opções)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade600,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () => context.go('/train/addition/options'),
              child: Text(l10n.play_addition),
            ),
          ],
        ),
      ),
    );
  }
}
