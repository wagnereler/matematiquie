// lib/domain/services/multiplication_service.dart
import 'dart:math';
import '../math_question.dart';

/// Serviço que gera perguntas de multiplicação, opções de resposta,
/// controla tempo por nível e cria dicas pedagógicas.
///
/// Extras importantes:
/// - "sacola" (bag) embaralhada de fatores 0..10 para evitar repetir
///   sempre os mesmos números de imediato.
/// - sacola para escolher tabuadas aleatórias dentro de um intervalo
///   (ex: entre 2 e 10) sem repetir até esgotar.
/// - gera dicas explicando o raciocínio.
/// - mapa de tempos por nível de dificuldade.
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
    // removeLast() é ligeiramente mais eficiente que removeAt(0)
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

  /// Gera uma questão de multiplicação:
  ///   a × table = ?
  ///
  /// Retorna também 4 opções de múltipla escolha (1 correta + 3 distrações).
  ///
  /// OBS:
  /// - "a" vem da sacola embaralhada 0..10 pra não repetir sempre o mesmo.
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

  /// Versão pública para gerar opções dado o resultado correto.
  /// Isso é usado no modo "erros", onde a gente monta manualmente a pergunta
  /// com (a × b) específico e depois só precisa das alternativas plausíveis.
  List<int> generateOptionsFor(int correct) {
    return _makeOptions(correct);
  }

  /// Gera 3 respostas erradas que sejam:
  /// - diferentes da certa
  /// - próximas / "plausíveis", não números absurdos
  /// Depois mistura tudo e devolve uma lista de 4 números.
  List<int> _makeOptions(int correct) {
    final answers = <int>{};
    answers.add(correct);

    // Distratores próximos: +1, -1, +2, -2, +3, -3, ...
    // Isso ajuda a forçar o cálculo mental em vez de puro chute aleatório.
    final deltas = [1, -1, 2, -2, 3, -3, 5, -5, 10, -10];

    for (final d in deltas) {
      if (answers.length >= 4) break;
      final candidate = correct + d;
      if (candidate >= 0) {
        answers.add(candidate);
      }
    }

    // Garantia de ter 4 opções.
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
  // Tempo por nível de dificuldade
  // -------------------------------------------------
  //
  // Escala acordada:
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
  // Se chegar algo fora desse range, fazemos clamp em [1..10].
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
  // A ideia da dica é ensinar "como pensar" a multiplicação,
  // não só dar a resposta pronta.
  //
  // Estratégias:
  //  - soma repetida
  //  - decomposição tipo 9×n = 10×n − n
  //  - dobrar e somar (ex: 8×6 = (4×6)×2)
  //  - truques por tabuada (2,5,10 etc.)
  //
  // OBS: Essa string vai inteira pro bottom sheet.
  String buildHint(MathQuestion q) {
    final a = q.a;
    final b = q.b;
    final result = q.correctAnswer;

    // vamos trabalhar com "maior" e "menor" só pra montar exemplos de soma repetida bonitinhos
    final bigger = (a >= b) ? a : b;
    final smaller = (a >= b) ? b : a;

    final buf = StringBuffer();

    buf.writeln("$a × $b = $result");
    buf.writeln("");

    // 1) soma repetida
    buf.writeln("💡 Pense como soma repetida:");
    buf.writeln(
        "$a × $b quer dizer somar $b um total de $a vezes (ou somar $a um total de $b vezes).");

    // Mostramos alguns passos de soma acumulada usando 'smaller' repetido.
    if (bigger >= 2) {
      final partial1 = smaller;
      final partial2 = smaller * 2;
      final partial3 = smaller * 3;
      buf.writeln(
          "\nExemplo de construção passo a passo:\n"
          "$smaller + $smaller = $partial2\n"
          "$partial2 + $smaller = $partial3 ...\n"
          "continuando assim chegamos em $result.");
    }

    // 2) truque da tabuada do 9: 9 × n = (10 × n) − n
    if (a == 9 || b == 9) {
      final other = (a == 9) ? b : a;
      final tenTimes = other * 10;
      final minusOther = tenTimes - other;
      buf.writeln(
          "\n💡 Truque da tabuada do 9:\n"
          "9 × $other = (10 × $other) − $other = $tenTimes − $other = $minusOther");
    }

    // 3) dobrar e somar (bom pra múltiplos pares, tipo 8×6 = (4×6)×2)
    if (a % 2 == 0) {
      final half = a ~/ 2;
      final halfTimesB = half * b;
      final doubled = halfTimesB * 2;
      if (doubled == result && half > 0) {
        buf.writeln(
            "\n💡 Dobrar ajuda:\n"
            "$a × $b = ($half × $b) × 2 = $halfTimesB × 2 = $doubled");
      }
    } else if (b % 2 == 0) {
      final half = b ~/ 2;
      final halfTimesA = half * a;
      final doubled = halfTimesA * 2;
      if (doubled == result && half > 0) {
        buf.writeln(
            "\n💡 Dobrar ajuda:\n"
            "$a × $b = ($a × $half) × 2 = $halfTimesA × 2 = $doubled");
      }
    }

    // 4) macetes específicos por tabuada
    buf.writeln("\n📚 Dicas da tabuada:");

    // tabuada do 1
    if (a == 1 || b == 1) {
      buf.writeln(
          "• Tabuada do 1: qualquer número vezes 1 é ele mesmo. Ex: 1 × $b = $b.");
    }

    // tabuada do 2
    if (a == 2 || b == 2) {
      final other = (a == 2) ? b : a;
      buf.writeln(
          "• Tabuada do 2: é só dobrar. Ex: 2 × $other = $other + $other.");
    }

    // tabuada do 3
    if (a == 3 || b == 3) {
      buf.writeln(
          "• Tabuada do 3: pense em somar de 3 em 3: 3, 6, 9, 12, 15, 18...");
    }

    // tabuada do 4
    if (a == 4 || b == 4) {
      buf.writeln(
          "• Tabuada do 4: dobre duas vezes. Ex: 4 × n = (2 × n) × 2.");
    }

    // tabuada do 5
    if (a == 5 || b == 5) {
      buf.writeln(
          "• Tabuada do 5: termina em 0 ou 5. Se o outro número é par, termina em 0. Se é ímpar, termina em 5.");
    }

    // tabuada do 6
    if (a == 6 || b == 6) {
      final other = (a == 6) ? b : a;
      buf.writeln(
          "• Tabuada do 6: pense 5 × $other + $other. "
          "Ex: 6 × $other = (5 × $other) + $other.");
    }

    // tabuada do 7
    if (a == 7 || b == 7) {
      final other = (a == 7) ? b : a;
      buf.writeln(
          "• Tabuada do 7: pense 5 × $other + 2 × $other. "
          "Ex: 7 × $other = (5 × $other) + (2 × $other).");
    }

    // tabuada do 8
    if (a == 8 || b == 8) {
      final other = (a == 8) ? b : a;
      buf.writeln(
          "• Tabuada do 8: é o dobro do dobro do dobro. "
          "Ex: 8 × $other = (4 × $other) × 2 = (2 × $other) × 4.");
    }

    // tabuada do 9 já cobrimos acima, mas reforça:
    if (a == 9 || b == 9) {
      buf.writeln(
          "• Tabuada do 9: soma dos dígitos do resultado costuma dar 9. "
          "Ex: 9 × 4 = 36 → 3 + 6 = 9.");
    }

    // tabuada do 10
    if (a == 10 || b == 10) {
      final other = (a == 10) ? b : a;
      buf.writeln(
          "• Tabuada do 10: só colocar um zero no final. "
          "Ex: 10 × $other = ${other}0.");
    }

    buf.writeln("\nResumo: $a × $b = $result.");

    return buf.toString();
  }
}
