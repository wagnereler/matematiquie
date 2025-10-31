// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/home_screen.dart';
import '../presentation/screens/play_screen.dart';
import '../presentation/screens/multiplication_table_select_screen.dart';
import '../presentation/screens/multiplication_game_screen.dart';
import '../presentation/screens/multiplication_result_screen.dart';
import '../presentation/screens/statistics_screen.dart';
import '../presentation/screens/player_select_screen.dart';

import '../domain/attempts_repository.dart';
import '../domain/round_summary.dart';

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
          path: '/players',
          builder: (context, state) => const PlayerSelectScreen(),
        ),
        GoRoute(
          path: '/stats',
          builder: (context, state) => const StatisticsScreen(),
        ),

        // Seleção da tabuada
        GoRoute(
          path: '/train/multiplication/select',
          builder: (context, state) => const MultiplicationTableSelectScreen(),
        ),

        // NOVO: rota de jogo com parâmetro no path (ex.: /train/multiplication/game/7 ou /random_2_10 ou /errors)
        GoRoute(
          path: '/train/multiplication/game/:tableParam',
          builder: (context, state) {
            final tableParam = state.pathParameters['tableParam']!;
            final attemptsRepo = context.read<AttemptsRepository>();
            return MultiplicationGameScreen(
              tableParam: tableParam,
              attemptsRepo: attemptsRepo,
            );
          },
        ),

        // LEGADO/compat: rota antiga via query (?table=7). Mantida para não quebrar navegações antigas.
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

        // NOVO: tela de resultado. Recebe via state.extra: { 'summary': RoundSummary, 'replayParam': String }
        GoRoute(
          path: '/train/multiplication/result',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is Map) {
              final summary = extra['summary'] as RoundSummary?;
              final replayParam = (extra['replayParam'] as String?) ?? '2';

              if (summary != null) {
                return MultiplicationResultScreen(
                  summary: summary,
                  replayParam: replayParam,
                );
              }
            }

            // Fallback defensivo caso chegue sem os dados esperados.
            return Scaffold(
              appBar: AppBar(title: const Text('Results')),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Missing result data'),
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

final GoRouter appRouter = AppRouter.makeRouter();
