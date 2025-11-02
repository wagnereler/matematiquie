// lib/routes/app_router.dart 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/play_screen.dart';
import '../presentation/screens/multiplication_options_select_screen.dart';
import '../presentation/screens/multiplication_game_screen.dart';
import '../presentation/screens/multiplication_result_screen.dart';
import '../presentation/screens/statistics_screen.dart';
import '../presentation/screens/player_select_screen.dart';

// Adição
import '../presentation/screens/addition_options_select_screen.dart';
import '../presentation/screens/addition_game_screen.dart';
import '../presentation/screens/addition_result_screen.dart';

import '../domain/attempts_repository.dart';
import '../domain/round_summary.dart';

class AppRouter {
  static GoRouter makeRouter() {
    return GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/play', builder: (context, state) => const PlayScreen()),
        GoRoute(path: '/players', builder: (context, state) => const PlayerSelectScreen()),
        GoRoute(path: '/stats', builder: (context, state) => const StatisticsScreen()),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),


        // ===================== Multiplicação =====================
        GoRoute(
          path: '/train/multiplication/select',
          builder: (context, state) => const MultiplicationOptionsSelectScreen(),
        ),
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
        // compat: ?table=7
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
            return Scaffold(
              appBar: AppBar(title: const Text('Results')),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Missing result data'),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () => context.go('/'), child: const Text('Home')),
                  ],
                ),
              ),
            );
          },
        ),

        // ===================== Adição =====================
        GoRoute(
          path: '/train/addition/options',
          builder: (context, state) => const AdditionOptionsSelectScreen(),
        ),

        // jogo oficial (via state.extra ou query)
        GoRoute(
          path: '/train/addition/game',
          builder: (context, state) {
            int parcels = 2;   // 2..5
            int level = 1;     // 1..10
            int decimals = 0;  // 0..9

            final extra = state.extra;
            if (extra is Map) {
              parcels  = (extra['parcels']  ?? extra['addends'] ?? parcels) as int;
              level    = (extra['level']    ?? level) as int;
              decimals = (extra['decimals'] ?? decimals) as int;
            } else {
              final q = state.uri.queryParameters;
              parcels  = int.tryParse(q['parcels'] ?? q['addends'] ?? '') ?? parcels;
              level    = int.tryParse(q['level'] ?? '') ?? level;
              decimals = int.tryParse(q['decimals'] ?? '') ?? decimals;
            }

            parcels  = parcels.clamp(2, 5);
            level    = level.clamp(1, 10);
            decimals = decimals.clamp(0, 9);

            return AdditionGameScreen(
              parcels: parcels,
              level: level,
              decimals: decimals,
            );
          },
        ),

        // resultado da adição (relatório)
        GoRoute(
          path: '/train/addition/result',
          builder: (context, state) {
            final extra = state.extra as Map?;
            final summary = extra?['summary'] as RoundSummary?;
            final parcels = (extra?['parcels'] as int?) ?? 2;
            final level = (extra?['level'] as int?) ?? 1;
            final decimals = (extra?['decimals'] as int?) ?? 0;

            if (summary != null) {
              return AdditionResultScreen(
                summary: summary,
                parcels: parcels,
                level: level,
                decimals: decimals,
              );
            }

            return Scaffold(
              appBar: AppBar(title: const Text('Results')),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Missing result data'),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () => context.go('/'), child: const Text('Home')),
                  ],
                ),
              ),
            );
          },
        ),

        // compat: /train/addition/play?n=..&level=..&d=..
        GoRoute(
          path: '/train/addition/play',
          builder: (context, state) {
            final q = state.uri.queryParameters;
            int parcels  = int.tryParse(q['n'] ?? q['parcels'] ?? '2') ?? 2;
            int level    = int.tryParse(q['level'] ?? '1') ?? 1;
            int decimals = int.tryParse(q['d'] ?? q['decimals'] ?? '0') ?? 0;

            parcels  = parcels.clamp(2, 5);
            level    = level.clamp(1, 10);
            decimals = decimals.clamp(0, 9);

            return AdditionGameScreen(
              parcels: parcels,
              level: level,
              decimals: decimals,
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
                Text('GoException: no routes for location: ${state.uri}', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                TextButton(onPressed: () => context.go('/'), child: const Text('Home')),
              ],
            ),
          ),
        );
      },
    );
  }
}

final GoRouter appRouter = AppRouter.makeRouter();
