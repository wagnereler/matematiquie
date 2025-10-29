// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application/players_cubit.dart';

import 'infrastructure/db/app_database.dart';
import 'infrastructure/players_repository.dart';
import 'infrastructure/attempts_repository.dart';
import 'infrastructure/profile_prefs.dart';

import 'domain/attempts_repository.dart';
import 'domain/round_summary.dart';

import 'presentation/screens/home_screen.dart';
import 'presentation/screens/player_select_screen.dart';
import 'presentation/screens/multiplication_table_select_screen.dart';
import 'presentation/screens/multiplication_game_screen.dart';
import 'presentation/screens/multiplication_result_screen.dart';
import 'presentation/screens/statistics_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // banco local (Drift)
  final db = AppDatabase();

  // shared prefs -> ProfilePrefs
  final sp = await SharedPreferences.getInstance();
  final profilePrefs = ProfilePrefs(sp);

  // repositórios
  final playersRepo = PlayersRepository(db);
  final attemptsRepo = AttemptsRepositoryDrift(db);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDatabase>.value(value: db),
        RepositoryProvider<PlayersRepository>.value(value: playersRepo),
        RepositoryProvider<AttemptsRepository>.value(value: attemptsRepo),
        RepositoryProvider<ProfilePrefs>.value(value: profilePrefs),
      ],
      child: BlocProvider<PlayersCubit>(
        create: (_) => PlayersCubit(
          repo: playersRepo,
          prefs: profilePrefs,
        )..load(),
        child: MatematiqueiApp(),
      ),
    ),
  );
}

class MatematiqueiApp extends StatelessWidget {
  MatematiqueiApp({super.key});

  // Criamos o router aqui dentro pra ter acesso a context depois via builder.
  late final GoRouter _router = GoRouter(
    routes: [
      // HOME
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),

      // GERENCIAR JOGADORES
      GoRoute(
        path: '/players',
        builder: (context, state) => const PlayerSelectScreen(),
      ),
      // ESCOLHER TIPO DE TREINO
      GoRoute(
        path: '/play',
        builder: (context, state) => const PlayScreen(),
      ),
      

      // TELA DE ESCOLHA DA TABUADA
      GoRoute(
        path: '/train/multiplication/select',
        builder: (context, state) {
          // ATENÇÃO: não passamos mais attemptsRepo aqui
          return const MultiplicationTableSelectScreen();
        },
      ),




      GoRoute(
        path: '/train/multiplication/play',
        builder: (context, state) {
          final tableParam =
              state.uri.queryParameters['table'] ?? '2';

          final attemptsRepo = context.read<AttemptsRepository>();

          return MultiplicationGameScreen(
            tableParam: tableParam,
            attemptsRepo: attemptsRepo,
          );
        },
      ),

      // RESULTADO DA RODADA
      //
      // a game screen faz:
      //   context.go(
      //     '/train/multiplication/result',
      //     extra: {
      //       'summary': summary,
      //       'replayParam': _replayParam,
      //     },
      //   );
      //
      GoRoute(
        path: '/train/multiplication/result',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          final summary =
              extra?['summary'] as RoundSummary? ??
                  const RoundSummary(attempts: []);

          final replayParam =
              extra?['replayParam'] as String? ?? '2';

          return MultiplicationResultScreen(
            summary: summary,
            replayParam: replayParam,
          );
        },
      ),

      // ESTATÍSTICAS
      GoRoute(
        path: '/stats',
        builder: (context, state) {
          // StatisticsScreen agora lê AttemptsRepository do context,
          // então NÃO passamos mais attemptsRepo aqui.
          return const StatisticsScreen();
        },
      ),
    ],

    // rota de erro genérica
    errorBuilder: (context, state) {
      return _PageNotFoundScreen(
        message: state.error.toString(),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Matematiquei',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFEF9E8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.light,
          background: const Color(0xFFFEF9E8),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.amber.shade700,
          foregroundColor: Colors.black,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade600,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}

/// Telinha simples pro caso de rota inválida
class _PageNotFoundScreen extends StatelessWidget {
  final String message;
  const _PageNotFoundScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF9E8),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Página não encontrada",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // volta pro início
                    context.go('/');
                  },
                  child: const Text("Ir para início"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
