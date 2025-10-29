// lib/presentation/screens/multiplication_game_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/players_cubit.dart';
import '../../domain/math_question.dart';
import '../../domain/round_attempt.dart';
import '../../domain/round_summary.dart';
import '../../domain/services/multiplication_service.dart';
import '../../domain/attempts_repository.dart';
import '../../domain/player.dart';

class MultiplicationGameScreen extends StatefulWidget {
  /// pode ser:
  ///  - "7"                -> tabuada fixa do 7
  ///  - "random_2_10"      -> tabuada aleatória entre 2 e 10
  ///  - "errors"           -> treinar operações que o jogador mais errou
  final String tableParam;

  /// repositório para salvar tentativas e consultar estatísticas
  final AttemptsRepository attemptsRepo;

  const MultiplicationGameScreen({
    super.key,
    required this.tableParam,
    required this.attemptsRepo,
  });

  @override
  State<MultiplicationGameScreen> createState() =>
      _MultiplicationGameScreenState();
}

class _MultiplicationGameScreenState extends State<MultiplicationGameScreen> {
  // serviço que gera perguntas, opções, dicas e calcula tempo por nível
  final _service = MultiplicationService();

  // jogador ativo (id, nível, dicas etc.)
  int? _playerId;
  int _hintsLeft = 5;
  late final int _totalSecondsPerQuestion;

  // rodada
  static const int _roundMax = 10;
  int _questionsAnswered = 0;
  final List<RoundAttempt> _roundAttempts = [];

  // placar
  int _scoreCorrect = 0;
  int _scoreTotal = 0;

  // cronômetro
  Timer? _timer;
  int _remainingSeconds = 0;

  // pergunta atual
  MathQuestion? _currentQuestion;

  // estado visual da pergunta atual
  bool _answered = false;
  bool _wasCorrect = false;
  int? _selectedOption;

  // -------------------------------------------------
  // sobre o "modo" da rodada
  // -------------------------------------------------
  //
  // Caso 1: tabuada fixa (ex: "7")
  late bool _isFixedTable;
  late int _fixedTable;

  // Caso 2: aleatório em faixa (ex: "random_2_10")
  late bool _isRandomRange;
  int _randMin = 2;
  int _randMax = 10;

  // Caso 3: foco em erros ("errors")
  late bool _isErrorsMode;
  // lista de pares (a,b) => conta direta "a × b"
  // se isso estiver preenchido, vamos tentar priorizar esses pares
  List<(int, int)> _focusPairs = [];
  int _focusIndex = 0;

  // só usamos isso para montar o título e para "jogar novamente"
  late String _replayParam;

  // tabuada "visualmente mostrada" no título ("Tabuada do X")
  // Observação: em modos aleatórios/erros, isso atualiza a cada pergunta.
  int _currentTableShown = 2;

  // -------------------------------------------------
  // Parse inicial do parâmetro recebido pela rota
  // -------------------------------------------------
  Future<void> _parseTableParamAndMaybeLoadFocusPairs() async {
    final raw = widget.tableParam;

    // reset flags
    _isFixedTable = false;
    _isRandomRange = false;
    _isErrorsMode = false;

    if (raw == 'errors') {
      // modo especial: treinar contas que mais errou
      _isErrorsMode = true;
      _replayParam = 'errors';

      // vamos buscar pares errados do jogador ativo
      if (_playerId != null) {
        final pairs = await widget.attemptsRepo.getWorstPairsForPlayer(
          _playerId!,
          limit: 20,
        );
        _focusPairs = pairs;
      }
      return;
    }

    if (raw.startsWith('random')) {
      _isRandomRange = true;
      _replayParam = raw;

      // exemplo: "random_2_10"
      final parts = raw.split('_'); // ["random","2","10"]
      if (parts.length >= 3) {
        _randMin = int.tryParse(parts[1]) ?? 2;
        _randMax = int.tryParse(parts[2]) ?? 10;
      } else {
        _randMin = 2;
        _randMax = 10;
      }
      return;
    }

    // senão, tentamos parsear número fixo
    _isFixedTable = true;
    _fixedTable = int.tryParse(raw) ?? 2;
    if (_fixedTable < 2) _fixedTable = 2;
    _replayParam = _fixedTable.toString();
  }

  // -------------------------------------------------
  // Timer
  // -------------------------------------------------
  void _startTimer({int? resumeFrom}) {
    _timer?.cancel();

    _remainingSeconds =
        resumeFrom ?? _totalSecondsPerQuestion; // começa cheio ou retoma

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        t.cancel();
        _handleTimeout();
      }
    });
  }

  // -------------------------------------------------
  // geração da próxima questão de acordo com o modo
  // -------------------------------------------------
  MathQuestion _makeQuestion() {
    // 1. modo erros?
    if (_isErrorsMode && _focusPairs.isNotEmpty) {
      // pega par atual
      final pair = _focusPairs[_focusIndex % _focusPairs.length];
      _focusIndex++;
      final a = pair.$1;
      final b = pair.$2;

      // pra consistência com os outros modos, usamos generateQuestion(table:b)
      // mas aqui queremos exatamente (a × b),
      // então vamos montar manualmente o MathQuestion.
      final correct = a * b;
      final options = _service.generateOptionsFor(correct);

      _currentTableShown = b;

      return MathQuestion(
        a: a,
        b: b,
        correctAnswer: correct,
        options: options,
        questionText: "$a × $b = ?",
      );
    }

    // 2. modo faixa aleatória
    if (_isRandomRange) {
      // escolhe uma tabuada base
      final tableNow = _service.pickRandomTable(
        minBase: _randMin,
        maxBase: _randMax,
      );
      _currentTableShown = tableNow;

      // gera pergunta padrão: fator aleatório × tableNow
      return _service.generateQuestion(
        table: tableNow,
        maxFactor: 10,
      );
    }

    // 3. tabuada fixa
    _currentTableShown = _fixedTable;
    return _service.generateQuestion(
      table: _fixedTable,
      maxFactor: 10,
    );
  }

  Future<void> _prepareNextQuestion() async {
    if (_questionsAnswered >= _roundMax) {
      await _finishRound();
      return;
    }

    final q = _makeQuestion();

    _timer?.cancel();

    setState(() {
      _currentQuestion = q;
      _answered = false;
      _wasCorrect = false;
      _selectedOption = null;
    });

    _startTimer();
  }

  // -------------------------------------------------
  // salvar tentativa no banco e atualizar placar interno
  // -------------------------------------------------
  Future<void> _recordAttempt({
    required int? selectedAnswer,
    required bool isCorrect,
  }) async {
    final q = _currentQuestion!;
    _questionsAnswered += 1;
    _scoreTotal += 1;
    if (isCorrect) _scoreCorrect += 1;

    // manter no resumo da rodada
    _roundAttempts.add(
      RoundAttempt(
        questionText: q.questionText,
        factorA: q.a,
        factorB: q.b,
        correctAnswer: q.correctAnswer,
        selectedAnswer: selectedAnswer,
        isCorrect: isCorrect,
      ),
    );

    // persistir no banco
    if (_playerId != null) {
      await widget.attemptsRepo.logAttempt(
        playerId: _playerId!,
        mode: 'mul',
        factorA: q.a,
        factorB: q.b,
        tableBase: q.b, // tabuada base é o segundo fator
        correctAnswer: q.correctAnswer,
        selectedAnswer: selectedAnswer,
        isCorrect: isCorrect,
        timestamp: DateTime.now(),
      );
    }
  }

  // -------------------------------------------------
  // consumir (ou não) dica pedagógica
  // -------------------------------------------------
  Future<void> _showHintSheet({
    required bool consumeHint,
    required bool showContinueButton,
  }) async {
    final q = _currentQuestion;
    if (q == null) return;

    int? resumeAfter;
    if (consumeHint && !_answered) {
      // pausa timer
      resumeAfter = _remainingSeconds;
      _timer?.cancel();
    }

    if (consumeHint) {
      if (_hintsLeft <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Você não tem mais dicas disponíveis."),
            ),
          );
        }
        // se pausou à toa, retoma
        if (resumeAfter != null && mounted && !_answered) {
          _startTimer(resumeFrom: resumeAfter);
        }
        return;
      }

      // desconta 1 dica e salva no jogador
      setState(() {
        _hintsLeft -= 1;
      });

      final cubit = context.read<PlayersCubit>();
      final p = cubit.state.activePlayer;
      if (p != null) {
        final updated = p.copyWith(hintsAvailable: _hintsLeft);
        await cubit.updatePlayer(updated);
      }
    }

    final hintText = _service.buildHint(q);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Como pensar nessa conta:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hintText,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade600,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(showContinueButton ? "Continuar" : "Fechar"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // retomar timer se for dica durante a pergunta
    if (consumeHint && resumeAfter != null && mounted && !_answered) {
      _startTimer(resumeFrom: resumeAfter);
    }
  }

  // -------------------------------------------------
  // jogador não respondeu em tempo
  // -------------------------------------------------
  Future<void> _handleTimeout() async {
    final q = _currentQuestion!;
    setState(() {
      _answered = true;
      _wasCorrect = false;
      _selectedOption = null;
    });

    await _recordAttempt(
      selectedAnswer: null,
      isCorrect: false,
    );

    await _pauseAfterWrong(q);
  }

  // -------------------------------------------------
  // jogador escolheu uma alternativa
  // -------------------------------------------------
  Future<void> _selectAnswer(int value) async {
    if (_answered) return; // ignora toques depois de respondido
    _timer?.cancel();

    final q = _currentQuestion!;
    final bool isRight = (value == q.correctAnswer);

    setState(() {
      _answered = true;
      _selectedOption = value;
      _wasCorrect = isRight;
    });

    await _recordAttempt(
      selectedAnswer: value,
      isCorrect: isRight,
    );

    if (isRight) {
      // se acertou: feedback rápido e próxima pergunta
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        _prepareNextQuestion();
      });
    } else {
      // se errou: pausa pedagógica
      await _pauseAfterWrong(q);
    }
  }

  // -------------------------------------------------
  // Pausa pedagógica quando erra
  // -------------------------------------------------
  Future<void> _pauseAfterWrong(MathQuestion q) async {
    final a = q.a;
    final b = q.b;
    final correct = q.correctAnswer;

    final res = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Resposta incorreta"),
          content: Text(
            "A resposta correta é $correct porque $a × $b = $correct.\n\n"
            "Quer ver como chegar nesse resultado passo a passo?",
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.lightbulb_outline),
              label: const Text("Ver dica"),
              onPressed: () {
                Navigator.of(ctx).pop('hint');
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop('cont');
              },
              child: const Text("Continuar"),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (res == 'hint') {
      // dica pós-erro NÃO consome dica
      await _showHintSheet(
        consumeHint: false,
        showContinueButton: true,
      );
    }

    if (mounted) {
      _prepareNextQuestion();
    }
  }

  // -------------------------------------------------
  // fim da rodada
  // -------------------------------------------------
  Future<void> _finishRound() async {
    _timer?.cancel();

    final summary = RoundSummary(attempts: _roundAttempts);

    // atualizar progresso do jogador
    final cubit = context.read<PlayersCubit>();
    final Player? p = cubit.state.activePlayer;
    if (p != null) {
      int newRounds = p.roundsPlayed + 1;
      int newHints = _hintsLeft;

      // recompensa: a cada 5 rodadas completas, +1 dica (máx 5)
      if (newRounds % 5 == 0 && newHints < 5) {
        newHints += 1;
        if (newHints > 5) newHints = 5;
      }

      final updated = p.copyWith(
        roundsPlayed: newRounds,
        hintsAvailable: newHints,
      );
      await cubit.updatePlayer(updated);
    }

    if (!mounted) return;

    context.go(
      '/train/multiplication/result',
      extra: {
        'summary': summary,
        'replayParam': _replayParam,
      },
    );
  }

  // -------------------------------------------------
  // UI helpers
  // -------------------------------------------------
  Color _buttonColor(int opt) {
    final q = _currentQuestion;
    if (q == null) {
      return Colors.grey.shade400;
    }

    if (!_answered) {
      return Colors.amber.shade600;
    }
    if (opt == q.correctAnswer) {
      return Colors.green.shade600;
    }
    if (_selectedOption == opt && !_wasCorrect) {
      return Colors.red.shade600;
    }
    return Colors.grey.shade400;
  }

  Widget _optionButton(int opt) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _buttonColor(opt),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 20),
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.black12),
            ),
          ),
          onPressed: () => _selectAnswer(opt),
          child: Text("$opt"),
        ),
      ),
    );
  }

  double _progressValue() {
    final total = _totalSecondsPerQuestion;
    if (total == 0) return 0.0;
    final v = _remainingSeconds / total;
    return v.clamp(0.0, 1.0);
  }

  // botão de dica (💡) no app bar com contador
  Widget _buildHintAction() {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            tooltip: 'Dica ($_hintsLeft)',
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: _hintsLeft > 0
                ? () {
                    _showHintSheet(
                      consumeHint: true,
                      showContinueButton: false,
                    );
                  }
                : null,
          ),
          Positioned(
            right: 4,
            top: 6,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.red,
              child: Text(
                '$_hintsLeft',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // botão de cancelar partida no app bar
  Widget _buildCancelAction() {
    return IconButton(
      tooltip: 'Sair',
      icon: const Icon(Icons.close),
      onPressed: () async {
        _timer?.cancel();

        final reallyQuit = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Encerrar treino?"),
            content: const Text(
              "Se você sair agora, essa rodada vai terminar antes das 10 questões.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text("Continuar jogando"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text("Sair"),
              ),
            ],
          ),
        );

        if (reallyQuit == true && mounted) {
          // volta pra tela de escolha de tabuada
          context.go('/train/multiplication/select');
        } else {
          // retoma timer se ainda não tinha respondido
          if (mounted && !_answered) {
            _startTimer(resumeFrom: _remainingSeconds);
          }
        }
      },
    );
  }

  // -------------------------------------------------
  // ciclo de vida
  // -------------------------------------------------
  @override
  void initState() {
    super.initState();

    final active = context.read<PlayersCubit>().state.activePlayer;
    _playerId = active?.id;
    _hintsLeft = active?.hintsAvailable ?? 5;

    final difficulty = active?.difficultyMax ?? 5;
    _totalSecondsPerQuestion = _service.secondsForDifficulty(difficulty);

    // parse do modo (isso também pode carregar erros)
    _parseTableParamAndMaybeLoadFocusPairs().then((_) {
      if (!mounted) return;
      // primeira pergunta
      _questionsAnswered = 0;
      _roundAttempts.clear();
      _scoreCorrect = 0;
      _scoreTotal = 0;

      _prepareNextQuestion();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // -------------------------------------------------
  // build
  // -------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final q = _currentQuestion;

    final appBarTitle = "Tabuada do $_currentTableShown "
        "(${_questionsAnswered + 1} / $_roundMax)";

    // Se ainda não geramos a 1ª pergunta (q == null), mostra loading
    if (q == null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.go('/train/multiplication/select'),
          ),
          title: Text(appBarTitle),
          actions: [
            _buildHintAction(),
            _buildCancelAction(),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final opts = q.options;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go('/train/multiplication/select'),
        ),
        title: Text(appBarTitle),
        actions: [
          _buildHintAction(),
          _buildCancelAction(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // topo: placar + tempo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Acertos: $_scoreCorrect/$_scoreTotal",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Tempo: $_remainingSeconds s",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: _progressValue(),
              backgroundColor: Colors.grey.shade300,
              color: Colors.redAccent,
              minHeight: 8,
            ),

            const SizedBox(height: 24),

            // pergunta
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  q.questionText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // opções 2x2
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Row(
                    children: [
                      _optionButton(opts[0]),
                      _optionButton(opts[1]),
                    ],
                  ),
                  Row(
                    children: [
                      _optionButton(opts[2]),
                      _optionButton(opts[3]),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Escolha a resposta antes do tempo acabar!",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
