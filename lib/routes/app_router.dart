// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/home_screen.dart';
import '../presentation/screens/play_screen.dart';
import '../presentation/screens/multiplication_table_select_screen.dart';
import '../presentation/screens/multiplication_game_screen.dart';
import '../presentation/screens/statistics_screen.dart';
import '../presentation/screens/player_select_screen.dart';

import '../domain/attempts_repository.dart';

class AppRouter {
  static GoRouter makeRouter() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/play',
          builder: (context, state) => const PlayScreen(),
        ),
        GoRoute(
          path: '/train/multiplication/select',
          builder: (context, state) => const MultiplicationTableSelectScreen(),
        ),
        GoRoute(
          path: '/train/multiplication/play',
          builder: (context, state) {
            final table = state.uri.queryParameters['table'] ?? '2';
            final attemptsRepo = context.read<AttemptsRepository>();
            return MultiplicationGameScreen(
              tableParam: table,
              attemptsRepo: attemptsRepo,
            );
          },
        ),
        GoRoute(
          path: '/players',
          builder: (context, state) => const PlayerSelectScreen(),
        ),
        GoRoute(
          path: '/stats',
          builder: (context, state) => const StatisticsScreen(),
        ),
      ],
      errorBuilder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Page Not Found')),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'GoException: no routes for location: ${state.uri}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Home'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
