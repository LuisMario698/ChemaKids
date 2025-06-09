import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/tema_juego_chemakids.dart';
import '../widgets/contador_puntos_racha.dart';
import '../widgets/dialogo_racha_perdida.dart';
import '../widgets/dialogo_victoria.dart';
import '../services/tts_service.dart';

class JuegoObjetosNumero extends StatefulWidget {
  const JuegoObjetosNumero({super.key});

  @override
  State<JuegoObjetosNumero> createState() => _JuegoObjetosNumeroState();
}

class _JuegoObjetosNumeroState extends State<JuegoObjetosNumero>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  bool _showSuccess = false;
  bool _showError = false;
  int _numeroActual = 0;
  List<bool> _seleccionados = [];
  final Random _random = Random();
  final TTSService _ttsService = TTSService();
  bool _isPlayingAudio = false;
  static const int _puntajeMaximo = 10;

  final List<String> _objetos = ['🍎', '⭐', '🎈', '🌺', '🦋', '🍕'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _initializeTTS();
    _nuevaRonda();
  }

  Future<void> _initializeTTS() async {
    try {
      await _ttsService.initialize();
      print('🎵 TTS Service inicializado para juego Objetos y Números');
    } catch (e) {
      print('❌ Error inicializando TTS en Objetos y Números: $e');
    }
  }

  void _nuevaRonda() {
    setState(() {
      _numeroActual = _random.nextInt(9) + 1; // 1 a 10
      _seleccionados = List.generate(12, (index) => false); // 12 objetos en total
      _showSuccess = false;
      _showError = false;
    });
  }

  void _reproducirInstruccion() async {
    if (_isPlayingAudio) return;

    setState(() {
      _isPlayingAudio = true;
    });

    try {
      await _ttsService.speak("Selecciona $_numeroActual objetos");
    } catch (e) {
      print('❌ Error reproduciendo instrucción: $e');
    } finally {
      setState(() {
        _isPlayingAudio = false;
      });
    }
  }

  void _toggleSeleccion(int index) {
    if (_showSuccess || _showError) return;

    setState(() {
      _seleccionados[index] = !_seleccionados[index];
      int total = _seleccionados.where((selected) => selected).length;

      if (total == _numeroActual) {
        _showSuccess = true;
        _score++;
        _streak++;
        if (_streak > _maxStreak) {
          _maxStreak = _streak;
        }

        // Reproducir celebración
        _ttsService.speakCelebration();

        Future.delayed(const Duration(milliseconds: 1500), () {
          if (!mounted) return;
          
          if (_score >= _puntajeMaximo) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => DialogoVictoria(
                score: _score,
                maxStreak: _maxStreak,
                onPlayAgain: () {
                  Navigator.pop(context);
                  setState(() {
                    _score = 0;
                    _streak = 0;
                    _maxStreak = 0;
                    _nuevaRonda();
                  });
                },
                onMenu: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            );
          } else {
            _nuevaRonda();
          }
        });
      } else if (total > _numeroActual) {
        _showError = true;
        if (_streak >= 2) {
          final rachaActual = _streak;
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!mounted) return;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => DialogoRachaPerdida(racha: rachaActual),
            );
          });
        }
        _streak = 0;

        // Reproducir mensaje de ánimo
        _ttsService.speakEncouragement();

        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            _nuevaRonda();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return PlantillaJuegoChemaKids(
      titulo: 'Selecciona Objetos',
      icono: Icons.touch_app,
      contenido: Stack(
        children: [
          // Fondo con gradiente suave
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple[900]!.withOpacity(0.15),
                  Colors.indigo[900]!.withOpacity(0.25),
                ],
              ),
            ),
          ),

          // Contador de puntos y racha
          Positioned(
            top: 16,
            right: 16,
            child: ContadorPuntosRacha(score: _score, streak: _streak),
          ),

          // Contenido principal
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Número grande mejorado
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: GestureDetector(
                        onTap: _reproducirInstruccion,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Círculo decorativo exterior
                            Container(
                              width: isDesktop ? 180 : 160,
                              height: isDesktop ? 180 : 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.deepPurple[300]!.withOpacity(0.2),
                                    Colors.deepPurple[600]!.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                            // Círculo principal con el número
                            Container(
                              width: isDesktop ? 140 : 120,
                              height: isDesktop ? 140 : 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.deepPurple[400]!,
                                    Colors.deepPurple[700]!,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple[700]!.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                  ),
                                  BoxShadow(
                                    color: Colors.deepPurple[400]!.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(-4, -4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _numeroActual.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isDesktop ? 84 : 72,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black38,
                                          offset: const Offset(2, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Icon(
                                    _isPlayingAudio ? Icons.volume_up : Icons.volume_up_outlined,
                                    color: Colors.white.withOpacity(0.9),
                                    size: isDesktop ? 32 : 28,
                                  ),
                                ],
                              ),
                            ),
                            // Efecto de brillo
                            Positioned(
                              top: isDesktop ? 30 : 25,
                              left: isDesktop ? 35 : 30,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.4),
                                      Colors.white.withOpacity(0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 50),

              // Grid de objetos mejorado
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 6 : 4,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _toggleSeleccion(index),
                        borderRadius: BorderRadius.circular(15),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _seleccionados[index]
                                  ? [
                                      Colors.deepPurple[400]!,
                                      Colors.deepPurple[600]!,
                                    ]
                                  : [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.2),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: _seleccionados[index]
                                  ? Colors.deepPurple[300]!
                                  : Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: _seleccionados[index]
                                ? [
                                    BoxShadow(
                                      color: Colors.deepPurple[700]!.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              _objetos[index % _objetos.length],
                              style: TextStyle(
                                fontSize: isDesktop ? 40 : 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Overlay de éxito/error mejorado
          if (_showSuccess || _showError)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: (_showSuccess ? Colors.green : Colors.red).withOpacity(0.2),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_showSuccess ? Colors.green : Colors.red).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    _showSuccess ? Icons.check_circle : Icons.close,
                    color: _showSuccess ? Colors.green[600] : Colors.red[600],
                    size: 120,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}