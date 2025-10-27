// /lib/domain/generator.dart
import 'dart:math';
import 'entities.dart';

class QuestionGenerator {
  final Random _rng = Random();

  Question makeAdd(List<int> targets, int maxB) {
    final a = targets.isEmpty ? _rng.nextInt(maxB + 1) : targets[_rng.nextInt(targets.length)];
    final b = _rng.nextInt(maxB + 1);
    final correct = a + b;
    final opts = _distractors(correct, minV: 0, maxV: a + maxB);
    return Question(
      mode: GameMode.add,
      a: a,
      b: b,
      result: correct,
      unknownIsLeft: false,
      options: opts,
      correct: correct,
    );
  }

  Question makeSub(List<int> targets, int maxB) {
    final a = targets.isEmpty ? _rng.nextInt(maxB + 1) : targets[_rng.nextInt(targets.length)];
    final b = _rng.nextInt(maxB + 1);
    // queremos a - b ou b - a? fixo: a − b, garantindo não-negativo
    final big = max(a, b);
    final small = min(a, b);
    final correct = big - small;
    final opts = _distractors(correct, minV: 0, maxV: maxB);
    return Question(
      mode: GameMode.sub,
      a: big,
      b: small,
      result: correct,
      unknownIsLeft: false,
      options: opts,
      correct: correct,
    );
  }

  Question makeMul(int? table, int maxA) {
    final b = table ?? (1 + _rng.nextInt(10)); // tabuadas 1..10
    final a = 1 + _rng.nextInt(max(1, maxA));
    final correct = a * b;
    final opts = _distractors(correct, neighbors: [b, a]);
    return Question(
      mode: GameMode.mul,
      a: a,
      b: b,
      result: correct,
      unknownIsLeft: false,
      options: opts,
      correct: correct,
    );
  }

  /// Divisão no seu formato: "? × b = result"
  Question makeDiv(int? table, int maxA) {
    final b = table ?? (1 + _rng.nextInt(10));
    final a = 1 + _rng.nextInt(max(1, maxA)); // fator correto
    final result = a * b;
    final correct = a;
    final opts = _distractors(correct, minV: 1, maxV: max(10, maxA + 2));
    return Question(
      mode: GameMode.div,
      a: a,
      b: b,
      result: result,
      unknownIsLeft: true,
      options: opts,
      correct: correct,
    );
  }

  /// Gera 3 distrações + 1 correta, embaralhadas, sem duplicatas.
  List<int> _distractors(int correct, {int minV = 0, int maxV = 100, List<int> neighbors = const []}) {
    final set = <int>{correct};
    // tenta vizinhos próximos
    for (final delta in [-2, -1, 1, 2, 3, -3]) {
      if (set.length >= 4) break;
      final v = correct + delta;
      if (v >= minV && v <= maxV) set.add(v);
    }
    // se faltou, adiciona aleatórios
    final rnd = Random();
    while (set.length < 4) {
      final v = minV + rnd.nextInt(max(1, maxV - minV + 1));
      set.add(v);
    }
    final list = set.toList()..shuffle();
    return list;
  }
}
