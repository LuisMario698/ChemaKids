import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import 'dart:math';

class JuegoSilabasAudio extends StatefulWidget {
  const JuegoSilabasAudio({super.key});

  @override
  State<JuegoSilabasAudio> createState() => _JuegoSilabasAudioState();
}

class _JuegoSilabasAudioState extends State<JuegoSilabasAudio>
    with TickerProviderStateMixin {
  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;

  int _preguntaActual = 0;
  int _puntuacion = 0;
  bool _preguntaRespondida = false;
  String? _respuestaSeleccionada;
  final Random _random = Random();
  final TTSService _ttsService = TTSService();

  // Lista de sílabas
  final List<String> _silabas = [
    'BA',
    'BE',
    'BI',
    'BO',
    'BU',
    'CA',
    'CO',
    'CU',
    'DA',
    'DE',
    'DI',
    'DO',
    'DU',
    'FA',
    'FE',
    'FI',
    'FO',
    'FU',
    'GA',
    'GO',
    'GU',
    'JA',
    'JE',
    'JI',
    'JO',
    'JU',
    'LA',
    'LE',
    'LI',
    'LO',
    'LU',
    'MA',
    'ME',
    'MI',
    'MO',
    'MU',
    'NA',
    'NE',
    'NI',
    'NO',
    'NU',
    'PA',
    'PE',
    'PI',
    'PO',
    'PU',
    'RA',
    'RE',
    'RI',
    'RO',
    'RU',
    'SA',
    'SE',
    'SI',
    'SO',
    'SU',
    'TA',
    'TE',
    'TI',
    'TO',
    'TU',
    'VA',
    'VE',
    'VI',
    'VO',
  ];

  List<String> _preguntasActuales = [];
  List<String> _opcionesActuales = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generarPreguntas();
    _initializeTTS();
  }

  void _initializeTTS() async {
    await _ttsService.initialize();
  }

  Future<void> _reproducirSilaba() async {
    await _ttsService.speakSyllable(_preguntaActualData);
  }

  void _initializeAnimations() {
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _feedbackAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.bounceOut),
    );
  }

  void _generarPreguntas() {
    final silabasAleatorias = List<String>.from(_silabas);
    silabasAleatorias.shuffle(_random);
    _preguntasActuales = silabasAleatorias.take(10).toList();
    _generarOpcionesParaPreguntaActual();
  }

  void _generarOpcionesParaPreguntaActual() {
    final opciones = <String>[];
    opciones.add(_preguntaActualData);

    while (opciones.length < 4) {
      final silabaAleatoria = _silabas[_random.nextInt(_silabas.length)];
      if (!opciones.contains(silabaAleatoria)) {
        opciones.add(silabaAleatoria);
      }
    }

    opciones.shuffle(_random);
    _opcionesActuales = opciones;
  }

  String get _preguntaActualData => _preguntasActuales[_preguntaActual];

  void _seleccionarRespuesta(String respuesta) {
    if (_preguntaRespondida) return;

    setState(() {
      _respuestaSeleccionada = respuesta;
      _preguntaRespondida = true;
    });

    if (respuesta == _preguntaActualData) {
      _puntuacion += 10;
      _feedbackController.forward();
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (_preguntaActual < _preguntasActuales.length - 1) {
        _siguientePregunta();
      } else {
        _mostrarResultadoFinal();
      }
    });
  }

  void _siguientePregunta() {
    setState(() {
      _preguntaActual++;
      _preguntaRespondida = false;
      _respuestaSeleccionada = null;
    });
    _generarOpcionesParaPreguntaActual();
    _feedbackController.reset();
  }

  void _mostrarResultadoFinal() {
    final porcentaje =
        (_puntuacion / (_preguntasActuales.length * 10) * 100).round();
    String mensaje;

    if (porcentaje >= 90) {
      mensaje = "¡EXCELENTE!";
    } else if (porcentaje >= 70) {
      mensaje = "¡MUY BIEN!";
    } else if (porcentaje >= 50) {
      mensaje = "¡BIEN!";
    } else {
      mensaje = "¡Sigue practicando!";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF3D5A80),
          title: const Icon(Icons.emoji_events, size: 60, color: Colors.amber),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mensaje,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Puntuación: $_puntuacion/${_preguntasActuales.length * 10}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Text(
                '($porcentaje%)',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _reiniciarJuego();
              },
              child: const Text(
                'Jugar de nuevo',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Menú Principal',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _reiniciarJuego() {
    setState(() {
      _preguntaActual = 0;
      _puntuacion = 0;
      _preguntaRespondida = false;
      _respuestaSeleccionada = null;
    });
    _generarPreguntas();
    _feedbackController.reset();
  }

  Color _getColorOpcion(String opcion) {
    if (!_preguntaRespondida) {
      return const Color(0xFF98C1D9);
    }

    if (opcion == _preguntaActualData) {
      return Colors.green;
    } else if (opcion == _respuestaSeleccionada &&
        opcion != _preguntaActualData) {
      return Colors.red;
    } else {
      return const Color(0xFF98C1D9).withOpacity(0.5);
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_preguntaActual >= _preguntasActuales.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final opciones = _opcionesActuales;

    return Scaffold(
      backgroundColor: const Color(0xFF2A0944),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;

            // Cálculos responsivos
            double titleSize = screenWidth > 600 ? 32 : 24;
            double speakerSize = screenWidth > 600 ? 80 : 60;
            double containerSize = screenWidth > 600 ? 140 : 110;
            double questionSize = screenWidth > 600 ? 20 : 16;

            return Column(
              children: [
                // Header con progreso y puntuación
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: screenWidth > 600 ? 36 : 28,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Pregunta ${_preguntaActual + 1}/${_preguntasActuales.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth > 600 ? 18 : 14,
                            ),
                          ),
                          Text(
                            'Puntos: $_puntuacion',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth > 600 ? 16 : 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: screenWidth > 600 ? 52 : 36),
                    ],
                  ),
                ),

                // Progreso visual
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: LinearProgressIndicator(
                    value: (_preguntaActual + 1) / _preguntasActuales.length,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF98C1D9),
                    ),
                    minHeight: screenWidth > 600 ? 10 : 6,
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // Título
                Text(
                  'Adivina la Sílaba',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.04),

                // Ícono de bocina para escuchar la sílaba
                GestureDetector(
                  onTap: _reproducirSilaba,
                  child: Container(
                    width: containerSize,
                    height: containerSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFF98C1D9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.volume_up,
                        size: speakerSize,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                Text(
                  'Toca la bocina para escuchar',
                  style: TextStyle(color: Colors.white, fontSize: questionSize),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.01),

                Text(
                  '¿Cuál es la sílaba?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: questionSize + 2,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Opciones de respuesta (responsivas)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double screenWidth = constraints.maxWidth;
                      double screenHeight = constraints.maxHeight;

                      // Cálculos responsivos
                      double horizontalPadding = screenWidth * 0.08;
                      double spacing = screenWidth * 0.04;
                      double fontSize = screenWidth > 600 ? 24 : 20;
                      double aspectRatio = screenWidth > 600 ? 3.5 : 2.8;

                      // Ajustar según la altura disponible
                      if (screenHeight < 400) {
                        aspectRatio = 4.0; // Más ancho en pantallas muy cortas
                        fontSize = 18;
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing * 0.7,
                                childAspectRatio: aspectRatio,
                              ),
                          itemCount: opciones.length,
                          itemBuilder: (context, index) {
                            final opcion = opciones[index];
                            final color = _getColorOpcion(opcion);

                            return GestureDetector(
                              onTap: () => _seleccionarRespuesta(opcion),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  border:
                                      _respuestaSeleccionada == opcion
                                          ? Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          )
                                          : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      opcion,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (_preguntaRespondida &&
                                        opcion == _preguntaActualData)
                                      AnimatedBuilder(
                                        animation: _feedbackAnimation,
                                        builder: (context, child) {
                                          return Transform.scale(
                                            scale: _feedbackAnimation.value,
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                              size: fontSize + 2,
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
              ],
            );
          },
        ),
      ),
    );
  }
}
