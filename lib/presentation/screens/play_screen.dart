// lib/presentation/screens/play_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/')),
        title: const Text('Treinar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Escolha o tipo de treino:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade600,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () => context.go('/train/multiplication/select'),
              child: const Text("Tabuada (×)"),
            ),
          ],
        ),
      ),
    );
  }
}
