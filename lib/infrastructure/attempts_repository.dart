// lib/infrastructure/attempts_repository.dart
import '../domain/attempts_repository.dart';
import 'db/app_database.dart';

/// Wrapper de compatibilidade.
/// Algumas partes antigas do app (ou Providers em main.dart)
/// podem ainda querer instanciar AttemptsRepositoryDrift.
/// Agora ele só herda a implementação real AttemptsRepository.
class AttemptsRepositoryDrift extends AttemptsRepository {
  AttemptsRepositoryDrift(AppDatabase db) : super(db);
}
