// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart'; // gerado pelo gen-l10n
import 'l10n/l10n.dart';
import 'routes/app_router.dart';

// infra/domínio
import 'domain/attempts_repository.dart';
import 'infrastructure/players_repository.dart';
import 'infrastructure/db/app_database.dart';
import 'infrastructure/attempts_repository.dart' as attempts_impl;
import 'infrastructure/profile_prefs.dart';
import 'application/players_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final profilePrefs = ProfilePrefs(prefs);

  final db = AppDatabase();

  final AttemptsRepository attemptsRepo =
      attempts_impl.AttemptsRepositoryDrift(db);
  final playersRepo = PlayersRepository(db);

  final GoRouter router = AppRouter.makeRouter();

  runApp(MatematiqueiApp(
    attemptsRepo: attemptsRepo,
    playersRepo: playersRepo,
    profilePrefs: profilePrefs,
    router: router,
    db: db, // ⬅️ passa o DB para o widget raiz
  ));
}

class MatematiqueiApp extends StatelessWidget {
  const MatematiqueiApp({
    super.key,
    required this.attemptsRepo,
    required this.playersRepo,
    required this.profilePrefs,
    required this.router,
    required this.db,
  });

  final AttemptsRepository attemptsRepo;
  final PlayersRepository playersRepo;
  final ProfilePrefs profilePrefs;
  final GoRouter router;
  final AppDatabase db;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // ⬇️ disponibiliza o DB no contexto (usado pela StatisticsScreen)
        RepositoryProvider<AppDatabase>.value(value: db),

        RepositoryProvider<AttemptsRepository>.value(value: attemptsRepo),
        RepositoryProvider<PlayersRepository>.value(value: playersRepo),
        RepositoryProvider<ProfilePrefs>.value(value: profilePrefs),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PlayersCubit>(
            create: (_) => PlayersCubit(
              repo: playersRepo,
              prefs: profilePrefs,
            )..load(),
          ),
        ],
        child: Builder(
          builder: (context) {
            final locale = context.select((PlayersCubit c) => c.uiLocale);

            return MaterialApp.router(
              debugShowCheckedModeBanner: false,

              // título via i18n
              onGenerateTitle: (ctx) => AppLocalizations.of(ctx)!.appTitle,

              // delegados e locales do gerado
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,

              // idioma escolhido pelo jogador
              locale: locale,

              // rotas
              routerConfig: router,

              // tema
              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                colorSchemeSeed: Colors.indigo,
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                colorSchemeSeed: Colors.indigo,
              ),
              themeMode: ThemeMode.system,
            );
          },
        ),
      ),
    );
  }
}
