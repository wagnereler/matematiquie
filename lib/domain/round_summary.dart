// lib/domain/round_summary.dart
import 'package:equatable/equatable.dart';
import 'round_attempt.dart';

class RoundSummary extends Equatable {
  final List<RoundAttempt> attempts;

  const RoundSummary({required this.attempts});

  int get total => attempts.length;

  int get correct => attempts.where((a) => a.isCorrect).length;

  @override
  List<Object?> get props => [attempts];
}
