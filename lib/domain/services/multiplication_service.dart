// lib/domain/services/multiplication_service.dart
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:math_lite/l10n/l10n.dart';
import '../math_question.dart';

/// Serviço que gera perguntas de multiplicação, opções de resposta,
/// controla tempo por nível e cria dicas pedagógicas (localizadas).
class MultiplicationService {
  final _rng = Random();

  // Sacola de fatores (0..10). A gente vai tirando até esvaziar.
  List<int> _factorBag = [];

  // Sacola de tabuadas possíveis quando estamos no modo "random_X_Y"
  List<int> _tableBag = [];

  // -------------------------------------------------
  // Sacolas internas
  // -------------------------------------------------
  void _refillFactorBag({int maxFactor = 10}) {
    _factorBag = List<int>.generate(maxFactor + 1, (i) => i);
    _factorBag.shuffle(_rng);
  }

  int _nextFactor({int maxFactor = 10}) {
    if (_factorBag.isEmpty) {
      _refillFactorBag(maxFactor: maxFactor);
    }
    return _factorBag.removeLast();
  }

  void _refillTableBag(int minBase, int maxBase) {
    _tableBag = [for (int n = minBase; n <= maxBase; n++) n];
    _tableBag.shuffle(_rng);
  }

  int pickRandomTable({required int minBase, required int maxBase}) {
    if (_tableBag.isEmpty) {
      _refillTableBag(minBase, maxBase);
    }
    return _tableBag.removeLast();
  }

  // -------------------------------------------------
  // Geração da pergunta da rodada
  // -------------------------------------------------
  MathQuestion generateQuestion({
    required int table,
    int maxFactor = 10,
  }) {
    final int a = _nextFactor(maxFactor: maxFactor); // ex: 0..10
    final int b = table;
    final int correct = a * b;

    final options = _makeOptions(correct);
    final questionText = "$a × $b = ?";

    return MathQuestion(
      a: a,
      b: b,
      correctAnswer: correct,
      options: options,
      questionText: questionText,
    );
  }

  List<int> generateOptionsFor(int correct) => _makeOptions(correct);

  List<int> _makeOptions(int correct) {
    final answers = <int>{correct};
    final deltas = [1, -1, 2, -2, 3, -3, 5, -5, 10, -10];

    for (final d in deltas) {
      if (answers.length >= 4) break;
      final candidate = correct + d;
      if (candidate >= 0) answers.add(candidate);
    }

    while (answers.length < 4) {
      final noise = correct + _rng.nextInt(11) - 5; // +/-5
      if (noise >= 0) answers.add(noise);
    }

    final list = answers.toList()..shuffle(_rng);
    return list;
  }

  // -------------------------------------------------
  // Tempo por nível de dificuldade
  // -------------------------------------------------
  int secondsForDifficulty(int level) {
    final map = <int, int>{
      1: 20,
      2: 18,
      3: 16,
      4: 15,
      5: 12,
      6: 10,
      7: 7,
      8: 5,
      9: 3,
      10: 2,
    };
    if (level < 1) level = 1;
    if (level > 10) level = 10;
    return map[level]!;
  }

  // -------------------------------------------------
  // Dica pedagógica (LOCALIZADA)
  // -------------------------------------------------
  /// Agora recebe [BuildContext] para usar `context.l10n`.
  String buildHint(BuildContext context, MathQuestion q) {
    final l10n = context.l10n;
    final a = q.a;
    final b = q.b;
    final result = q.correctAnswer;

    // vamos usar (menor, maior) para a soma repetida
    final bigger = (a >= b) ? a : b;
    final smaller = (a >= b) ? b : a;

    final buf = StringBuffer();

    // Linha de abertura (apresenta a conta)
    buf.writeln("$a × $b = $result\n");

    // 1) Soma repetida
    buf.writeln(l10n.howto_repeat_addition);
    buf.writeln(l10n.howto_repeat_addition_explain_fmt(a, b));

    // Caso especial: multiplicação por ZERO
    if (a == 0 || b == 0) {
      final times = a == 0 ? b : a;
      // Mostrar 0 + 0 + ... = 0 (neutro em idioma)
      if (times > 0) {
        buf.writeln(List.filled(times, "0").join(" + ") + " = 0");
      } else {
        buf.writeln("0 = 0");
      }

      buf.writeln("\n${l10n.mult_tips_title}");
      buf.writeln("• ${l10n.tip_zero_property}");
      buf.writeln("\n${l10n.summary_label}: $a × $b = $result.");
      return buf.toString();
    }

    // Passo a passo com soma repetida (neutro com números)
    if (bigger >= 2) {
      final p2 = smaller * 2;
      final p3 = smaller * 3;
      buf.writeln("\n${l10n.howto_step_by_step}");
      buf.writeln("$smaller + $smaller = $p2");
      buf.writeln("$p2 + $smaller = $p3 ...");
      buf.writeln(l10n.howto_step_continue_fmt(result));
    }

    // 2) Truque do 9: 9×n = 10×n − n
    if (a == 9 || b == 9) {
      final n = (a == 9) ? b : a;
      final tenTimes = n * 10;
      final minusOther = tenTimes - n;
      buf.writeln("\n${l10n.howto_nine_trick_title}");
      buf.writeln(l10n.howto_nine_trick_explain_fmt(n, tenTimes, minusOther));
    }

    // 3) Dobrar ajuda
    if (a % 2 == 0) {
      final half = a ~/ 2;
      final halfTimesB = half * b;
      final doubled = halfTimesB * 2;
      if (doubled == result && half > 0) {
        buf.writeln("\n${l10n.howto_doubling_helps}");
        buf.writeln("$a × $b = ($half × $b) × 2 = $halfTimesB × 2 = $doubled");
      }
    } else if (b % 2 == 0) {
      final half = b ~/ 2;
      final halfTimesA = half * a;
      final doubled = halfTimesA * 2;
      if (doubled == result && half > 0) {
        buf.writeln("\n${l10n.howto_doubling_helps}");
        buf.writeln("$a × $b = ($a × $half) × 2 = $halfTimesA × 2 = $doubled");
      }
    }

    // 4) Dicas por tabuada
    buf.writeln("\n${l10n.mult_tips_title}");

    // Propriedade do 1
    if (a == 1 || b == 1) {
      buf.writeln("• ${l10n.tip_one_property}");
    }

    // 2
    if (a == 2 || b == 2) {
      final other = (a == 2) ? b : a;
      buf.writeln("• ${l10n.tip_table_2_fmt(other)}");
    }

    // 3
    if (a == 3 || b == 3) {
      buf.writeln("• ${l10n.tip_table_3}");
    }

    // 4
    if (a == 4 || b == 4) {
      buf.writeln("• ${l10n.tip_table_4}");
    }

    // 5
    if (a == 5 || b == 5) {
      buf.writeln("• ${l10n.tip_table_5}");
    }

    // 6
    if (a == 6 || b == 6) {
      final other = (a == 6) ? b : a;
      buf.writeln("• ${l10n.tip_table_6_fmt(other)}");
    }

    // 7
    if (a == 7 || b == 7) {
      final other = (a == 7) ? b : a;
      buf.writeln("• ${l10n.tip_table_7_fmt(other)}");
    }

    // 8
    if (a == 8 || b == 8) {
      final other = (a == 8) ? b : a;
      buf.writeln("• ${l10n.tip_table_8_fmt(other)}");
    }

    // 9 (nota adicional)
    if (a == 9 || b == 9) {
      buf.writeln("• ${l10n.tip_table_9_note}");
    }

    // 10
    if (a == 10 || b == 10) {
      final other = (a == 10) ? b : a;
      buf.writeln("• ${l10n.tip_table_10_fmt(other)}");
    }

    buf.writeln("\n${l10n.summary_label}: $a × $b = $result.");
    return buf.toString();
  }
}
