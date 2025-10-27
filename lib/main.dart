// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/screens/home_screen.dart';
import 'presentation/screens/play_screen.dart';
import 'presentation/screens/player_select_screen.dart';
import 'presentation/screens/multiplication_table_select_screen.dart';
import 'presentation/screens/multiplication_game_screen.dart';
import 'presentation/screens/multiplication_result_screen.dart';
import 'presentation/screens/statistics_screen.dart';

import 'application/players_cubit.dart';
import 'infrastructure/db/app_database.dart';
import 'infrastructure/players_repository.dart';
import 'infrastructure/attempts_repository.dart';
import 'infrastructure/profile_prefs.dart';
import 'domain/attempts_repository.dart';
import 'domain/round_summary.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();

  final sp = await SharedPreferences.getInstance();
  final profilePrefs = ProfilePrefs(sp);

  final playersRepo = PlayersRepository(db);
  final attemptsRepo = AttemptsRepositoryDrift(db);

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/play',
        builder: (_, __) => const PlayScreen(),
      ),
      GoRoute(
        path: '/players',
        builder: (_, __) => const PlayerSelectScreen(),
      ),
      GoRoute(
        path: '/stats',
        builder: (_, __) => const StatisticsScreen(),
      ),
      GoRoute(
        path: '/train/multiplication/select',
        builder: (_, __) => const MultiplicationTableSelectScreen(),
      ),
      GoRoute(
        path: '/train/multiplication/play/:table',
        builder: (context, state) {
          final tableParam = state.pathParameters['table']!;
          return MultiplicationGameScreen(tableParam: tableParam);
        },
      ),
      GoRoute(
        path: '/train/multiplication/result',
        builder: (context, state) {
          // Agora 'extra' é um Map { 'summary': RoundSummary, 'replayParam': String }
          final extra = state.extra as Map<String, Object?>;
          final summary = extra['summary'] as RoundSummary;
          final replayParam = extra['replayParam'] as String;
          return MultiplicationResultScreen(
            summary: summary,
            replayParam: replayParam,
          );
        },
      ),
    ],
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        // disponibiliza o banco para quem precisar (ex: StatisticsScreen)
        RepositoryProvider<AppDatabase>.value(value: db),

        // repos de domínio
        RepositoryProvider<PlayersRepository>.value(value: playersRepo),
        RepositoryProvider<AttemptsRepository>.value(value: attemptsRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PlayersCubit>(
            create: (ctx) => PlayersCubit(
              repo: ctx.read<PlayersRepository>(),
              prefs: profilePrefs,
            )..load(),
          ),
        ],
        child: MatematiqueiApp(router: router),
      ),
    ),
  );
}

class MatematiqueiApp extends StatelessWidget {
  final GoRouter router;
  const MatematiqueiApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        scaffoldBackgroundColor: const Color(0xFFFFFBE6),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            color: Colors.black87,
          ),
          labelLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade100,
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
