// lib/presentation/screens/addition_options_select_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_lite/l10n/l10n.dart';

class AdditionOptionsSelectScreen extends StatefulWidget {
  const AdditionOptionsSelectScreen({super.key});

  @override
  State<AdditionOptionsSelectScreen> createState() =>
      _AdditionOptionsSelectScreenState();
}

class _AdditionOptionsSelectScreenState
    extends State<AdditionOptionsSelectScreen> {
  // Estado
  int _selectedParcels = 2; // 2..5
  int _selectedLevel = 1;   // 1..5  (mapa: 1→10^2 ... 5→10^6)
  bool _decimalsEnabled = false; // se true, sempre 2 casas

  void _startGame() {
    final parcels = _selectedParcels.clamp(2, 5);
    final level = _selectedLevel.clamp(1, 5);
    final decimals = _decimalsEnabled ? 2 : 0;

    context.go(
      '/train/addition/game',
      extra: {'parcels': parcels, 'level': level, 'decimals': decimals},
    );
  }

  // legenda traduzida para as casas (u, d, c, m...)
  String _legendPlaces(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'pt') {
      return 'Legenda: u=unidade, d=dezena, c=centena, k=milhar, '
          '10k=dezenas de milhar, 100k=centenas de milhar, '
          'm=milhão, 10m=dezenas de milhão, 100m=centenas de milhão, b=bilhão.';
    } else if (lang == 'es') {
      return 'Leyenda: u=unidad, d=decena, c=centena, k=millar, '
          '10k=decenas de millar, 100k=centenas de millar, '
          'm=millón, 10m=decenas de millón, 100m=centenas de millón, b=mil millones.';
    } else {
      // en
      return 'Legend: u=unit, d=ten, c=hundred, k=thousand, '
          '10k=ten-thousand, 100k=hundred-thousand, '
          'm=million, 10m=ten-million, 100m=hundred-million, b=billion.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/play'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(l10n.add_select_title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== Parcels (2..5)
          Text(
            l10n.add_parcels_label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: [
              for (final n in [2, 3, 4, 5])
                ChoiceChip(
                  label: Text(n.toString()),
                  selected: _selectedParcels == n,
                  onSelected: (_) => setState(() => _selectedParcels = n),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // ===== Level (1..5) → 10^2..10^6
          Text(
            l10n.add_level_label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: _selectedLevel,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: [
              for (int i = 1; i <= 5; i++)
                DropdownMenuItem(value: i, child: Text('Level $i')),
            ],
            onChanged: (v) => setState(() => _selectedLevel = v ?? 1),
          ),
          const SizedBox(height: 6),
          // dica curta do mapeamento (sem depender de l10n)
          const Text(
            'Mapping: 1→10², 2→10³, 3→10⁴, 4→10⁵, 5→10⁶.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),

          const SizedBox(height: 20),

          // ===== Decimals (sempre 2 casas quando ativado)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.add_decimals_label),
            subtitle: const Text('When enabled, always uses 2 decimal places.'),
            value: _decimalsEnabled,
            onChanged: (v) => setState(() => _decimalsEnabled = v),
          ),

          const SizedBox(height: 28),

          // ===== Play
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade600,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: _startGame,
            label: Text(l10n.add_play),
          ),

          const SizedBox(height: 16),
          // ===== Legenda (padrão: explicação/ajuda sob botões)
          Text(
            _legendPlaces(context),
            style: const TextStyle(fontSize: 13, height: 1.35, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
