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
                color: Colors.white,
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
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _obtenerMensajeFinal(),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
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
                        style: TextStyle(color: Colors.white70),
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
                        style: TextStyle(color: Colors.white),
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
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 600 && screenWidth <= 1200;
    final isMobile = screenWidth <= 600;

    // Variables responsivas
    final double horizontalPadding =
        isDesktop
            ? screenWidth * 0.15
            : (isTablet ? screenWidth * 0.08 : screenWidth * 0.05);
    final double verticalSpacing = isDesktop ? 40 : (isTablet ? 30 : 20);
    final double buttonSize = isDesktop ? 180 : (isTablet ? 140 : 120);
    final double progressHeight = isDesktop ? 8 : 6;
    final double instructionFontSize = isDesktop ? 24 : (isTablet ? 20 : 16);
    final double numberFontSize = isDesktop ? 64 : (isTablet ? 48 : 36);
    final double iconSize = isDesktop ? 28 : 24;

    // Grid responsivo
    final int crossAxisCount = isDesktop ? 4 : 2;
    final double aspectRatio = isDesktop ? 1.8 : (isTablet ? 1.6 : 1.4);
    final double gridSpacing = isDesktop ? 20 : (isTablet ? 16 : 12);

    return PlantillaJuegoChemaKids(
      titulo: 'Escuchando Números',
      icono: Icons.hearing,
      mostrarAyuda: false,
      contenido: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight * 0.85),
          child: Column(
            children: [
              SizedBox(height: verticalSpacing * 0.5),

              // Indicador de progreso mejorado
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pregunta ${_preguntaActual + 1} de $_totalPreguntas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 18 : (isTablet ? 16 : 14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isPlayingAudio
                                    ? Icons.volume_up
                                    : Icons.volume_up_outlined,
                                color: Colors.white,
                                size: iconSize,
                              ),
                              if (_isPlayingAudio) ...[
                                const SizedBox(width: 8),
                                ...List.generate(3, (index) {
                                  return AnimatedBuilder(
                                    animation: _waveAnimation,
                                    builder: (context, child) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 1,
                                        ),
                                        width: 3,
                                        height:
                                            10 +
                                            (5 *
                                                _waveAnimation.value *
                                                (index + 1)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Barra de progreso
                    Container(
                      height: progressHeight,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(progressHeight / 2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: (_preguntaActual + 1) / _totalPreguntas,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.amber, Colors.orange],
                            ),
                            borderRadius: BorderRadius.circular(
                              progressHeight / 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: verticalSpacing),

              // Botón principal de reproducir audio
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isPlayingAudio ? _pulseAnimation.value : 1.0,
                    child: GestureDetector(
                      onTap: _reproducirNumero,
                      child: Container(
                        width: buttonSize,
                        height: buttonSize,
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
                              size: isDesktop ? 60 : (isTablet ? 48 : 40),
                            ),
                            SizedBox(height: isDesktop ? 12 : 8),
                            Text(
                              _isPlayingAudio ? 'Escuchando...' : '🔊 Escuchar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 18 : (isTablet ? 16 : 12),
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

              SizedBox(height: verticalSpacing),

              // Instrucción
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                padding: EdgeInsets.all(isDesktop ? 20 : 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _preguntaRespondida
                      ? (_respuestaCorrecta
                          ? '¡Correcto!'
                          : 'La respuesta era $_numeroActual')
                      : '¿Qué número escuchaste?',
                  style: TextStyle(
                    fontSize: instructionFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: verticalSpacing),

              // Opciones de números (completamente responsivo)
              Container(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    final itemWidth =
                        (availableWidth -
                            (gridSpacing * (crossAxisCount - 1))) /
                        crossAxisCount;
                    final itemHeight = itemWidth / aspectRatio;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: gridSpacing,
                        mainAxisSpacing: gridSpacing,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: _opciones.length,
                      itemBuilder: (context, index) {
                        final numero = _opciones[index];
                        final colorBase =
                            _coloresNumeros[(numero - 1) %
                                _coloresNumeros.length];
                        final colorBoton = _getColorBoton(numero);
                        final isSelected = _respuestaSeleccionada == numero;
                        final isCorrect =
                            _preguntaRespondida && numero == _numeroActual;
                        final isWrong =
                            _preguntaRespondida &&
                            isSelected &&
                            numero != _numeroActual;

                        return GestureDetector(
                          onTap: () => _seleccionarRespuesta(numero),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: colorBoton,
                              borderRadius: BorderRadius.circular(
                                isDesktop ? 20 : 15,
                              ),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? colorBase
                                        : colorBase.withOpacity(0.5),
                                width: isSelected ? 3 : 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorBase.withOpacity(
                                    isSelected ? 0.4 : 0.2,
                                  ),
                                  blurRadius: isSelected ? 12 : 8,
                                  offset: const Offset(0, 4),
                                  spreadRadius: isSelected ? 2 : 1,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$numero',
                                        style: TextStyle(
                                          color:
                                              isCorrect
                                                  ? Colors.white
                                                  : colorBase,
                                          fontSize: numberFontSize,
                                          fontWeight: FontWeight.bold,
                                          shadows:
                                              isCorrect
                                                  ? [
                                                    const Shadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 4,
                                                      color: Colors.black26,
                                                    ),
                                                  ]
                                                  : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Iconos de feedback
                                if (isCorrect)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: AnimatedBuilder(
                                      animation: _feedbackAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _feedbackAnimation.value,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                if (isWrong)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: verticalSpacing * 0.5),
            ],
          ),
        ),
      ),
    );
  }
}
