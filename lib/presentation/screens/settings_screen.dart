// lib/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:math_lite/l10n/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          context.l10n.settings_body,
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
      ),
    );
  }
}
