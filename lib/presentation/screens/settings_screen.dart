// lib/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_lite/l10n/l10n.dart';
import '../../application/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.watch<SettingsCubit>();
    final mode = cubit.state.themeMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings_title),
        // back/close explícito (funciona mesmo se a tela foi aberta com go)
        leading: Builder(
          builder: (context) {
            final canPop = Navigator.of(context).canPop();
            return IconButton(
              icon: Icon(canPop ? Icons.arrow_back : Icons.close),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  context.go('/'); // fallback pra Home
                }
              },
            );
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // texto existente
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              l10n.settings_body,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
          const Divider(),

          const SizedBox(height: 8),
          Text(
            l10n.settings_theme_title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: mode,
            onChanged: (v) => v != null ? cubit.setThemeMode(v) : null,
            title: Text(l10n.settings_theme_system),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: mode,
            onChanged: (v) => v != null ? cubit.setThemeMode(v) : null,
            title: Text(l10n.settings_theme_light),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: mode,
            onChanged: (v) => v != null ? cubit.setThemeMode(v) : null,
            title: Text(l10n.settings_theme_dark),
          ),
          const SizedBox(height: 24),
          // Botão extra quando não há histórico (por exemplo, se abriu via go)
          if (!Navigator.of(context).canPop())
            FilledButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home_rounded),
              label: Text(l10n.go_home),
            ),        
        ],
      ),
    );
  }
}
