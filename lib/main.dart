// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'infrastructure/db/app_database.dart';
import 'infrastructure/profile_prefs.dart';
import 'infrastructure/players_repository.dart';
import 'infrastructure/attempts_repository.dart';
import 'domain/attempts_repository.dart';
import 'application/players_cubit.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // infra básica
  final db = AppDatabase();
  final sp = await SharedPreferences.getInstance();
  final profilePrefs = ProfilePrefs(sp);

  // repos
  final playersRepo = PlayersRepository(db);
  final attemptsRepo = AttemptsRepositoryDrift(db);

  runApp(MyApp(
    playersRepo: playersRepo,
    attemptsRepo: attemptsRepo,
    profilePrefs: profilePrefs,
  ));
}

class MyApp extends StatelessWidget {
  final PlayersRepository playersRepo;
  final AttemptsRepository attemptsRepo;
  final ProfilePrefs profilePrefs;

  const MyApp({
    super.key,
    required this.playersRepo,
    required this.attemptsRepo,
    required this.profilePrefs,
  });

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.makeRouter();

    return MultiRepositoryProvider(
      providers: [
        // Disponibiliza o repo de tentativas pelo tipo abstrato
        RepositoryProvider<AttemptsRepository>.value(value: attemptsRepo),
        RepositoryProvider<PlayersRepository>.value(value: playersRepo),
        RepositoryProvider<ProfilePrefs>.value(value: profilePrefs),
      ],
      child: MultiBlocProvider(
        providers: [
          // PlayersCubit com load() para popular lista/ativo
          BlocProvider<PlayersCubit>(
            create: (_) => PlayersCubit(repo: playersRepo, prefs: profilePrefs)..load(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Matematiquei',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.amber,
            scaffoldBackgroundColor: const Color(0xFFFFF8E6),
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
