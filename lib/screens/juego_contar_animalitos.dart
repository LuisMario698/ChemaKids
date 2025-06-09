import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../widgets/tema_juego_chemakids.dart';
import '../widgets/contador_puntos_racha.dart';
import '../widgets/dialogo_racha_perdida.dart';
import '../widgets/dialogo_victoria.dart';
import '../services/tts_service.dart';
import '../services/estado_app.dart';

class JuegoContarAnimalitos extends StatefulWidget {
  const JuegoContarAnimalitos({super.key});

  @override
  State<JuegoContarAnimalitos> createState() => _JuegoContarAnimalitosState();
}

class _JuegoContarAnimalitosState extends State<JuegoContarAnimalitos>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  bool _showSuccess = false;
  bool _showError = false;
  int _cantidadActual = 0;
  final Random _random = Random();
  final TTSService _ttsService = TTSService();
  bool _isPlayingAudio = false;
  static const int _puntajeMaximo = 10;
  
  // Lista de emojis de animalitos
  final List<String> _animalitos = ['🐱', '🐶', '🐰', '🐼', '🐨', '🦊', '🐯', '🦁', '🐸', '🐷'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _initializeTTS().then((_) {
      // Reproducir instrucción después de que TTS se haya inicializado
      Future.delayed(const Duration(milliseconds: 500), () {
        _reproducirInstruccion();
      });
    });
    _nuevaRonda();
  }

  Future<void> _initializeTTS() async {
    try {
      await _ttsService.initialize();
      print('🎵 TTS Service inicializado para juego Contar Animalitos');
    } catch (e) {
      print('❌ Error inicializando TTS en Contar Animalitos: $e');
    }
  }

  void _nuevaRonda() {
    setState(() {
      _cantidadActual = _random.nextInt(9) + 1; // 1 a 10 animalitos
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
      await _ttsService.speak("¿Cuántos animalitos ves?");
    } catch (e) {
      print('❌ Error reproduciendo instrucción: $e');
    } finally {
      setState(() {
        _isPlayingAudio = false;
      });
    }
  }

  void _verificarRespuesta(int respuesta) {
    if (_showSuccess || _showError) return;

    setState(() {
      if (respuesta == _cantidadActual) {
        _showSuccess = true;
        _score++;
        _streak++;
        if (_streak > _maxStreak) {
          _maxStreak = _streak;
        }
      } else {
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
      }
    });

    // Reproducir retroalimentación
    try {
      if (_showSuccess) {
        _ttsService.speakCelebration();
      } else {
        _ttsService.speakEncouragement();
      }
    } catch (e) {
      print('❌ Error reproduciendo retroalimentación: $e');
    }

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
  }

  List<int> _generarOpciones() {
    List<int> opciones = [_cantidadActual];
    while (opciones.length < 3) {
      int opcion = _random.nextInt(9) + 1;
      if (!opciones.contains(opcion)) {
        opciones.add(opcion);
      }
    }
    opciones.shuffle();
    return opciones;
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
    final List<int> opciones = _generarOpciones();

    return PlantillaJuegoChemaKids(
      titulo: 'Contar Animalitos',
      icono: Icons.pets,
      contenido: Stack(
        children: [
          // Fondo con gradiente suave
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.purple[900]!.withOpacity(0.15),
                  Colors.blue[900]!.withOpacity(0.25),
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
              // Botón de instrucción mejorado
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _reproducirInstruccion,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple[400]!, Colors.purple[600]!],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple[700]!.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isPlayingAudio ? Icons.volume_up : Icons.volume_up_outlined,
                            color: Colors.white,
                            size: isDesktop ? 32 : 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '¿Cuántos hay?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 28 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Grid de animalitos mejorado
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: List.generate(
                    _cantidadActual,
                    (index) => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _animalitos[_random.nextInt(_animalitos.length)],
                        style: TextStyle(
                          fontSize: isDesktop ? 48 : 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Opciones de respuesta mejoradas
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: opciones.map((opcion) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _verificarRespuesta(opcion),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 36,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue[400]!,
                                Colors.blue[600]!,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue[700]!.withOpacity(0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Text(
                            opcion.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 40 : 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
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