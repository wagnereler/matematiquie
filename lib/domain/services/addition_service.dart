// lib/domain/services/addition_service.dart
import 'dart:math';

/// Representa um problema de adição "em colunas".
/// Os termos (addends) são inteiros possivelmente **escalados** por 10^decimalPlaces
/// quando há casas decimais. Ex.: com 2 casas, 123,45 é representado por 12345.
class AdditionProblem {
  AdditionProblem({
    required this.addends,
    required this.decimalPlaces,
  })  : total = addends.fold<int>(0, (a, b) => a + b),
        maxCols = _calcMaxCols(addends) {
    // Calcula dígitos esperados por coluna (direita→esquerda) e o carry de entrada.
    carriesIn = List.filled(maxCols, 0);
    expectedDigits = List.filled(maxCols, 0);

    int carry = 0;
    for (int col = 0; col < maxCols; col++) {
      int columnSum = carry;
      for (final n in addends) {
        columnSum += _digitAt(n, col);
      }
      expectedDigits[col] = columnSum % 10;
      carry = columnSum ~/ 10;
      if (col + 1 < maxCols) carriesIn[col + 1] = carry;
    }

    // Sobra final? Acrescenta colunas extras.
    final leftover = carry;
    if (leftover > 0) {
      final extra = leftover
          .toString()
          .split('')
          .reversed
          .map(int.parse)
          .toList();
      expectedDigits.addAll(extra);
      carriesIn.addAll(List.filled(extra.length, 0));
    }
  }

  final List<int> addends;              // inteiros (escalados se houver decimais)
  final int decimalPlaces;              // 0 ou 2 conforme as novas regras
  final int total;                      // soma inteira (escalada)
  final int maxCols;                    // colunas mínimas para representar os termos
  late final List<int> expectedDigits;  // dígito esperado por coluna (dir→esq)
  late final List<int> carriesIn;       // carry “de entrada” acima da coluna

  static int _calcMaxCols(List<int> ns) {
    int maxLen = 1;
    for (final n in ns) {
      maxLen = max(maxLen, n.abs().toString().length);
    }
    return maxLen;
  }

  static int _digitAt(int n, int colFromRight) {
    final s = n.abs().toString();
    final idx = s.length - 1 - colFromRight;
    if (idx < 0) return 0;
    return s.codeUnitAt(idx) - 48; // '0'
  }
}

/// Serviço gerador de problemas de adição conforme as **novas regras**:
/// - `level` ∈ 1..5 → nº de dígitos = level + 1
///     * 1 → 2 dígitos (≈10²) | 2 → 3 dígitos (≈10³) | ... | 5 → 6 dígitos (≈10⁶)
/// - Se “incluir decimais” estiver ligado, **sempre** usa `decimalPlaces = 2` (senão 0)
/// - A **primeira** parcela sempre começa por `1 * 10^(nDigits-1)`
class AdditionService {
  final _rng = Random();

  // ---------- API nova, explícita (recomendada) ----------
  AdditionProblem generateWithFlag({
    required int addendsCount, // 2..5
    required int level,        // 1..5
    required bool useDecimals, // true → 2 casas | false → 0
  }) {
    final nDigits = _digitsForLevel(level);
    final decimalPlaces = useDecimals ? 2 : 0;
    return _generateInternal(
      addendsCount: addendsCount,
      nDigits: nDigits,
      decimalPlaces: decimalPlaces,
    );
  }

  // ---------- API antiga (mantida p/ compatibilidade) ----------
  /// Mantém a assinatura anterior, mas aplica:
  /// - `level` é mapeado para nº de dígitos = level + 1 (limitado a 1..5 → 2..6 dígitos)
  /// - `decimalPlaces` é normalizado para **0** ou **2** (qualquer valor >0 vira 2)
  AdditionProblem generate({
    required int addendsCount,
    required int level,
    required int decimalPlaces,
  }) {
    final nDigits = _digitsForLevel(level);
    final normalizedDecimals = decimalPlaces > 0 ? 2 : 0;
    return _generateInternal(
      addendsCount: addendsCount,
      nDigits: nDigits,
      decimalPlaces: normalizedDecimals,
    );
  }

  // ---------- Núcleo gerador ----------
  AdditionProblem _generateInternal({
    required int addendsCount, // 2..5
    required int nDigits,      // 2..6
    required int decimalPlaces, // 0 ou 2
  }) {
    final count = addendsCount.clamp(2, 5);
    final nd = nDigits.clamp(1, 12); // guarda-chuva

    // Primeira parcela fixa com MSD=1; demais aleatórias com nd dígitos.
    final first = _randWithDigits(nd, msdFixed: 1);
    final list = <int>[first];
    for (int i = 1; i < count; i++) {
      list.add(_randWithDigits(nd));
    }

    // Aplica as casas decimais (escala por 10^decimalPlaces).
    final scale = pow(10, decimalPlaces).toInt();
    final scaled = list.map((n) => n * scale).toList();

    return AdditionProblem(
      addends: scaled,
      decimalPlaces: decimalPlaces,
    );
  }

  // ---------- Helpers ----------
  int _digitsForLevel(int level) {
    final cl = level.clamp(1, 5);
    return cl + 1; // 1→2, 2→3, …, 5→6
  }

  /// Retorna inteiro com exatamente `n` dígitos (permitindo 0 à esquerda),
  /// e, se `msdFixed` for informado, força o dígito mais significativo.
  int _randWithDigits(int n, {int? msdFixed}) {
    if (n <= 1) {
      // 1 dígito: 0..9 ou msdFixed
      return msdFixed == null ? _rng.nextInt(10) : msdFixed.clamp(0, 9);
    }
    final pow10n_1 = pow(10, n - 1).toInt();
    if (msdFixed == null) {
      // Garante n dígitos, permitindo zeros no meio.
      final low = pow10n_1;                // 1 * 10^(n-1)
      final high = pow(10, n).toInt() - 1; // 10^n - 1
      return low + _rng.nextInt(high - low + 1);
    } else {
      final base = (msdFixed.clamp(0, 9)) * pow10n_1;
      // Completa os demais (n-1) dígitos aleatórios 0..(10^(n-1)-1)
      return base + _rng.nextInt(pow10n_1);
    }
  }
}
