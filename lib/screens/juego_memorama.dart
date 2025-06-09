import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/tema_juego_chemakids.dart';

class MemoramaItem {
  final String value;
  bool revealed;
  bool matched;
  MemoramaItem({
    required this.value,
    this.revealed = false,
    this.matched = false,
  });
}

class JuegoMemorama extends StatefulWidget {
  const JuegoMemorama({Key? key}) : super(key: key);

  @override
  State<JuegoMemorama> createState() => _JuegoMemoramaState();
}

class _JuegoMemoramaState extends State<JuegoMemorama> {
  List<MemoramaItem> _items = [];
  int? _selectedIndex;
  int _matches = 0;
  int _intentos = 0;
  bool _bloqueado = false;

  @override
  void initState() {
    super.initState();
    _generarMemorama();
  }

  void _generarMemorama() {
    // Pares: letras y números, todos tienen su par idéntico
    final List<String> valores = [
      'A',
      'A',
      'B',
      'B',
      'C',
      'C',
      '1',
      '1',
      '2',
      '2',
      '3',
      '3',
    ];
    List<MemoramaItem> items =
        valores.map((v) => MemoramaItem(value: v)).toList();
    items.shuffle(Random());
    setState(() {
      _items = items;
      _selectedIndex = null;
      _matches = 0;
      _intentos = 0;
      _bloqueado = false;
    });
  }

  void _onTap(int index) {
    if (_bloqueado || _items[index].revealed || _items[index].matched) return;
    setState(() {
      _items[index].revealed = true;
    });

    if (_selectedIndex == null) {
      _selectedIndex = index;
    } else {
      _bloqueado = true;
      _intentos++;
      final prev = _items[_selectedIndex!];
      final curr = _items[index];
      bool esPar = prev.value == curr.value && _selectedIndex != index;
      if (esPar) {
        setState(() {
          prev.matched = true;
          curr.matched = true;
          _matches++;
          _selectedIndex = null;
          _bloqueado = false;
        });
      } else {
        Future.delayed(const Duration(milliseconds: 900), () {
          setState(() {
            prev.revealed = false;
            curr.revealed = false;
            _selectedIndex = null;
            _bloqueado = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final completado = _matches == (_items.length ~/ 2);

    return PlantillaJuegoChemaKids(
      titulo: 'Memorama Letras y Números',
      icono: Icons.memory,
      mostrarAyuda: false,
      contenido: Column(
        children: [
          const SizedBox(height: 10),
          // Botón de reinicio visual
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Reiniciar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: _generarMemorama,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Grid del memorama
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final item = _items[i];
                return GestureDetector(
                  onTap: () => _onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          item.matched
                              ? Colors.greenAccent
                              : item.revealed
                              ? Colors.amberAccent
                              : Colors.primaries[i % Colors.primaries.length]
                                  .withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      border: Border.all(
                        color:
                            item.matched
                                ? Colors.green
                                : item.revealed
                                ? Colors.orange
                                : Colors.deepPurple,
                        width: item.matched ? 3 : 2,
                      ),
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child:
                            item.revealed || item.matched
                                ? Text(
                                  item.value,
                                  key: ValueKey(
                                    item.value + item.matched.toString(),
                                  ),
                                  style: TextStyle(
                                    fontSize: 28,
                                    color:
                                        RegExp(r'^[0-9]$').hasMatch(item.value)
                                            ? Colors.deepPurple
                                            : Colors.orange[900],
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.white.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(1, 2),
                                      ),
                                    ],
                                  ),
                                )
                                : const Icon(
                                  Icons.help_outline,
                                  color: Colors.white,
                                  size: 28,
                                ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Contador de intentos
          const SizedBox(height: 10),
          Text(
            'Intentos: $_intentos',
            style: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Mensaje de completado
          if (completado)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                children: [
                  const Text(
                    '¡Felicidades!',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.deepPurple,
                          blurRadius: 8,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.replay),
                    label: const Text('Jugar de nuevo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _generarMemorama,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
