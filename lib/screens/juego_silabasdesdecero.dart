import 'package:flutter/material.dart';
import '../widgets/contador_puntos_racha.dart';
import '../widgets/dialogo_racha_perdida.dart';
import 'dart:math';

class JuegoSilabasDesdeCero extends StatefulWidget {
  const JuegoSilabasDesdeCero({Key? key}) : super(key: key);

  @override
  State<JuegoSilabasDesdeCero> createState() => _JuegoSilabasDesdeCeroState();
}

class _JuegoSilabasDesdeCeroState extends State<JuegoSilabasDesdeCero>
    with SingleTickerProviderStateMixin {
  // Lista de consonantes por nivel
  final List<String> consonantes = [
    'b',
    'c',
    'd',
    'f',
    'g',
    'l',
    'm',
    'n',
    'p',
    'r',
    's',
    't',
  ];
  final List<String> vocales = ['a', 'e', 'i', 'o', 'u'];
  int nivelActual = 0;
  int indiceVocal = 0;
  String? seleccionVocal;
  String? silabaFormada;
  late AnimationController _controller;
  late Animation<double> _animScale;
  bool showConfetti = false;
  final List<bool> _animandoVocal = List<bool>.filled(
    5,
    false,
  ); // Para animar cada vocal
  final List<String> _emojiList = [
    '🐶',
    '🐱',
    '🦊',
    '🐻',
    '🐼',
    '🐵',
    '🦁',
    '🐸',
    '🐤',
    '🐙',
    '🦋',
    '🐳',
    '🦄',
    '🦕',
  ];
  final List<Color> _bgColors = [
    Color(0xFFFFF59D),
    Color(0xFFFFB0B0),
    Color(0xFFA5D6A7),
    Color(0xFFB2EBF2),
    Color(0xFFD1C4E9),
    Color(0xFFFFF176),
    Color(0xFFFFCC80),
  ];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animScale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _formarSilaba(String vocal, int vocalIdx) {
    setState(() {
      seleccionVocal = vocal;
      silabaFormada = consonantes[nivelActual] + vocal;
      showConfetti = true;
      _animandoVocal[vocalIdx] = true;
    });
    _controller.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => showConfetti = false);
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _animandoVocal[vocalIdx] = false);
    });
  }

  void _reset() {
    setState(() {
      seleccionVocal = null;
      silabaFormada = null;
      showConfetti = false;
      for (int i = 0; i < _animandoVocal.length; i++) {
        _animandoVocal[i] = false;
      }
    });
  }

  void _siguienteNivel() {
    setState(() {
      if (nivelActual < consonantes.length - 1) {
        nivelActual++;
      } else {
        nivelActual = 0;
      }
      seleccionVocal = null;
      silabaFormada = null;
      showConfetti = false;
      for (int i = 0; i < _animandoVocal.length; i++) {
        _animandoVocal[i] = false;
      }
    });
  }

  Widget _buildBotonLetra({
    required String letra,
    required bool seleccionado,
    required Color color,
    required bool animando,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: animando ? 1.3 : (seleccionado ? 1.15 : 1.0),
        duration: const Duration(milliseconds: 220),
        curve: Curves.elasticOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(10),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: seleccionado ? color : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: seleccionado ? Colors.amber : color.withOpacity(0.5),
              width: seleccionado ? 4 : 2,
            ),
            boxShadow:
                seleccionado
                    ? [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                    : [],
          ),
          child: Center(
            child: Text(
              letra.toUpperCase(),
              style: TextStyle(
                fontSize: 32,
                color: seleccionado ? Colors.white : color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfetti() {
    // Simulación sencilla de confetti con emojis
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: showConfetti ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          child: Stack(
            children: List.generate(8, (i) {
              final emojis = ['🎉', '✨', '🎊', '🥳', '💫', '⭐', '🎈'];
              final emoji = emojis[i % emojis.length];
              final left = (i * 0.12 + 0.1) % 1.0;
              final top = (i.isEven ? 0.1 : 0.2) + (i * 0.06);
              return Positioned(
                left: left * MediaQuery.of(context).size.width,
                top: top * MediaQuery.of(context).size.height,
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String consonanteNivel = consonantes[nivelActual];
    final Color bgColor = _bgColors[nivelActual % _bgColors.length];
    final String emoji = _emojiList[nivelActual % _emojiList.length];

    // Animación de fondo con burbujas moviéndose
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const SizedBox.shrink(),
      ),
      body: Stack(
        children: [
          // Fondo animado de burbujas
          ...List.generate(8, (i) {
            final double size = 40 + _random.nextDouble() * 60;
            final color = _bgColors[_random.nextInt(_bgColors.length)]
                .withOpacity(0.18);
            return AnimatedBubble(
              key: ValueKey(i),
              color: color,
              size: size,
              screenWidth: MediaQuery.of(context).size.width,
              screenHeight: MediaQuery.of(context).size.height,
              duration: 4000 + _random.nextInt(3000),
              delay: i * 400,
            );
          }),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  // Emoji y consonante grande
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 60)),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.08),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          consonanteNivel.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 56,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(emoji, style: const TextStyle(fontSize: 60)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 5 vocales como botones grandes y animados por nivel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(vocales.length, (i) {
                      final v = vocales[i];
                      return _buildBotonLetra(
                        letra: v,
                        seleccionado: seleccionVocal == v,
                        color: Colors.orange,
                        animando: _animandoVocal[i],
                        onTap: () => _formarSilaba(v, i),
                      );
                    }),
                  ),
                  const SizedBox(height: 36),
                  // Mostrar la sílaba formada con animación y sonido visual
                  if (silabaFormada != null)
                    ScaleTransition(
                      scale: _animScale,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.2),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  silabaFormada!.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 70,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 4,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 56),
                                ),
                                // Se elimina el botón de escuchar
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Celebración visual
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('🎉', style: TextStyle(fontSize: 40)),
                              SizedBox(width: 8),
                              Text('👏', style: TextStyle(fontSize: 40)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 30),
                  // Emoji grande decorativo cuando no hay sílaba formada
                  if (silabaFormada == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          emoji,
                          key: ValueKey(emoji),
                          style: const TextStyle(fontSize: 120),
                        ),
                      ),
                    ),
                  // Barra de progreso visual simple (puntos)
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(consonantes.length, (i) {
                        return Icon(
                          Icons.circle,
                          size: 14,
                          color:
                              i == nivelActual
                                  ? Colors.deepPurple
                                  : Colors.deepPurple.withOpacity(0.2),
                        );
                      }),
                    ),
                  ),
                  // Flecha para cambiar de consonante (nivel)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 48,
                        color: Colors.deepPurple,
                      ),
                      tooltip: 'Siguiente consonante',
                      onPressed: _siguienteNivel,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildConfetti(),
        ],
      ),
    );
  }
}

// Animación de burbujas de fondo
class AnimatedBubble extends StatefulWidget {
  final Color color;
  final double size;
  final double screenWidth;
  final double screenHeight;
  final int duration;
  final int delay;

  const AnimatedBubble({
    Key? key,
    required this.color,
    required this.size,
    required this.screenWidth,
    required this.screenHeight,
    required this.duration,
    required this.delay,
  }) : super(key: key);

  @override
  State<AnimatedBubble> createState() => _AnimatedBubbleState();
}

class _AnimatedBubbleState extends State<AnimatedBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double startTop;
  late double endTop;
  late double left;

  @override
  void initState() {
    super.initState();
    startTop = widget.screenHeight * 0.8 * Random().nextDouble();
    endTop = widget.screenHeight * 0.1 * Random().nextDouble();
    left = widget.screenWidth * Random().nextDouble();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: startTop,
      end: endTop,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value,
          left: left,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
