// lib/presentation/screens/multiplication_table_select_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MultiplicationTableSelectScreen extends StatefulWidget {
  const MultiplicationTableSelectScreen({super.key});

  @override
  State<MultiplicationTableSelectScreen> createState() =>
      _MultiplicationTableSelectScreenState();
}

class _MultiplicationTableSelectScreenState
    extends State<MultiplicationTableSelectScreen> {
  final TextEditingController _customCtrl = TextEditingController();

  void _goToTable(String tableParam) {
    context.go('/train/multiplication/play/$tableParam');
  }

  Widget _buildNumberButton(int n) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber.shade600,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        minimumSize: const Size(80, 80),
      ),
      onPressed: () => _goToTable('$n'),
      child: Text('$n'),
    );
  }

  Future<void> _askRandomRange() async {
    final minCtrl = TextEditingController(text: "2");
    final maxCtrl = TextEditingController(text: "10");

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Tabuadas aleatórias",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Por padrão treinamos tabuadas até 10.\n"
                    "Se quiser desafiar mais, escolha um intervalo.\n"
                    "Exemplo: de 10 até 20.",
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "de",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: maxCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "até",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
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
                    onPressed: () {
                      final minVal = int.tryParse(minCtrl.text.trim());
                      final maxVal = int.tryParse(maxCtrl.text.trim());

                      if (minVal == null ||
                          maxVal == null ||
                          minVal < 2 ||
                          maxVal < 2) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Intervalo inválido. Use números ≥2."),
                          ),
                        );
                        return;
                      }

                      Navigator.of(ctx).pop();

                      final param = "random_${minVal}_${maxVal}";
                      _goToTable(param);
                    },
                    child: const Text("Começar"),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = <int>[2, 3, 4, 5, 6, 7, 8, 9];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go('/play'),
        ),
        title: const Text("Tabuada"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          const Text(
            "Escolha qual tabuada quer estudar!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Campo para colocar tabuada fixa (ex.: 12)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Tabuada de...",
                    hintText: "ex.: 12",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade600,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(64, 48),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  final text = _customCtrl.text.trim();
                  if (text.isEmpty) return;
                  final n = int.tryParse(text);

                  if (n == null || n < 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Digite um número válido (2 ou mais)."),
                      ),
                    );
                    return;
                  }
                  _goToTable('$n');
                },
                child: const Text("OK"),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Grid com 2..9
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.2,
            children: [
              for (final n in buttons) _buildNumberButton(n),
            ],
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade600,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: _askRandomRange,
            child: const Text("Aleatório"),
          ),

          const SizedBox(height: 24),

          const Text(
            "Como funciona:\n"
            "• Escolhendo um número, você treina só aquela tabuada.\n"
            "• Aleatório: você escolhe um intervalo (ex.: até 10 ou de 10 até 20) e o app sorteia.\n"
            "• Seu nível de dificuldade controla o tempo para responder.",
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
