import 'package:flutter/material.dart';
import '../widgets/tema_juego_chemakids.dart';
import '../widgets/dialogo_instrucciones.dart';
import '../services/tts_service.dart';
import 'dart:math';

class JuegoSilabasDesdeCero extends StatefulWidget {
  const JuegoSilabasDesdeCero({Key? key}) : super(key: key);

  @override
  State<JuegoSilabasDesdeCero> createState() => _JuegoSilabasDesdeCeroState();
}

class _JuegoSilabasDesdeCeroState extends State<JuegoSilabasDesdeCero>
    with SingleTickerProviderStateMixin {
  // Lista de consonantes por nivel - COMPLETADA con todas las consonantes
  final List<String> consonantes = [
    'b',
    'c',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    'm',
    'n',
    'ñ',
    'p',
    'q',
    'r',
    's',
    't',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];

  final List<String> vocales = ['a', 'e', 'i', 'o', 'u'];
  int nivelActual = 0;
  int indiceVocal = 0;
  String? seleccionVocal;
  String? silabaFormada;
  late AnimationController _controller;
  late Animation<double> _animScale;
  bool showConfetti = false;
  final List<bool> _animandoVocal = List<bool>.filled(5, false);
  final TTSService _ttsService = TTSService();
  bool _isPlayingAudio = false;
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

    // Inicializar el servicio TTS
    _initializeTTS();
  }
  /// Inicializa el servicio TTS
  Future<void> _initializeTTS() async {
    try {
      await _ttsService.initialize();
      print('🎵 TTS Service inicializado para sílabas desde cero');
      
      // Mostrar instrucciones al inicializar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostrarDialogoInstrucciones();
      });
    } catch (e) {
      print('❌ Error inicializando TTS en sílabas desde cero: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _ttsService.stop(); // Detener cualquier reproducción en curso
    super.dispose();  }

  Future<void> _mostrarDialogoInstrucciones() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {        return DialogoInstrucciones(
          titulo: '¡Aprendamos Sílabas!',
          descripcion: 'Forma sílabas tocando las vocales',
          instrucciones: [
            '¡Hola! Vamos a aprender a formar sílabas.',
            'Verás una consonante arriba y las vocales abajo.',
            'Toca cualquier vocal para formar una sílaba.',
            '¡Escucha cómo suena cada sílaba!',
            'Usa las flechas para cambiar de consonante.',
            '¡Diviértete aprendiendo!'
          ],
          icono: Icons.abc,
          onComenzar: () {
            // El juego ya está listo para empezar
          },
        );
      },
    );
  }

  void _formarSilaba(String vocal, int vocalIdx) async {
    if (_isPlayingAudio) return; // Evitar múltiples reproducciones

    setState(() {
      _isPlayingAudio = true;
      seleccionVocal = vocal;
      // Manejar casos especiales para Q
      if (consonantes[nivelActual] == 'q') {
        if (vocal == 'e') {
          silabaFormada = 'que';
        } else if (vocal == 'i') {
          silabaFormada = 'qui';
        } else {
          silabaFormada = consonantes[nivelActual] + vocal;
        }
      } else {
        silabaFormada = consonantes[nivelActual] + vocal;
      }
      showConfetti = true;
      _animandoVocal[vocalIdx] = true;
    });

    _controller.forward(from: 0);

    // Reproducir la sílaba formada usando TTS
    try {
      await _ttsService.speakSyllable(silabaFormada!);
      print('🔊 Reproduciendo sílaba: $silabaFormada');
    } catch (e) {
      print('❌ Error reproduciendo sílaba: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => showConfetti = false);
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _animandoVocal[vocalIdx] = false);
    });
  }

  /// Reproduce la consonante actual
  Future<void> _reproducirConsonante() async {
    if (_isPlayingAudio) return;

    setState(() {
      _isPlayingAudio = true;
    });

    try {
      final consonante = consonantes[nivelActual];
      await _ttsService.speakLetter(consonante);
      print('🔊 Reproduciendo consonante: $consonante');
    } catch (e) {
      print('❌ Error reproduciendo consonante: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    }
  }

  /// Reproduce una vocal específica
  Future<void> _reproducirVocal(String vocal) async {
    if (_isPlayingAudio) return;

    setState(() {
      _isPlayingAudio = true;
    });

    try {
      await _ttsService.speakLetter(vocal);
      print('🔊 Reproduciendo vocal: $vocal');
    } catch (e) {
      print('❌ Error reproduciendo vocal: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    }
  }

  void _siguienteNivel() {
    setState(() {
      if (nivelActual < consonantes.length - 1) {
        nivelActual++;
      } else {
        nivelActual = 0;
      }
      _resetearSeleccion();
    });
  }

  void _anteriorNivel() {
    setState(() {
      if (nivelActual > 0) {
        nivelActual--;
      } else {
        nivelActual = consonantes.length - 1;
      }
      _resetearSeleccion();
    });
  }

  void _resetearSeleccion() {
    seleccionVocal = null;
    silabaFormada = null;
    showConfetti = false;
    for (int i = 0; i < _animandoVocal.length; i++) {
      _animandoVocal[i] = false;
    }
  }

  Widget _buildBotonLetra({
    required String letra,
    required bool seleccionado,
    required Color color,
    required bool animando,
    void Function()? onTap,
    void Function()? onLongPress,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 600 && screenWidth <= 1200;

    // Tamaños responsivos para los botones
    double buttonSize;
    double fontSize;
    double iconSize;
    double margin;

    if (isDesktop) {
      buttonSize = 80;
      fontSize = 38;
      iconSize = 16;
      margin = 8;
    } else if (isTablet) {
      buttonSize = 70;
      fontSize = 34;
      iconSize = 14;
      margin = 6;
    } else {
      buttonSize = 60;
      fontSize = 28;
      iconSize = 12;
      margin = 4;
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedScale(
        scale: animando ? 1.3 : (seleccionado ? 1.15 : 1.0),
        duration: const Duration(milliseconds: 220),
        curve: Curves.elasticOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.all(margin),
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: seleccionado ? color : Colors.white,
            borderRadius: BorderRadius.circular(buttonSize / 2),
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
          child: Stack(
            children: [
              Center(
                child: Text(
                  letra.toUpperCase(),
                  style: TextStyle(
                    fontSize: fontSize,
                    color: seleccionado ? Colors.white : color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Icono de audio pequeño en la esquina
              if (!seleccionado)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(
                    Icons.volume_up,
                    size: iconSize,
                    color: color.withOpacity(0.6),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfetti() {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: showConfetti ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          child: Stack(
            children: List.generate(8, (i) {
              final icons = [
                Icons.star,
                Icons.star_border,
                Icons.favorite,
                Icons.thumb_up,
                Icons.celebration,
                Icons.auto_awesome,
                Icons.emoji_events,
              ];
              final icon = icons[i % icons.length];
              final left = (i * 0.12 + 0.1) % 1.0;
              final top = (i.isEven ? 0.1 : 0.2) + (i * 0.06);
              return Positioned(
                left: left * MediaQuery.of(context).size.width,
                top: top * MediaQuery.of(context).size.height,
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.orange.withOpacity(0.8),
                ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 600 && screenWidth <= 1200;

    // Variables responsivas
    double horizontalPadding;
    double verticalSpacing;
    double consonanteFontSize;
    double silabaFontSize;
    double progressIconSize;
    double navigationIconSize;

    if (isDesktop) {
      horizontalPadding = 40;
      verticalSpacing = 32;
      consonanteFontSize = 60;
      silabaFontSize = 70;
      progressIconSize = 16;
      navigationIconSize = 36;
    } else if (isTablet) {
      horizontalPadding = 30;
      verticalSpacing = 24;
      consonanteFontSize = 52;
      silabaFontSize = 60;
      progressIconSize = 14;
      navigationIconSize = 32;
    } else {
      horizontalPadding = 20;
      verticalSpacing = 16;
      consonanteFontSize = 44;
      silabaFontSize = 50;
      progressIconSize = 12;
      navigationIconSize = 28;
    }

    return PlantillaJuegoChemaKids(
      titulo: 'Sílabas desde Cero',
      icono: Icons.abc,
      contenido: Stack(
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
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight * 0.6),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: verticalSpacing * 0.75),
                      // Consonante grande con botón de audio
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _reproducirConsonante,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _isPlayingAudio
                                        ? Colors.amber[200]
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.08),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    consonanteNivel.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: consonanteFontSize,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    _isPlayingAudio
                                        ? Icons.volume_up
                                        : Icons.volume_up_outlined,
                                    color: Colors.deepPurple,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: verticalSpacing),
                      // 5 vocales como botones responsivos
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 4,
                        runSpacing: 8,
                        children: List.generate(vocales.length, (i) {
                          final v = vocales[i];
                          return _buildBotonLetra(
                            letra: v,
                            seleccionado: seleccionVocal == v,
                            color: Colors.orange,
                            animando: _animandoVocal[i],
                            onTap: () => _formarSilaba(v, i),
                            onLongPress: () => _reproducirVocal(v),
                          );
                        }),
                      ),
                      SizedBox(height: verticalSpacing + 12),
                      // Mostrar la sílaba formada con animación responsiva
                      if (silabaFormada != null)
                        ScaleTransition(
                          scale: _animScale,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding * 0.8,
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
                                child: Text(
                                  silabaFormada!.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: silabaFontSize,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                            ],
                          ),
                        ),
                      SizedBox(height: verticalSpacing),
                      // Barra de progreso visual simple (puntos) responsiva
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(consonantes.length, (i) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              child: Icon(
                                Icons.circle,
                                size: progressIconSize,
                                color:
                                    i == nivelActual
                                        ? Colors.deepPurple
                                        : Colors.deepPurple.withOpacity(0.2),
                              ),
                            );
                          }),
                        ),
                      ),
                      // Navegación entre consonantes mejorada y responsiva
                      Padding(
                        padding: EdgeInsets.only(top: verticalSpacing),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Botón anterior
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.1),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  size: navigationIconSize,
                                  color: Colors.deepPurple,
                                ),
                                tooltip: 'Consonante anterior',
                                onPressed: _anteriorNivel,
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Indicador de consonante actual
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                '${nivelActual + 1} / ${consonantes.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      isDesktop ? 16 : (isTablet ? 14 : 12),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Botón siguiente
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.1),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: navigationIconSize,
                                  color: Colors.deepPurple,
                                ),
                                tooltip: 'Siguiente consonante',
                                onPressed: _siguienteNivel,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
