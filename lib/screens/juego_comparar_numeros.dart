import 'package:flutter/material.dart';
import 'dart:math';
import '../services/tts_service.dart';
import '../widgets/fondo_menu_abc.dart';

class JuegoCompararNumeros extends StatefulWidget {
  const JuegoCompararNumeros({super.key});

  @override
  State<JuegoCompararNumeros> createState() => _JuegoCompararNumerosState();
}

class _JuegoCompararNumerosState extends State<JuegoCompararNumeros>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  final TTSService _ttsService = TTSService();
  bool _isPlayingAudio = false;

  int _numeroIzquierda = 0;
  int _numeroDerecha = 0;
  String _respuestaCorrecta = '';
  bool _respondido = false;
  bool _esRespuestaCorrecta = false;
  int _puntuacion = 0;
  int _rachaActual = 0;
  bool _primeraVez = true;

  final List<String> _objetosDisponibles = [
    '🍎',
    '🍊',
    '🐶',
    '🐱',
    '🌟',
    '🚗',
    '🎈',
    '🎁',
    '🦆',
    '🎯',
  ];
  String _objetoIzquierda = '🍎';
  String _objetoDerecha = '🍊';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
    _generarPregunta();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _generarPregunta() {
    final random = Random();

    setState(() {
      // Usar números más pequeños para niños pequeños (1-5)
      _numeroIzquierda = random.nextInt(5) + 1; // 1-5
      _numeroDerecha = random.nextInt(5) + 1; // 1-5

      // Evitar números iguales para hacer más fácil la comparación
      while (_numeroIzquierda == _numeroDerecha) {
        _numeroDerecha = random.nextInt(5) + 1;
      }

      // Seleccionar objetos aleatorios diferentes
      _objetoIzquierda =
          _objetosDisponibles[random.nextInt(_objetosDisponibles.length)];
      do {
        _objetoDerecha =
            _objetosDisponibles[random.nextInt(_objetosDisponibles.length)];
      } while (_objetoDerecha == _objetoIzquierda);

      // Determinar respuesta correcta
      if (_numeroIzquierda > _numeroDerecha) {
        _respuestaCorrecta = 'mayor';
      } else {
        _respuestaCorrecta = 'menor';
      }

      _respondido = false;
      _esRespuestaCorrecta = false;
    });

    _animationController.reset();
    _animationController.forward();

    // Leer instrucciones la primera vez
    if (_primeraVez) {
      _primeraVez = false;
      Future.delayed(const Duration(milliseconds: 1500), () {
        _leerInstrucciones();
      });
    } else {
      // Leer la pregunta
      Future.delayed(const Duration(milliseconds: 800), () {
        _leerPregunta();
      });
    }
  }

  Future<void> _leerInstrucciones() async {
    if (!mounted) return;
    setState(() => _isPlayingAudio = true);

    await _ttsService.speak(
      "¡Hola! Vamos a comparar números. Mira los dos grupos de objetos. "
      "Cuenta cuántos hay en cada lado y decide cuál grupo tiene más objetos. "
      "Si el grupo de la izquierda tiene más, toca 'Es mayor'. "
      "Si el grupo de la derecha tiene más, toca 'Es menor'.",
    );

    if (mounted) {
      setState(() => _isPlayingAudio = false);
      // Después de las instrucciones, leer la pregunta actual
      Future.delayed(const Duration(milliseconds: 500), () {
        _leerPregunta();
      });
    }
  }

  Future<void> _leerPregunta() async {
    if (!mounted) return;
    setState(() => _isPlayingAudio = true);

    await _ttsService.speak(
      "Cuenta los objetos. A la izquierda hay $_numeroIzquierda. "
      "A la derecha hay $_numeroDerecha. "
      "¿Cuál grupo tiene más objetos?",
    );

    if (mounted) {
      setState(() => _isPlayingAudio = false);
    }
  }

  Future<void> _repetirInstrucciones() async {
    if (_isPlayingAudio) return;
    await _leerPregunta();
  }

  void _verificarRespuesta(String respuestaSeleccionada) {
    if (_respondido) return;

    setState(() {
      _respondido = true;
      _esRespuestaCorrecta = respuestaSeleccionada == _respuestaCorrecta;

      if (_esRespuestaCorrecta) {
        _puntuacion += 10;
        _rachaActual++;
      } else {
        _rachaActual = 0;
      }
    });

    // Actualizar racha máxima si es necesario
    if (_esRespuestaCorrecta) {}

    // Feedback de voz
    if (_esRespuestaCorrecta) {
      _ttsService.speak("¡Muy bien! ¡Correcto!");
    } else {
      final respuestaTexto =
          _respuestaCorrecta == 'mayor'
              ? "El grupo de la izquierda tiene más objetos"
              : "El grupo de la derecha tiene más objetos";
      _ttsService.speak(
        "No es correcto. $respuestaTexto. ¡Inténtalo de nuevo!",
      );
    }

    // Generar nueva pregunta después de un delay
    Future.delayed(Duration(seconds: _esRespuestaCorrecta ? 2 : 3), () {
      if (mounted) {
        _generarPregunta();
      }
    });
  }

  Widget _construirGrupoObjetos(String objeto, int cantidad, bool esIzquierda) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap:
                  _respondido
                      ? null
                      : () {
                        _verificarRespuesta(esIzquierda ? 'mayor' : 'menor');
                      },
              child: MouseRegion(
                cursor:
                    _respondido ? MouseCursor.defer : SystemMouseCursors.click,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: AspectRatio(
                    aspectRatio:
                        0.75, // Proporción fija para mantener consistencia
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              esIzquierda
                                  ? [
                                    Colors.white.withOpacity(0.95),
                                    Colors.blue[200]!,
                                  ]
                                  : [
                                    Colors.white.withOpacity(0.95),
                                    Colors.purple[200]!,
                                  ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (esIzquierda
                                    ? Colors.blue[700]
                                    : Colors.purple[700])!
                                .withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(2, 2),
                          ),
                        ],
                        border: Border.all(
                          color:
                              esIzquierda
                                  ? Colors.blue[800]!
                                  : Colors.purple[800]!,
                          width: 3,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Número grande y colorido - más compacto
                          Flexible(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors:
                                      esIzquierda
                                          ? [
                                            Colors.blue[600]!,
                                            Colors.blue[800]!,
                                          ]
                                          : [
                                            Colors.purple[600]!,
                                            Colors.purple[800]!,
                                          ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (esIzquierda
                                            ? Colors.blue
                                            : Colors.purple)
                                        .withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: FittedBox(
                                child: Text(
                                  '$cantidad',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Objetos en una cuadrícula más compacta
                          Flexible(
                            flex: 3,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Calcular el tamaño de grid dinámicamente
                                int crossAxisCount =
                                    cantidad <= 2
                                        ? cantidad
                                        : (cantidad <= 4 ? 2 : 3);
                                double itemSize =
                                    constraints.maxWidth / crossAxisCount - 4;

                                return Container(
                                  constraints: BoxConstraints(
                                    maxHeight: constraints.maxHeight,
                                    maxWidth: constraints.maxWidth,
                                  ),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          mainAxisSpacing: 4,
                                          crossAxisSpacing: 4,
                                          childAspectRatio: 1.0,
                                        ),
                                    itemCount: cantidad,
                                    itemBuilder: (context, index) {
                                      return TweenAnimationBuilder<double>(
                                        duration: Duration(
                                          milliseconds: 300 + (index * 100),
                                        ),
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        builder: (context, value, child) {
                                          return Transform.scale(
                                            scale: value,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 3,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: FittedBox(
                                                  child: Text(
                                                    objeto,
                                                    style: TextStyle(
                                                      fontSize: itemSize * 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _construirBotonComparacion(
    String respuesta,
    String texto,
    IconData icono,
  ) {
    Color colorBoton;
    Color colorTexto = Colors.white;

    if (_respondido) {
      if (respuesta == _respuestaCorrecta) {
        colorBoton = Colors.green[600]!;
      } else {
        colorBoton = Colors.grey[400]!;
        colorTexto = Colors.grey[600]!;
      }
    } else {
      colorBoton = Colors.orange[500]!;
    }

    return Expanded(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: !_respondido ? _pulseAnimation.value : 1.0,
            child: Container(
              height: 80, // Altura fija para evitar overflow
              child: ElevatedButton(
                onPressed:
                    _respondido ? null : () => _verificarRespuesta(respuesta),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorBoton,
                  foregroundColor: colorTexto,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: _respondido ? 2 : 8,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icono, size: 24, color: colorTexto),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        texto,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorTexto,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return FondoMenuABC(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              const Icon(Icons.balance, color: Colors.white, size: 28),
              const SizedBox(width: 8),
              const Text(
                'Comparar Números',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            // Botón para repetir instrucciones
            IconButton(
              icon: Icon(
                _isPlayingAudio ? Icons.volume_up : Icons.volume_up_outlined,
                color: Colors.white,
                size: 28,
              ),
              onPressed: _repetirInstrucciones,
              tooltip: 'Repetir instrucciones',
            ),
            // Puntuación
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, color: Colors.yellow, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '$_puntuacion',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    (AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        MediaQuery.of(context).padding.bottom +
                        (isDesktop ? 48 : 32)),
              ),
              child: Column(
                children: [
                  // Título con instrucciones simples
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.95),
                                Colors.white.withOpacity(0.85),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.deepPurple[600]!,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 3,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: _repetirInstrucciones,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isPlayingAudio
                                        ? Icons.volume_up
                                        : Icons.volume_up_outlined,
                                    color: Colors.deepPurple[800],
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '¿Cuál grupo tiene MÁS objetos?',
                                      style: TextStyle(
                                        fontSize: isDesktop ? 30 : 24,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.deepPurple[900],
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Grupos de objetos a comparar
                  SizedBox(
                    height:
                        isDesktop ? 400 : 300, // Altura fija para las tarjetas
                    child: Row(
                      children: [
                        _construirGrupoObjetos(
                          _objetoIzquierda,
                          _numeroIzquierda,
                          true,
                        ),

                        // Separador central más atractivo
                        Container(
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.yellow[400]!,
                                      Colors.yellow[600]!,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.yellow[600]!.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 12,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 4),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'VS',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        _construirGrupoObjetos(
                          _objetoDerecha,
                          _numeroDerecha,
                          false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botones de comparación
                  if (!_respondido)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _construirBotonComparacion(
                            'mayor',
                            'Grupo IZQUIERDO\ntiene MÁS',
                            Icons.arrow_back,
                          ),
                          const SizedBox(width: 16),
                          _construirBotonComparacion(
                            'menor',
                            'Grupo DERECHO\ntiene MÁS',
                            Icons.arrow_forward,
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Feedback visual mejorado
                  if (_respondido)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              _esRespuestaCorrecta
                                  ? [Colors.green[400]!, Colors.green[600]!]
                                  : [Colors.orange[400]!, Colors.orange[600]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (_esRespuestaCorrecta
                                    ? Colors.green
                                    : Colors.orange)
                                .withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _esRespuestaCorrecta
                                ? Icons.celebration
                                : Icons.refresh,
                            color: Colors.white,
                            size: 36,
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              _esRespuestaCorrecta
                                  ? '¡Muy bien! ¡Correcto! 🎉'
                                  : '¡Inténtalo de nuevo! 💪',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Información de racha mejorada
                  if (_rachaActual > 1)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange[400]!, Colors.orange[600]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '🔥 ¡Racha de $_rachaActual! ¡Sigue así!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20), // Espacio final para scroll
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
