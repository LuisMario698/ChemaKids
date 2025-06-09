import 'package:flutter/material.dart';
import '../widgets/tema_juego_chemakids.dart';
import '../services/tts_service.dart';
import 'dart:math';

class JuegoEscuchandoNumeros extends StatefulWidget {
  const JuegoEscuchandoNumeros({Key? key}) : super(key: key);

  @override
  State<JuegoEscuchandoNumeros> createState() => _JuegoEscuchandoNumerosState();
}

class _JuegoEscuchandoNumerosState extends State<JuegoEscuchandoNumeros>
    with TickerProviderStateMixin {
  final TTSService _ttsService = TTSService();
  bool _isPlayingAudio = false;

  int _numeroActual = 1;
  List<int> _opciones = [];
  int? _respuestaSeleccionada;
  bool _preguntaRespondida = false;
  bool _respuestaCorrecta = false;
  int _puntuacion = 0;
  int _preguntaActual = 0;
  final int _totalPreguntas = 10;

  late AnimationController _pulseController;
  late AnimationController _feedbackController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _feedbackAnimation;
  late Animation<double> _waveAnimation;

  final Random _random = Random();

  // Colores para los números
  final List<Color> _coloresNumeros = [
    const Color(0xFFE91E63), // Rosa
    const Color(0xFF2196F3), // Azul
    const Color(0xFF4CAF50), // Verde
    const Color(0xFFFF9800), // Naranja
    const Color(0xFF9C27B0), // Púrpura
    const Color(0xFF009688), // Teal
    const Color(0xFFFF5722), // Rojo-naranja
    const Color(0xFF795548), // Marrón
    const Color(0xFF607D8B), // Azul-gris
    const Color(0xFF3F51B5), // Índigo
  ];

  @override
  void initState() {
    super.initState();
    _inicializarAnimaciones();
    _initializeTTS();
    _generarNuevaPregunta();
  }

  void _inicializarAnimaciones() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _feedbackAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeTTS() async {
    try {
      await _ttsService.initialize();
      print('🎵 TTS Service inicializado para Escuchando Números');
    } catch (e) {
      print('❌ Error inicializando TTS: $e');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _feedbackController.dispose();
    _waveController.dispose();
    _ttsService.stop();
    super.dispose();
  }

  void _generarNuevaPregunta() {
    setState(() {
      // Generar número aleatorio del 1 al 10
      _numeroActual = 1 + _random.nextInt(10);

      // Generar opciones (incluyendo la respuesta correcta)
      _opciones = [_numeroActual];

      // Agregar 3 opciones incorrectas
      while (_opciones.length < 4) {
        int opcionIncorrecta = 1 + _random.nextInt(10);
        if (!_opciones.contains(opcionIncorrecta)) {
          _opciones.add(opcionIncorrecta);
        }
      }

      // Mezclar las opciones
      _opciones.shuffle(_random);

      _respuestaSeleccionada = null;
      _preguntaRespondida = false;
      _respuestaCorrecta = false;
    });

    // Reproducir automáticamente el número después de un breve retraso
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _reproducirNumero();
      }
    });
  }

  Future<void> _reproducirNumero() async {
    if (_isPlayingAudio || _preguntaRespondida) return;

    setState(() {
      _isPlayingAudio = true;
    });

    // Iniciar animaciones
    _pulseController.repeat(reverse: true);
    _waveController.repeat();

    try {
      await _ttsService.speakNumber(_numeroActual);
      print('🔊 Reproduciendo número: $_numeroActual');
    } catch (e) {
      print('❌ Error reproduciendo número: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
        _pulseController.stop();
        _waveController.stop();
      }
    }
  }

  void _seleccionarRespuesta(int numeroSeleccionado) {
    if (_preguntaRespondida || _isPlayingAudio) return;

    setState(() {
      _respuestaSeleccionada = numeroSeleccionado;
      _preguntaRespondida = true;
      _respuestaCorrecta = numeroSeleccionado == _numeroActual;

      if (_respuestaCorrecta) {
        _puntuacion++;
      }
    });

    // Animación de feedback
    _feedbackController.forward().then((_) {
      _feedbackController.reverse();
    });

    // Pasar a la siguiente pregunta o mostrar resultados
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        if (_preguntaActual < _totalPreguntas - 1) {
          setState(() {
            _preguntaActual++;
          });
          _generarNuevaPregunta();
        } else {
          _mostrarResultadosFinales();
        }
      }
    });
  }

  void _mostrarResultadosFinales() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A0944),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              '¡Juego Completado!',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _puntuacion >= 7 ? Icons.emoji_events : Icons.thumb_up,
                  color: _puntuacion >= 7 ? Colors.amber : Colors.green,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Puntuación: $_puntuacion de $_totalPreguntas',
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _obtenerMensajeFinal(),
                  style: const TextStyle(color: Color.fromARGB(179, 40, 40, 40), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Menú',
                        style: TextStyle(color: Color.fromARGB(179, 34, 34, 34)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _reiniciarJuego();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Jugar Otra Vez',
                        style: TextStyle(color: Color.fromARGB(255, 61, 60, 60)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  String _obtenerMensajeFinal() {
    if (_puntuacion == _totalPreguntas) {
      return '¡Perfecto! Tienes un oído excelente para los números.';
    } else if (_puntuacion >= 8) {
      return '¡Muy bien! Casi perfecto.';
    } else if (_puntuacion >= 6) {
      return '¡Buen trabajo! Sigue practicando.';
    } else {
      return 'Sigue practicando, ¡cada intento te hace mejor!';
    }
  }

  void _reiniciarJuego() {
    setState(() {
      _puntuacion = 0;
      _preguntaActual = 0;
    });
    _generarNuevaPregunta();
  }

  Color _getColorBoton(int numero) {
    if (!_preguntaRespondida) {
      return _respuestaSeleccionada == numero
          ? Colors.blue[300]!
          : Colors.white;
    } else {
      if (numero == _numeroActual) {
        return Colors.green[400]!; // Respuesta correcta
      } else if (_respuestaSeleccionada == numero && numero != _numeroActual) {
        return Colors.red[400]!; // Respuesta incorrecta seleccionada
      } else {
        return Colors.grey[300]!; // Otras opciones
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 600;

    return PlantillaJuegoChemaKids(
      titulo: 'Escuchando Números',
      icono: Icons.hearing,
      contenido: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Container(
            width: double.infinity,
            child: Column(
          children: [
            // Header con progreso y puntuación
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pregunta ${_preguntaActual + 1}/$_totalPreguntas',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: isDesktop ? 18 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Puntos: $_puntuacion',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: isDesktop ? 16 : 12,
                        ),
                      ),
                    ],
                  ),
                  // Indicador de audio
                  AnimatedBuilder(
                    animation:
                        _isPlayingAudio
                            ? _waveAnimation
                            : const AlwaysStoppedAnimation(0),
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              _isPlayingAudio
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isPlayingAudio
                                  ? Icons.volume_up
                                  : Icons.volume_up_outlined,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              size: isDesktop ? 24 : 20,
                            ),
                            if (_isPlayingAudio) ...[
                              const SizedBox(width: 8),
                              ...List.generate(3, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  width: 3,
                                  height:
                                      10 +
                                      (5 * _waveAnimation.value * (index + 1)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Progreso visual
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (_preguntaActual + 1) / _totalPreguntas,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            // Botón principal de reproducir audio
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isPlayingAudio ? _pulseAnimation.value : 1.0,
                  child: GestureDetector(
                    onTap: _reproducirNumero,
                    child: Container(
                      width: isDesktop ? 200 : 160,
                      height: isDesktop ? 200 : 160,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Colors.blue[400]!, Colors.blue[600]!],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: _isPlayingAudio ? 10 : 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isPlayingAudio
                                ? Icons.volume_up
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: isDesktop ? 60 : 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isPlayingAudio ? 'Escuchando...' : '🔊 Escuchar',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: isDesktop ? 18 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: screenHeight * 0.04),

            // Instrucción
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Text(
                _preguntaRespondida
                    ? (_respuestaCorrecta
                        ? '¡Correcto!'
                        : 'La respuesta era $_numeroActual')
                    : '¿Qué número escuchaste?',
                style: TextStyle(
                  fontSize: isDesktop ? 20 : 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // Opciones de números (horizontal centrado con scroll)
            Container(
              height: isDesktop ? 90 : 70,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Center(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _opciones.length,
                  itemBuilder: (context, index) {
                    final numero = _opciones[index];
                    final colorBase =
                        _coloresNumeros[(numero - 1) % _coloresNumeros.length];
                    final colorBoton = _getColorBoton(numero);

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
                      child: GestureDetector(
                        onTap: () => _seleccionarRespuesta(numero),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isDesktop ? 75 : 60,
                          height: isDesktop ? 75 : 60,
                          decoration: BoxDecoration(
                            color: colorBoton,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  _respuestaSeleccionada == numero
                                      ? colorBase
                                      : colorBase.withOpacity(0.5),
                              width: _respuestaSeleccionada == numero ? 3 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorBase.withOpacity(0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                '$numero',
                                style: TextStyle(
                                  color:
                                      _preguntaRespondida &&
                                              numero == _numeroActual
                                          ? const Color.fromARGB(255, 0, 0, 0)
                                          : colorBase,
                                  fontSize: isDesktop ? 26 : 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_preguntaRespondida && numero == _numeroActual)
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: AnimatedBuilder(
                                    animation: _feedbackAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _feedbackAnimation.value,
                                        child: Container(
                                          padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: isDesktop ? 14 : 12,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              if (_preguntaRespondida &&
                                  _respuestaSeleccionada == numero &&
                                  numero != _numeroActual)
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: isDesktop ? 14 : 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Indicador de scroll más compacto
            if (_opciones.length > 4)
              Container(
                margin: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swipe,
                      color: Colors.white.withOpacity(0.6),
                      size: 14,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Desliza para ver más opciones',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

            // Espacio adicional para evitar overflow
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
        ),
      ),
    );
  }
}
