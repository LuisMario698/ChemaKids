import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/boton_animado.dart';
import '../widgets/dialogo_racha_perdida.dart';
import '../widgets/dialogo_victoria.dart';
import '../widgets/contador_puntos_racha.dart';
import '../widgets/tema_juego_chemakids.dart';
import '../widgets/dialogo_instrucciones.dart';
import '../services/tts_service.dart';

class JuegoSilabas extends StatefulWidget {
  const JuegoSilabas({super.key});

  @override
  State<JuegoSilabas> createState() => _JuegoSilabasState();
}

class _JuegoSilabasState extends State<JuegoSilabas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showSuccess = false;
  bool _showError = false;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  final Random _random = Random();
  List<int> _palabrasUsadas = [];
  static const int _puntajeMaximo = 10;
  
  // Servicio TTS para audio
  final TTSService _ttsService = TTSService();
  bool _isPlayingAudio = false;

  final List<Map<String, dynamic>> _silabas = [
    {
      'silaba1': 'MA',
      'silaba2': 'MA',
      'palabra': 'MAMA',
      'imagen':
          'https://img.freepik.com/premium-vector/mom-cute-cartoon-vector-illustration_480744-370.jpg',
    },
    {
      'silaba1': 'PA',
      'silaba2': 'PA',
      'palabra': 'PAPA',
      'imagen':
          'https://img.freepik.com/premium-vector/dad-cute-cartoon-vector-illustration_480744-371.jpg',
    },
    {
      'silaba1': 'CA',
      'silaba2': 'SA',
      'palabra': 'CASA',
      'imagen':
          'https://img.freepik.com/premium-vector/house-cute-cartoon-vector-illustration_480744-372.jpg',
    },
    {
      'silaba1': 'ME',
      'silaba2': 'SA',
      'palabra': 'MESA',
      'imagen':
          'https://img.freepik.com/premium-vector/table-cute-cartoon-vector-illustration_480744-373.jpg',
    },
    {
      'silaba1': 'SO',
      'silaba2': 'PA',
      'palabra': 'SOPA',
      'imagen':
          'https://img.freepik.com/premium-vector/soup-cute-cartoon-vector-illustration_480744-374.jpg',
    },
    {
      'silaba1': 'PE',
      'silaba2': 'RA',
      'palabra': 'PERA',
      'imagen':
          'https://img.freepik.com/premium-vector/pear-cute-cartoon-vector-illustration_480744-385.jpg',
    },
    {
      'silaba1': 'GA',
      'silaba2': 'TO',
      'palabra': 'GATO',
      'imagen':
          'https://img.freepik.com/premium-vector/cat-cute-cartoon-vector-illustration_480744-375.jpg',
    },
    {
      'silaba1': 'LE',
      'silaba2': 'ON',
      'palabra': 'LEON',
      'imagen':
          'https://img.freepik.com/premium-vector/lion-cute-cartoon-vector-illustration_480744-399.jpg',
    },
    {
      'silaba1': 'LU',
      'silaba2': 'NA',
      'palabra': 'LUNA',
      'imagen':
          'https://img.freepik.com/premium-vector/moon-cute-cartoon-vector-illustration_480744-381.jpg',
    },
    {
      'silaba1': 'BO',
      'silaba2': 'LA',
      'palabra': 'BOLA',
      'imagen':
          'https://img.freepik.com/premium-vector/ball-cute-cartoon-vector-illustration_480744-390.jpg',
    },
    {
      'silaba1': 'PI',
      'silaba2': 'NO',
      'palabra': 'PINO',
      'imagen':
          'https://img.freepik.com/premium-vector/pine-tree-cute-cartoon-vector-illustration_480744-391.jpg',
    },
    {
      'silaba1': 'TA',
      'silaba2': 'ZA',
      'palabra': 'TAZA',
      'imagen':
          'https://img.freepik.com/premium-vector/cup-cute-cartoon-vector-illustration_480744-395.jpg',
    },
  ];

  late Map<String, dynamic> _palabraActual;
  late List<String> _opcionesSilaba2;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _initializeTTS();
    _nuevaPregunta();
  }
  Future<void> _initializeTTS() async {
    try {
      await _ttsService.initialize();
      print('🎵 TTS Service inicializado para Sílabas Mágicas');
      
      // Mostrar instrucciones al inicializar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostrarDialogoInstrucciones();
      });
    } catch (e) {
      print('❌ Error inicializando TTS: $e');
    }
  }

  Future<void> _mostrarDialogoInstrucciones() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {        return DialogoInstrucciones(
          titulo: '¡Sílabas Mágicas!',
          descripcion: 'Forma palabras arrastrando sílabas',
          instrucciones: [
            '¡Hola! Vamos a formar palabras con sílabas.',
            'Verás una imagen y necesitas completar la palabra.',
            'Arrastra las sílabas correctas a los espacios vacíos.',
            'Si necesitas ayuda, toca el botón de sonido.',
            '¡Gana puntos por cada palabra correcta!',
            '¡Diviértete formando palabras!'
          ],
          icono: Icons.extension,
          onComenzar: () {
            // El juego ya está listo
          },
        );
      },
    );
  }

  Future<void> _reproducirPalabra() async {
    if (_isPlayingAudio) return;
    
    setState(() {
      _isPlayingAudio = true;
    });

    try {
      final palabra = _palabraActual['palabra'] as String;
      await _ttsService.speak(palabra.toLowerCase());
      print('🔊 Reproduciendo palabra: $palabra');
    } catch (e) {
      print('❌ Error reproduciendo palabra: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    }
  }

  Future<void> _reproducirSilaba(String silaba) async {
    if (_isPlayingAudio) return;
    
    setState(() {
      _isPlayingAudio = true;
    });

    try {
      await _ttsService.speakSyllable(silaba.toLowerCase());
      print('🔊 Reproduciendo sílaba: $silaba');
    } catch (e) {
      print('❌ Error reproduciendo sílaba: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    }
  }

  Future<void> _reproducirFelicitacion() async {
    try {
      await _ttsService.speakCelebration();
    } catch (e) {
      print('❌ Error reproduciendo felicitación: $e');
    }
  }

  void _nuevaPregunta() {
    // Si ya usamos todas las palabras, reiniciar la lista
    if (_palabrasUsadas.length == _silabas.length) {
      _palabrasUsadas.clear();
    }

    // Seleccionar una palabra que no haya sido usada
    int nuevaPalabraIndex;
    do {
      nuevaPalabraIndex = _random.nextInt(_silabas.length);
    } while (_palabrasUsadas.contains(nuevaPalabraIndex));

    _palabrasUsadas.add(nuevaPalabraIndex);
    _palabraActual = _silabas[nuevaPalabraIndex];

    // Crear opciones para la segunda sílaba
    _opcionesSilaba2 =
        _silabas.map((s) => s['silaba2'] as String).toList()..shuffle(_random);
    _opcionesSilaba2 = _opcionesSilaba2.take(3).toList();
    if (!_opcionesSilaba2.contains(_palabraActual['silaba2'])) {
      _opcionesSilaba2[_random.nextInt(3)] = _palabraActual['silaba2'];
    }
    _opcionesSilaba2.shuffle(_random);
  }

  void _mostrarDialogoPerdida(int rachaFinal) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DialogoRachaPerdida(racha: rachaFinal),
    );
  }

  void _mostrarDialogoVictoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => DialogoVictoria(
            score: _score,
            maxStreak: _maxStreak,
            onMenu: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            onPlayAgain: () {
              Navigator.pop(context);
              setState(() {
                _score = 0;
                _streak = 0;
                _maxStreak = 0;
                _palabrasUsadas.clear();
                _nuevaPregunta();
              });
            },
          ),
    );
  }
  void _checkRespuesta(String silaba2) {
    setState(() {
      if (silaba2 == _palabraActual['silaba2']) {
        _showSuccess = true;
        _score++;
        _streak++;
        if (_streak > _maxStreak) {
          _maxStreak = _streak;
        }
        // Reproducir felicitación cuando la respuesta es correcta
        _reproducirFelicitacion();
      } else {
        _showError = true;
        if (_streak > 0) {
          final rachaActual = _streak;
          Future.delayed(const Duration(milliseconds: 500), () {
            _mostrarDialogoPerdida(rachaActual);
          });
        }
        _streak = 0;
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _showSuccess = false;
          _showError = false;
          if (_score >= _puntajeMaximo) {
            _mostrarDialogoVictoria();
          } else {
            _nuevaPregunta();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return PlantillaJuegoChemaKids(
      titulo: 'Silabas Magicas',
      icono: Icons.spellcheck,
      mostrarAyuda: false,
      contenido: Stack(
        children: [
          // Score positioned overlay
          Positioned(
            top: 16,
            right: 16,
            child: ContadorPuntosRacha(score: _score, streak: _streak),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,              children: [
                // Botón para escuchar la palabra completa
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: _reproducirPalabra,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[300]!, Colors.blue[500]!],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isPlayingAudio ? Icons.volume_up : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isPlayingAudio ? 'Escuchando...' : '🔊 Escuchar palabra',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                                const SizedBox(height: 40),
                // Primera sílaba (fija) con botón de audio
                Column(
                  children: [
                    Container(
                      width: isDesktop ? 120 : 100,
                      height: isDesktop ? 120 : 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFA500).withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _palabraActual['silaba1'],
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Botón de audio para primera sílaba
                    GestureDetector(
                      onTap: () => _reproducirSilaba(_palabraActual['silaba1']),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlayingAudio ? Icons.volume_up : Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),                // Opciones de segunda sílaba
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children:
                      _opcionesSilaba2.map((silaba) {
                        return Column(
                          children: [
                            BotonAnimado(
                              onTap: () => _checkRespuesta(silaba),
                              child: Container(
                                width: isDesktop ? 120 : 100,
                                height: isDesktop ? 120 : 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.3),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    silaba,
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Botón de audio para cada opción de sílaba
                            GestureDetector(
                              onTap: () => _reproducirSilaba(silaba),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isPlayingAudio ? Icons.volume_up : Icons.play_arrow,
                                  color: Colors.blue[700],
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ],
            ),
          ),

          // Success/Error overlay
          if (_showSuccess || _showError)
            Container(
              color: (_showSuccess ? Colors.green[100] : Colors.red[100])
                  ?.withOpacity(0.15),
              child: Center(
                child: Icon(
                  _showSuccess ? Icons.check_circle : Icons.close,
                  color: _showSuccess ? Colors.green[400] : Colors.red[400],
                  size: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
