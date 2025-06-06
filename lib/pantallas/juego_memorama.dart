import 'package:flutter/material.dart';
import 'dart:math';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Stack(
        children: [
          // Fondo animado con burbujas de colores llamativos
          AnimatedBurbujasMemorama(),
          SafeArea(
            child: Column(
              children: [
                // Flecha para regresar al menú
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 8,
                    right: 8,
                    bottom: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.deepPurple,
                          size: 32,
                        ),
                        tooltip: 'Menú',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Encabezado visual llamativo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.memory, color: Colors.deepPurple, size: 36),
                    SizedBox(width: 10),
                    Text(
                      'Memorama Letras y Números',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.amber,
                            blurRadius: 10,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.memory, color: Colors.deepPurple, size: 36),
                  ],
                ),
                const SizedBox(height: 18),
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
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    : Colors
                                        .primaries[i % Colors.primaries.length]
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
                                              RegExp(
                                                    r'^[0-9]$',
                                                  ).hasMatch(item.value)
                                                  ? Colors.deepPurple
                                                  : Colors.orange[900],
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
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
                const SizedBox(height: 10),
                Text(
                  'Intentos: $_intentos',
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
          ),
        ],
      ),
    );
  }
}

// Fondo animado de burbujas para memorama
class AnimatedBurbujasMemorama extends StatefulWidget {
  @override
  State<AnimatedBurbujasMemorama> createState() =>
      _AnimatedBurbujasMemoramaState();
}

class _AnimatedBurbujasMemoramaState extends State<AnimatedBurbujasMemorama>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();
  final List<Color> _bubbleColors = [
    Color(0xFFFFB74D),
    Color(0xFF64B5F6),
    Color(0xFF81C784),
    Color(0xFFE57373),
    Color(0xFFBA68C8),
    Color(0xFFFFF176),
    Color(0xFFFF8A65),
    Color(0xFF4DD0E1),
    Color(0xFFAED581),
    Color(0xFFFFD54F),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: List.generate(12, (i) {
            final double size =
                60 +
                40 * (i % 2 == 0 ? _animation.value : 1 - _animation.value);
            final double top = (height *
                    (0.1 +
                        0.7 *
                            ((i * 0.13 +
                                    _animation.value *
                                        (i.isEven ? 0.5 : -0.5)) %
                                1)))
                .clamp(0, height - size);
            final double left = (width *
                    (0.05 +
                        0.8 *
                            ((i * 0.19 +
                                    (1 - _animation.value) *
                                        (i.isOdd ? 0.4 : -0.4)) %
                                1)))
                .clamp(0, width - size);
            final color = _bubbleColors[i % _bubbleColors.length].withOpacity(
              0.18 + 0.07 * (i % 3),
            );
            return Positioned(
              top: top,
              left: left,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.18),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
