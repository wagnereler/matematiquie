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
  final String tableParam; // "7" ou "random_2_10"

  const MultiplicationGameScreen({
    super.key,
    required this.tableParam,
  });

  @override
  State<MultiplicationGameScreen> createState() =>
      _MultiplicationGameScreenState();
}

class _MultiplicationGameScreenState extends State<MultiplicationGameScreen> {
  final _service = MultiplicationService();

  // jogador ativo
  int? _playerId;
  int _hintsLeft = 5; // sincronizado com jogador ativo
  late final int _totalSecondsPerQuestion;
  late final AttemptsRepository _attemptsRepo;

  // rodada
  static const int _roundMax = 10;
  int _questionsAnswered = 0;
  final List<RoundAttempt> _roundAttempts = [];

  // modo/tabuada atual
  late final bool _isRandomRange;
  late final int _fixedTable;
  late final int _randMin;
  late final int _randMax;
  late final String _replayParam;

  int _currentTableShown = 2;

  // cronômetro
  Timer? _timer;
  int _remainingSeconds = 0;

  // placar
  int _scoreCorrect = 0;
  int _scoreTotal = 0;

  // pergunta atual (agora pode ser nula até a 1ª pergunta estar pronta)
  MathQuestion? _currentQuestion;

  // estado visual da pergunta atual
  bool _answered = false;
  bool _wasCorrect = false;
  int? _selectedOption;

  // ---------------------------------
  // Setup de parâmetros de tabuada
  // ---------------------------------
  void _parseTableParam() {
    final raw = widget.tableParam;

    if (raw.startsWith('random')) {
      _isRandomRange = true;

      final parts = raw.split('_'); // ["random","2","10"]
      if (parts.length >= 3) {
        _randMin = int.tryParse(parts[1]) ?? 2;
        _randMax = int.tryParse(parts[2]) ?? 10;
      } else {
        _randMin = 2;
        _randMax = 10;
      }

      _fixedTable = 2;
      _replayParam = "random_${_randMin}_${_randMax}";
    } else {
      _isRandomRange = false;
      _randMin = 2;
      _randMax = 10;

      _fixedTable = int.tryParse(raw) ?? 2;
      if (_fixedTable < 2) _fixedTable = 2;

      _replayParam = _fixedTable.toString();
    }
  }

  // ---------------------------------
  // Timer de cada pergunta
  // ---------------------------------
  void _startTimer({int? startSeconds}) {
    _timer?.cancel();
    // se startSeconds vier, retomamos daquele ponto;
    // se não vier, começamos do total padrão
    _remainingSeconds = startSeconds ?? _totalSecondsPerQuestion;

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

  // ---------------------------------
  // Geração da próxima pergunta
  // ---------------------------------
  void _prepareNextQuestion() {
    // já terminou 10 perguntas?
    if (_questionsAnswered >= _roundMax) {
      _finishRound(); // navega para tela final
      return;
    }

    final tableNow = _isRandomRange
        ? _service.pickRandomTable(minBase: _randMin, maxBase: _randMax)
        : _fixedTable;

    final nextQ = _service.generateQuestion(
      table: tableNow,
      maxFactor: 10,
    );

    _timer?.cancel();

    setState(() {
      _currentTableShown = tableNow;
      _currentQuestion = nextQ;

      _answered = false;
      _wasCorrect = false;
      _selectedOption = null;
    });

    _startTimer(); // reinicia tempo cheio pra nova pergunta
  }

  // ---------------------------------
  // Registro de tentativa no banco
  // ---------------------------------
  Future<void> _recordAttempt({
    required int? selectedAnswer,
    required bool isCorrect,
  }) async {
    final q = _currentQuestion!;
    _questionsAnswered += 1;
    _scoreTotal += 1;
    if (isCorrect) _scoreCorrect += 1;

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

    if (_playerId != null) {
      await _attemptsRepo.logAttempt(
        playerId: _playerId!,
        mode: 'mul',
        factorA: q.a,
        factorB: q.b,
        tableBase: _currentTableShown,
        correctAnswer: q.correctAnswer,
        selectedAnswer: selectedAnswer,
        isCorrect: isCorrect,
        timestamp: DateTime.now(),
      );
    }
  }

  // ---------------------------------
  // Consumir dica (durante o jogo)
  // e exibir explicação pedagógica
  // ---------------------------------
  Future<void> _showHintSheet({
    required bool consumeHint,
    required bool showContinueButton,
  }) async {
    final q = _currentQuestion;
    if (q == null) return; // segurança extra

    // Se for durante o jogo (consumeHint=true), pausamos o timer.
    int? resumeAfter;
    if (consumeHint && !_answered) {
      resumeAfter = _remainingSeconds;
      _timer?.cancel();
    }

    // Se for consumir, checa estoque
    if (consumeHint) {
      if (_hintsLeft <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Você não tem mais dicas disponíveis."),
            ),
          );
        }
        // se não tem dica, e a gente pausou por engano, retoma
        if (resumeAfter != null && mounted && !_answered) {
          _startTimer(startSeconds: resumeAfter);
        }
        return;
      }

      // desconta 1 dica e persiste no jogador
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

    // Retomar timer só se:
    // - era uma dica de jogo (consumeHint == true)
    // - ainda não respondeu
    // - ainda estamos na mesma pergunta
    if (consumeHint && resumeAfter != null && mounted && !_answered) {
      _startTimer(startSeconds: resumeAfter);
    }
  }

  // ---------------------------------
  // Quando o tempo acaba (não respondeu)
  // -> erro, pausa jogo
  // ---------------------------------
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

  // ---------------------------------
  // Jogador escolheu uma resposta
  // ---------------------------------
  Future<void> _selectAnswer(int value) async {
    if (_answered) return;
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
      // se acertou, só dá feedback rápido e continua
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        _prepareNextQuestion();
      });
    } else {
      // se errou, pausa o jogo e ensina
      await _pauseAfterWrong(q);
    }
  }

  // ---------------------------------
  // Pausa pedagógica quando erra
  // Mostra resposta correta + oferece "Ver dica" ou "Continuar"
  // ---------------------------------
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

  // ---------------------------------
  // Final da rodada (10 questões)
  // Atualiza roundsPlayed, recompensa dica a cada 5 rodadas
  // e vai pra tela de resultado
  // ---------------------------------
  Future<void> _finishRound() async {
    _timer?.cancel();

    final summary = RoundSummary(attempts: _roundAttempts);

    // atualiza progresso do jogador (rodadas jogadas, reposição de dica)
    final cubit = context.read<PlayersCubit>();
    final Player? p = cubit.state.activePlayer;

    if (p != null) {
      int newRounds = p.roundsPlayed + 1;
      int newHints = _hintsLeft;

      // recompensa: a cada 5 rodadas completas, +1 dica (até máximo 5)
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

  // ---------------------------------
  // Aparência dos botões de opção
  // ---------------------------------
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

  // Botão de dica no AppBar com contador e pausa automática
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
                      consumeHint: true, // gasta dica
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

  // ---------------------------------
  // Ciclo de vida
  // ---------------------------------
  @override
  void initState() {
    super.initState();

    final active = context.read<PlayersCubit>().state.activePlayer;
    _playerId = active?.id;
    _hintsLeft = active?.hintsAvailable ?? 5;

    final difficulty = active?.difficultyMax ?? 5;
    _totalSecondsPerQuestion = _service.secondsForDifficulty(difficulty);

    _attemptsRepo = context.read<AttemptsRepository>();

    _parseTableParam();

    _questionsAnswered = 0;
    _roundAttempts.clear();
    _scoreCorrect = 0;
    _scoreTotal = 0;

    // _currentQuestion começa null e build mostra loading.
    // Depois do primeiro frame a gente gera a primeira pergunta.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _prepareNextQuestion();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---------------------------------
  // UI principal
  // ---------------------------------
  @override
  Widget build(BuildContext context) {
    final q = _currentQuestion;

    // Enquanto não temos pergunta gerada ainda, mostra um loading leve
    if (q == null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.pop(),
          ),
          title: const Text("Carregando..."),
          actions: [
            _buildHintAction(),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final opts = q.options;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Tabuada do $_currentTableShown "
          "(${_questionsAnswered + 1} / $_roundMax)",
        ),
        actions: [
          _buildHintAction(),
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
