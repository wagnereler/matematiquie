// lib/presentation/screens/addition_game_screen.dart
import 'dart:math';
import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:math_lite/l10n/l10n.dart';
import '../../domain/round_attempt.dart';
import '../../domain/round_summary.dart';

class AdditionGameScreen extends StatefulWidget {
  const AdditionGameScreen({
    super.key,
    required this.parcels, // 2..5
    required this.level, // 1..5  (mapeado para nº de dígitos = level+1)
    required this.decimals, // 0 (sem) | 2 (com 2 casas)
  });

  final int parcels;
  final int level;
  final int decimals;

  @override
  State<AdditionGameScreen> createState() => _AdditionGameScreenState();
}

class _AdditionGameScreenState extends State<AdditionGameScreen> {
  final _rng = Random();

  static const int _roundTarget = 10;
  int _roundIndex = 0;

  late _Problem _problem;

  // inputs do resultado
  final List<TextEditingController> _resultCtrls = [];
  final List<FocusNode> _resultFocus = [];
  final List<bool> _resultWrong = [];

  // inputs do "vai-um” (carry). Existem para as colunas 1..(cols-1).
  final List<TextEditingController> _carryCtrls = [];
  final List<FocusNode> _carryFocus = [];

  // previsão de “vai-um” para mover foco automaticamente
  late List<int> _carryToLeft;

  // tentativas para tela de resultado
  final List<RoundAttempt> _attempts = [];

  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  @override
  void dispose() {
    for (final c in _resultCtrls) c.dispose();
    for (final f in _resultFocus) f.dispose();
    for (final c in _carryCtrls) c.dispose();
    for (final f in _carryFocus) f.dispose();
    super.dispose();
  }

  // ================== GERAÇÃO ==================

  int _digitsFromLevel(int level) => (level + 1).clamp(2, 6);

  void _startNewRound() {
    _problem = _makeProblem(
      parcels: widget.parcels,
      nDigits: _digitsFromLevel(widget.level),
      decimals: widget.decimals,
    );

    _clearFields();
    _allocControllers(_problem.resultCols);

    // precomputar “vai-um” por coluna para pilotar o foco
    _carryToLeft = _computeExpectedCarryToLeft();

    // limpar estados de erro
    setState(() {
      for (int i = 0; i < _resultWrong.length; i++) {
        _resultWrong[i] = false;
      }
    });

    // foco inicial: coluna das unidades (extrema direita)
    Future.microtask(() {
      if (_resultFocus.isNotEmpty) {
        _resultFocus[_resultFocus.length - 1].requestFocus();
      }
    });
  }

  void _clearFields() {
    for (final c in _resultCtrls) c.dispose();
    for (final f in _resultFocus) f.dispose();
    for (final c in _carryCtrls) c.dispose();
    for (final f in _carryFocus) f.dispose();
    _resultCtrls.clear();
    _resultFocus.clear();
    _carryCtrls.clear();
    _carryFocus.clear();
    _resultWrong.clear();
  }

  void _allocControllers(int cols) {
    for (int i = 0; i < cols; i++) {
      _resultCtrls.add(TextEditingController());
      _resultFocus.add(FocusNode());
      _resultWrong.add(false);
    }
    // 1ª coluna (extra à esquerda) fica invisível e pré-preenchida com zero
    if (_resultCtrls.isNotEmpty) {
      _resultCtrls[0].text = '0';
    }
    for (int i = 0; i < cols - 1; i++) {
      _carryCtrls.add(TextEditingController());
      _carryFocus.add(FocusNode());
    }
  }

  int _randWithDigits(int n, {int? msdFixed}) {
    final limit = pow(10, n).toInt();
    if (msdFixed == null) return _rng.nextInt(limit);
    if (n == 1) return msdFixed.clamp(0, 9);
    final base = msdFixed * pow(10, n - 1).toInt();
    final span = pow(10, n - 1).toInt();
    return base + _rng.nextInt(span);
  }

  _Problem _makeProblem({
    required int parcels,
    required int nDigits,
    required int decimals,
  }) {
    final scale = pow(10, decimals).toInt();
    int anyFractionNonZero = 0;

    List<int> _makeOne({required bool isFirst}) {
      final ip = isFirst
          ? _randWithDigits(nDigits, msdFixed: 1) // 1*10^(n-1)
          : _randWithDigits(nDigits);
      int fp = 0;
      if (decimals > 0) {
        fp = _rng.nextInt(scale);
        anyFractionNonZero |= fp;
      }
      return [ip, fp];
    }

    final pairs = <List<int>>[];
    for (int i = 0; i < parcels; i++) {
      pairs.add(_makeOne(isFirst: i == 0));
    }
    if (decimals > 0 && anyFractionNonZero == 0) {
      pairs[_rng.nextInt(parcels)][1] = _rng.nextInt(scale - 1) + 1;
    }

    final addends = <int>[];
    for (final p in pairs) {
      addends.add(p[0] * scale + p[1]);
    }
    final expectedSum = addends.fold<int>(0, (a, b) => a + b);

    int digitsOf(int x) => x == 0 ? 1 : x.abs().toString().length;

    // +1 coluna extra à esquerda para possíveis "estouros"
    final int colsBase = max(nDigits + decimals, digitsOf(expectedSum));
    final int cols = colsBase + 1;

    return _Problem(
      addends: addends,
      decimals: decimals,
      expected: expectedSum,
      resultCols: cols,
      nDigitsBase: nDigits,
    );
  }

  // calcula quanto “sobe” para a coluna à ESQUERDA após somar a coluna j
  List<int> _computeExpectedCarryToLeft() {
    final cols = _problem.resultCols;
    final addendsDigits = _problem.addends
        .map((n) => _intToDigits(n, cols))
        .toList();
    final out = List<int>.filled(cols, 0);

    int carry = 0;
    for (int j = cols - 1; j >= 0; j--) {
      int sum = carry;
      for (final d in addendsDigits) {
        sum += d[j];
      }
      final carryToLeft = sum ~/ 10;
      out[j] = carryToLeft;
      carry = carryToLeft;
    }
    return out;
  }

  // ================== CONTROLE ==================

  void _onCancel() => context.go('/train/addition/options');

  void _onVerify() {
    final l10n = context.l10n;

    // precisa preencher todas as casas do resultado (exceto a 1ª invisível já vem 0)
    for (int i = 1; i < _resultCtrls.length; i++) {
      final t = _resultCtrls[i].text.trim();
      if (t.isEmpty || int.tryParse(t) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.addFillAll)),
        );
        return;
      }
    }

    final user = _digitsToInt(
      _resultCtrls.map((c) => int.parse(c.text.isEmpty ? '0' : c.text)).toList(),
    );

    final expected = _problem.expected;
    final isCorrect = user == expected;

    _markWrongDigits(
      expectedDigits: _intToDigits(expected, _problem.resultCols),
      userDigits: _intToDigits(user, _problem.resultCols),
    );

    final qText = _prettyAddendsForFeedback(
      _problem.addends,
      _problem.decimals,
    );

    _attempts.add(
      RoundAttempt(
        factorA: _problem.addends.isNotEmpty ? _problem.addends[0] : 0,
        factorB: _problem.addends.length > 1 ? _problem.addends[1] : 0,
        correctAnswer: expected,
        selectedAnswer: user,
        isCorrect: isCorrect,
        questionText: qText,
      ),
    );

    if (isCorrect) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.addCorrectTitle),
          content: Text(l10n.addFeedbackOk),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _advanceOrFinish();
              },
              child: Text(l10n.btnContinue),
            ),
          ],
        ),
      );
    } else {
      final expDigits = _intToDigits(expected, _problem.resultCols);
      final usrDigits = _intToDigits(user, _problem.resultCols);

      int wrongColFromRight = -1; // 1..N (1=unidades)
      for (int i = 0; i < expDigits.length; i++) {
        final ridx = expDigits.length - 1 - i;
        if (expDigits[ridx] != usrDigits[ridx]) {
          wrongColFromRight = i + 1;
          break;
        }
      }
      final expDigit = wrongColFromRight == -1
          ? 0
          : expDigits[expDigits.length - wrongColFromRight];
      final subtotal =
          usrDigits.isEmpty ? 0 : usrDigits[usrDigits.length - (wrongColFromRight == -1 ? 1 : wrongColFromRight)];

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.addIncorrectTitle),
          content: Text(
            l10n.addFeedbackWrongFmt(
              wrongColFromRight == -1 ? 1 : wrongColFromRight,
              subtotal,
              expDigit,
              0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _advanceOrFinish();
              },
              child: Text(l10n.btnContinue),
            ),
          ],
        ),
      );
    }
  }

  void _advanceOrFinish() {
    for (final c in _resultCtrls) c.clear();
    if (_resultCtrls.isNotEmpty) _resultCtrls[0].text = '0';
    for (final c in _carryCtrls) c.clear();

    if (_roundIndex + 1 >= _roundTarget) {
      final summary = RoundSummary(attempts: List.unmodifiable(_attempts));
      context.go(
        '/train/addition/result',
        extra: {
          'summary': summary,
          'parcels': widget.parcels,
          'level': widget.level,
          'decimals': widget.decimals,
        },
      );
    } else {
      setState(() {
        _roundIndex++;
        _startNewRound();
      });
    }
  }

  void _markWrongDigits({
    required List<int> expectedDigits,
    required List<int> userDigits,
  }) {
    for (int i = 0; i < _resultWrong.length; i++) {
      _resultWrong[i] = false;
    }
    final len = min(expectedDigits.length, userDigits.length);
    for (int i = 0; i < len; i++) {
      _resultWrong[i] = expectedDigits[i] != userDigits[i];
    }
    setState(() {});
  }

  // ================== HELPERS DÍGITOS/FORMATAÇÃO ==================

  List<int> _intToDigits(int value, int cols) {
    final s = value.abs().toString();
    final List<int> out = List.filled(cols, 0);
    int si = s.length - 1;
    int oi = cols - 1;
    while (si >= 0 && oi >= 0) {
      out[oi] = int.parse(s[si]);
      si--;
      oi--;
    }
    return out;
  }

  int _digitsToInt(List<int> digits) {
    int v = 0;
    for (final d in digits) {
      v = v * 10 + d;
    }
    return v;
  }

  String _decimalSep(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return NumberFormat.decimalPattern(locale).symbols.DECIMAL_SEP;
  }

  String _prettyAddendsForFeedback(List<int> ints, int decimals) {
    final sep = decimals > 0 ? _decimalSep(context) : '';
    final scale = pow(10, decimals).toInt();
    String fmt(int v) {
      if (decimals == 0) return v.toString();
      final ip = v ~/ scale;
      final fp = (v % scale).toString().padLeft(decimals, '0');
      return '$ip$sep$fp';
    }
    return ints.map(fmt).join(' + ') + ' = ?';
  }

  // série de rótulos vinda do l10n (ex.: "u,d,c,m,dm,cm,mi,dmi,cmi,bi")
  List<String> _placeLabelsFromL10n(BuildContext context) {
    final s = context.l10n.placeAbbrevSeries; // gerado a partir de place_abbrev_series
    return s.split(',').map((e) => e.trim()).toList();
  }

  String _levelHeader(BuildContext context) {
    final l10n = context.l10n;
    return '${l10n.addGameTitle} — ${l10n.addLevelItemFmt(widget.level)}';
  }

  // Cabeçalho com rótulos + “lousa”
  Widget _boardWithLabels({
    required double cell,
    required bool showSep,
    required int cols,
    required int sepIndexFromLeft,
    required String sepChar,
    required TextStyle textNum,
  }) {
    final labelsSeries = _placeLabelsFromL10n(context);

    // índice da coluna de UNIDADES (0 da esquerda)
    final unitCol = cols - 1 - (_problem.decimals > 0 ? _problem.decimals : 0);

    Widget labelsRow() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // deslocamento para alinhar com o “+” (todas as linhas de números o têm)
          SizedBox(width: cell),
          for (int i = 0; i < cols; i++) ...[
            if (showSep && i == sepIndexFromLeft)
              SizedBox(
                width: max(8, cell * .25),
                child: Center(
                  child: Text(
                    sepChar,
                    style: TextStyle(
                      fontSize: max(12, cell * 0.35),
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            SizedBox(
              width: cell,
              height: max(16, cell * .6),
              child: Center(
                child: Text(
                  // só rotulamos as colunas INTEIRAS (à esquerda do separador)
                  // rótulo vem da direita para a esquerda: u, d, c, m, dm...
                  (i <= unitCol)
                      ? (() {
                          final distFromRight = (cols - 1) - i;
                          if (distFromRight < labelsSeries.length) {
                            return labelsSeries[distFromRight];
                          }
                          return '';
                        })()
                      : '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    }

    List<Widget> _rowDigits(int value, {bool hideFirstZero = false}) {
      final d = _intToDigits(value, cols);
      return [
        for (int i = 0; i < cols; i++) ...[
          if (showSep && i == sepIndexFromLeft)
            SizedBox(
              width: max(8, cell * .25),
              child: Center(
                child: Text(
                  sepChar,
                  style: TextStyle(
                    fontSize: max(12, cell * 0.35),
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          SizedBox(
            width: cell,
            height: cell,
            child: Center(
              child: Text(
                '${d[i]}',
                style: textNum.copyWith(
                  // torna invisível o dígito extra da 1ª coluna (zero)
                  color: hideFirstZero && i == 0
                      ? Theme.of(context).scaffoldBackgroundColor
                      : textNum.color,
                ),
              ),
            ),
          ),
        ],
      ];
    }

    Widget carryRow() => Row(
          children: [
            SizedBox(width: cell), // desloca 1 coluna para a direita
            for (int i = 0; i < cols - 1; i++) ...[
              if (showSep && (i + 1) == sepIndexFromLeft)
                SizedBox(width: max(8, cell * .25)),
              SizedBox(
                width: cell,
                height: cell,
                child: TextField(
                  controller: _carryCtrls[i],
                  focusNode: _carryFocus[i],
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (txt) {
                    // após digitar o vai-um, seguimos para a coluna de resultado abaixo (mesmo índice+1)
                    if (txt.length == 1) {
                      final nextResCol = i + 1;
                      if (nextResCol < _resultFocus.length) {
                        _resultFocus[nextResCol].requestFocus();
                      }
                    }
                  },
                ),
              ),
            ],
          ],
        );

    Widget divider() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(width: cell),
              if (showSep)
                Row(children: [
                  SizedBox(width: sepIndexFromLeft * cell + max(8, cell * .25)),
                  Container(width: (cols * cell), height: 2, color: Colors.black87),
                ])
              else
                Container(width: cols * cell, height: 2, color: Colors.black87),
            ],
          ),
        );

    Widget resultRow() => Row(
          children: [
            SizedBox(width: cell),
            for (int i = 0; i < cols; i++) ...[
              if (showSep && i == sepIndexFromLeft)
                SizedBox(
                  width: max(8, cell * .25),
                  child: Center(
                    child: Text(
                      sepChar,
                      style: TextStyle(
                        fontSize: max(12, cell * 0.35),
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                width: cell,
                height: cell,
                child: TextField(
                  controller: _resultCtrls[i],
                  focusNode: _resultFocus[i],
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  enabled: i != 0, // 1ª coluna (extra) não editável
                  style: textNum.copyWith(
                    color: i == 0
                        ? Theme.of(context).scaffoldBackgroundColor // invisível
                        : (_resultWrong[i] ? Colors.red.shade700 : Colors.black),
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: _resultWrong[i] ? Colors.red.shade400 : Colors.black26,
                        width: _resultWrong[i] ? 2 : 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: _resultWrong[i] ? Colors.red.shade700 : Colors.indigo,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (txt) {
                    if (txt.length == 1) {
                      // preenchemos da DIREITA → ESQUERDA
                      final j = i;
                      final leftCol = i - 1;

                      // se houver necessidade de “vai-um” após esta coluna,
                      // focamos o campo de carry da coluna à esquerda
                      if (leftCol >= 1 && _carryToLeft[j] > 0) {
                        _carryFocus[leftCol - 1].requestFocus();
                      } else if (leftCol >= 0) {
                        // segue para a próxima coluna de resultado (à esquerda)
                        _resultFocus[leftCol].requestFocus();
                      } else {
                        _resultFocus[i].unfocus();
                      }
                    }
                  },
                ),
              ),
            ],
          ],
        );

    final addends = _problem.addends;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelsRow(),
        SizedBox(height: max(2, cell * 0.1)),
        carryRow(),
        SizedBox(height: max(2, cell * 0.1)),
        // linhas dos números (todas começam com deslocamento de 1 célula para o “+”)
        Row(children: [SizedBox(width: cell), ..._rowDigits(addends[0], hideFirstZero: true)]),
        if (addends.length > 1)
          Row(children: [SizedBox(width: cell), ..._rowDigits(addends[1], hideFirstZero: true)]),
        if (addends.length > 2)
          for (int i = 2; i < addends.length; i++)
            Row(children: [SizedBox(width: cell), ..._rowDigits(addends[i], hideFirstZero: true)]),
        divider(),
        resultRow(),
      ],
    );
  }

  // legenda padronizada (abaixo dos botões)
  String _legendPlacesText() {
    final l10n = context.l10n;
    final sep = _decimalSep(context);
    return '${l10n.legendPlaces} ${l10n.legendDecimalSepFmt(sep)}';
  }

  @override
  Widget build(BuildContext context) {
    final title = _levelHeader(context);

    final int cols = _problem.resultCols;
    final double screenW = MediaQuery.of(context).size.width;
    const double sidePadding = 16 * 2;
    final double available = max(240, screenW - sidePadding);

    final bool showSep = _problem.decimals > 0;
    final int sepIndexFromLeft = showSep ? cols - _problem.decimals : -1;
    final String sepChar = showSep ? _decimalSep(context) : '';

    double cell = 44.0;
    double sepExtra = showSep ? max(8, cell * .25) : 0;
    double boardWidth = cols * cell + sepExtra + cell; // +cell pelo “+”/offset

    bool needsScroll = false;
    if (boardWidth > available) {
      cell = max(26.0, min(44.0, (available - sepExtra) / (cols + 1)));
      boardWidth = cols * cell + sepExtra + cell;
      if (boardWidth > available) needsScroll = true;
    }

    final textNum = TextStyle(
      fontSize: max(16, cell * 0.45),
      fontWeight: FontWeight.w600,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    final boardContent = _boardWithLabels(
      cell: cell,
      showSep: showSep,
      cols: cols,
      sepIndexFromLeft: sepIndexFromLeft,
      sepChar: sepChar,
      textNum: textNum,
    );

    final boardWidget = SizedBox(width: boardWidth, child: boardContent);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onCancel,
          tooltip: context.l10n.btnClose,
        ),
        actions: [
          TextButton(onPressed: _onCancel, child: Text(context.l10n.btnExit)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Center(
              child: needsScroll
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: boardWidget,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: boardWidget,
                    ),
            ),
            if (needsScroll) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.screen_rotation, size: 18, color: Colors.black45),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      // simples e neutro nas três línguas
                      Localizations.localeOf(context).languageCode == 'pt'
                          ? 'Dica: gire o aparelho para paisagem se preferir.'
                          : (Localizations.localeOf(context).languageCode == 'es'
                              ? 'Consejo: gira el teléfono a horizontal si prefieres.'
                              : 'Tip: rotate your phone to landscape if you prefer.'),
                      style: const TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.rule),
                    onPressed: _onVerify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade600,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    label: Text(context.l10n.addVerify),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.close),
              onPressed: _onCancel,
              label: Text(context.l10n.btnClose),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${_roundIndex + 1} / $_roundTarget',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.addPlusSignHint,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              _legendPlacesText(),
              style: const TextStyle(fontSize: 13, height: 1.35, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== MODELO ==================

class _Problem {
  _Problem({
    required this.addends,
    required this.decimals,
    required this.expected,
    required this.resultCols,
    required this.nDigitsBase,
  });

  final List<int> addends; // inteiros escalados por 10^decimals
  final int decimals; // 0 | 2
  final int expected; // soma escalada
  final int resultCols; // colunas (+1 extra à esquerda)
  final int nDigitsBase; // dígitos inteiros antes do separador
}
