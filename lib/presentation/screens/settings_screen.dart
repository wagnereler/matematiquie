// lib/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Aqui futuramente:\n"
          "• Escolher idioma da interface\n"
          "• Configurações pedagógicas\n"
          "• Dificuldade padrão\n",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ),
    );
  }
}
