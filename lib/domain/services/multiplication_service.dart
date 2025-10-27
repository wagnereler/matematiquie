// lib/domain/services/multiplication_service.dart
import 'dart:math';
import '../math_question.dart';

/// Serviço que gera perguntas de multiplicação, opções de resposta,
/// controle de tempo por nível e dicas pedagógicas.
///
/// NOVO:
/// - Usa "sacola" (bag) embaralhada de fatores 0..10 para evitar repetir sempre
///   os mesmos números de imediato.
/// - Usa outra sacola para as tabuadas quando o modo é aleatório (ex: 2..10).
class MultiplicationService {
  final _rng = Random();

  // Sacola de fatores (0..10). A gente vai tirando até esvaziar.
  List<int> _factorBag = [];

  // Sacola de tabuadas possíveis quando estamos no modo "random_X_Y"
  // (por exemplo, tabuadas 2..10). Só é usada se o jogo pediu tabuada aleatória.
  List<int> _tableBag = [];

  // -------------------------------------------------
  // Sacolas internas
  // -------------------------------------------------

  /// Recarrega a sacola de fatores com [0, 1, 2, ..., maxFactor] e embaralha.
  void _refillFactorBag({int maxFactor = 10}) {
    _factorBag = List<int>.generate(maxFactor + 1, (i) => i);
    _factorBag.shuffle(_rng);
  }

  /// Pega o próximo fator da sacola (ex: 0..10).
  /// Se esvaziou, reabastece antes.
  int _nextFactor({int maxFactor = 10}) {
    if (_factorBag.isEmpty) {
      _refillFactorBag(maxFactor: maxFactor);
    }
    // removeLast() é ligeiramente mais rápido que removeAt(0)
    return _factorBag.removeLast();
  }

  /// Recarrega a sacola de tabuadas possíveis (ex: 2..10) e embaralha.
  void _refillTableBag(int minBase, int maxBase) {
    _tableBag = [
      for (int n = minBase; n <= maxBase; n++) n,
    ];
    _tableBag.shuffle(_rng);
  }

  /// Escolhe qual tabuada usar AGORA no modo aleatório.
  /// Usa a sacola das tabuadas pra não repetir a mesma tabuada em sequência
  /// até esgotar todas dentro do range.
  int pickRandomTable({required int minBase, required int maxBase}) {
    if (_tableBag.isEmpty) {
      _refillTableBag(minBase, maxBase);
    }
    return _tableBag.removeLast();
  }

  // -------------------------------------------------
  // Geração da pergunta da rodada
  // -------------------------------------------------

  /// Gera uma questão de multiplicação do tipo:
  ///   a × table = ?
  ///
  /// Retorna também 4 opções de múltipla escolha:
  ///   - 1 correta
  ///   - 3 distratores plausíveis
  ///
  /// IMPORTANTE:
  ///  - agora o fator "a" vem da sacola embaralhada 0..10
  ///    pra evitar repetição imediata
  MathQuestion generateQuestion({
    required int table,
    int maxFactor = 10,
  }) {
    final int a = _nextFactor(maxFactor: maxFactor); // ex: 0..10
    final int b = table;
    final int correct = a * b;

    // Gera distratores exclusivos
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

  /// Gera 3 respostas erradas que sejam:
  /// - diferentes da certa
  /// - próximas / "plausíveis", não números absurdos
  /// Depois mistura tudo e devolve uma lista de 4 números.
  List<int> _makeOptions(int correct) {
    final answers = <int>{};
    answers.add(correct);

    // Tentamos criar distratores próximos: +1, -1, +2, -2, +3, -3, etc.
    // Isso ajuda a treinar atenção e cálculo mental.
    final deltas = [1, -1, 2, -2, 3, -3, 5, -5, 10, -10];

    for (final d in deltas) {
      if (answers.length >= 4) break;
      final candidate = correct + d;
      if (candidate >= 0) {
        answers.add(candidate);
      }
    }

    // Se ainda não temos 4 opções, cria aleatórios de forma segura.
    while (answers.length < 4) {
      final noise = correct + _rng.nextInt(11) - 5; // +/-5
      if (noise >= 0) {
        answers.add(noise);
      }
    }

    final list = answers.toList();
    list.shuffle(_rng);
    return list;
  }

  // -------------------------------------------------
  // Tempo por nível
  // -------------------------------------------------
  //
  // Escala que combinamos:
  // base = 20
  // nível 1 = 20
  // nível 2 = 18
  // nível 3 = 16
  // nível 4 = 15
  // nível 5 = 12
  // nível 6 = 10
  // nível 7 = 7
  // nível 8 = 5
  // nível 9 = 3
  // nível 10 = 2
  //
  // Se receber algo fora (ex: 0 ou 99), a gente faz clamp.
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
  // Dica pedagógica
  // -------------------------------------------------
  //
  // Mostramos estratégias que ajudam a criança a construir o resultado,
  // não só decorar. Exemplos:
  //  - soma repetida
  //  - decomposição usando 10×n - n para a tabuada do 9
  //  - dobrar e somar (por exemplo 6×4 = (3×4)×2)
  //
  // A tela do jogo chama isso tanto quando erra,
  // quanto quando o jogador aperta o botão de dica (💡).
  String buildHint(MathQuestion q) {
    final a = q.a;
    final b = q.b;
    final result = q.correctAnswer;

    final bigger = (a >= b) ? a : b;
    final smaller = (a >= b) ? b : a;

    final buffer = StringBuffer();

    buffer.writeln("$a × $b = $result");

    // 1) Soma repetida / contagem em blocos
    // Exemplo:
    //   6 × 4
    //   Pense como 4 + 4 + 4 + 4 + 4 + 4
    buffer.writeln("");
    buffer.writeln("💡 Pense como soma repetida:");
    buffer.writeln(
        "$a × $b quer dizer somar $b um total de $a vezes (ou somar $a um total de $b vezes).");

    // Mostra uma sequência curta de somas acumuladas
    // Vamos sempre usar "smaller" repetido bigger vezes, porque é mais curtinho.
    // Ex: 4 × 6 -> repetir '4' seis vezes é mais curto? na verdade é o contrário...
    // vamos montar sempre "smaller somado bigger vezes" mas só até 3 passos pra não poluir.
    final partial1 = smaller;
    final partial2 = smaller * 2;
    final partial3 = smaller * 3;
    buffer.writeln(
        "$smaller + $smaller = $partial2\n$partial2 + $smaller = $partial3 ...");
    buffer.writeln("continuando assim chegamos em $result.");

    // 2) Truque do 10×n - n para o 9
    // Se um dos fatores é 9, usamos:
    //   9 × x = (10 × x) − x
    if (a == 9 || b == 9) {
      final other = (a == 9) ? b : a;
      final tenTimes = other * 10;
      final minusOther = tenTimes - other;
      buffer.writeln("");
      buffer.writeln("💡 Truque da tabuada do 9:");
      buffer.writeln(
          "9 × $other = (10 × $other) − $other = $tenTimes − $other = $minusOther");
    }

    // 3) Dobrar e somar (bom pra múltiplos de 4, 6, 8...)
    // Exemplo: 6 × 4 = (3 × 4) × 2
    // ou 8 × 7 = (4 × 7) × 2
    if (a % 2 == 0) {
      final half = a ~/ 2;
      final halfTimesB = half * b;
      final doubled = halfTimesB * 2;
      if (doubled == result && half > 0) {
        buffer.writeln("");
        buffer.writeln("💡 Dobrar ajuda:");
        buffer.writeln(
            "$a × $b = ($half × $b) × 2 = $halfTimesB × 2 = $doubled");
      }
    } else if (b % 2 == 0) {
      final half = b ~/ 2;
      final halfTimesA = half * a;
      final doubled = halfTimesA * 2;
      if (doubled == result && half > 0) {
        buffer.writeln("");
        buffer.writeln("💡 Dobrar ajuda:");
        buffer.writeln(
            "$a × $b = ($a × $half) × 2 = $halfTimesA × 2 = $doubled");
      }
    }

    buffer.writeln("");
    buffer.writeln("Resumo: $a × $b = $result.");

    return buffer.toString();
  }
}
