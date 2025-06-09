import 'package:flutter/material.dart';
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

  // Lista de sílabas con emojis asociados
  final List<Map<String, dynamic>> _silabas = [
    {'silaba': 'BA', 'emoji': '🍌'},
    {'silaba': 'BE', 'emoji': '👶'},
    {'silaba': 'BI', 'emoji': '🚲'},
    {'silaba': 'BO', 'emoji': '⚽'},
    {'silaba': 'BU', 'emoji': '🦉'},
    {'silaba': 'CA', 'emoji': '🏠'},
    {'silaba': 'CO', 'emoji': '🥥'},
    {'silaba': 'CU', 'emoji': '🐍'},
    {'silaba': 'DA', 'emoji': '🎯'},
    {'silaba': 'DE', 'emoji': '👆'},
    {'silaba': 'DI', 'emoji': '💰'},
    {'silaba': 'DO', 'emoji': '🎵'},
    {'silaba': 'DU', 'emoji': '🍭'},
    {'silaba': 'FA', 'emoji': '🎵'},
    {'silaba': 'FE', 'emoji': '🧚'},
    {'silaba': 'FI', 'emoji': '🔥'},
    {'silaba': 'FO', 'emoji': '📱'},
    {'silaba': 'FU', 'emoji': '⚽'},
    {'silaba': 'GA', 'emoji': '🐱'},
    {'silaba': 'GO', 'emoji': '⚽'},
    {'silaba': 'GU', 'emoji': '🦆'},
    {'silaba': 'JA', 'emoji': '😂'},
    {'silaba': 'JE', 'emoji': '✅'},
    {'silaba': 'JI', 'emoji': '🦒'},
    {'silaba': 'JO', 'emoji': '💍'},
    {'silaba': 'JU', 'emoji': '🧃'},
    {'silaba': 'LA', 'emoji': '🎵'},
    {'silaba': 'LE', 'emoji': '🥛'},
    {'silaba': 'LI', 'emoji': '📚'},
    {'silaba': 'LO', 'emoji': '🐺'},
    {'silaba': 'LU', 'emoji': '🌙'},
    {'silaba': 'MA', 'emoji': '👩'},
    {'silaba': 'ME', 'emoji': '🍈'},
    {'silaba': 'MI', 'emoji': '🎤'},
    {'silaba': 'MO', 'emoji': '🐒'},
    {'silaba': 'MU', 'emoji': '🐄'},
    {'silaba': 'NA', 'emoji': '👃'},
    {'silaba': 'NE', 'emoji': '❄️'},
    {'silaba': 'NI', 'emoji': '👶'},
    {'silaba': 'NO', 'emoji': '🚫'},
    {'silaba': 'NU', 'emoji': '☁️'},
    {'silaba': 'PA', 'emoji': '👨'},
    {'silaba': 'PE', 'emoji': '🐟'},
    {'silaba': 'PI', 'emoji': '🍕'},
    {'silaba': 'PO', 'emoji': '🥔'},
    {'silaba': 'PU', 'emoji': '🌸'},
    {'silaba': 'RA', 'emoji': '🐸'},
    {'silaba': 'RE', 'emoji': '👑'},
    {'silaba': 'RI', 'emoji': '😄'},
    {'silaba': 'RO', 'emoji': '🌹'},
    {'silaba': 'RU', 'emoji': '🎯'},
    {'silaba': 'SA', 'emoji': '🧂'},
    {'silaba': 'SE', 'emoji': '🌱'},
    {'silaba': 'SI', 'emoji': '💺'},
    {'silaba': 'SO', 'emoji': '☀️'},
    {'silaba': 'SU', 'emoji': '⬆️'},
    {'silaba': 'TA', 'emoji': '🥤'},
    {'silaba': 'TE', 'emoji': '🍵'},
    {'silaba': 'TI', 'emoji': '🦈'},
    {'silaba': 'TO', 'emoji': '🐂'},
    {'silaba': 'TU', 'emoji': '🌷'},
    {'silaba': 'VA', 'emoji': '🐄'},
    {'silaba': 'VE', 'emoji': '👁️'},
    {'silaba': 'VI', 'emoji': '🍷'},
    {'silaba': 'VO', 'emoji': '🎤'},
  ];

  List<Map<String, dynamic>> _preguntasActuales = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generarPreguntas();
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
    final silabasAleatorias = List<Map<String, dynamic>>.from(_silabas);
    silabasAleatorias.shuffle(_random);
    _preguntasActuales = silabasAleatorias.take(10).toList();
  }

  Map<String, dynamic> get _preguntaActualData =>
      _preguntasActuales[_preguntaActual];

  List<String> _generarOpciones() {
    final opciones = <String>[];
    opciones.add(_preguntaActualData['silaba']);

    while (opciones.length < 4) {
      final silabaAleatoria =
          _silabas[_random.nextInt(_silabas.length)]['silaba'];
      if (!opciones.contains(silabaAleatoria)) {
        opciones.add(silabaAleatoria);
      }
    }

    opciones.shuffle(_random);
    return opciones;
  }

  void _seleccionarRespuesta(String respuesta) {
    if (_preguntaRespondida) return;

    setState(() {
      _respuestaSeleccionada = respuesta;
      _preguntaRespondida = true;
    });

    if (respuesta == _preguntaActualData['silaba']) {
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
    _feedbackController.reset();
  }

  void _mostrarResultadoFinal() {
    final porcentaje =
        (_puntuacion / (_preguntasActuales.length * 10) * 100).round();
    String mensaje;
    String emoji;

    if (porcentaje >= 90) {
      mensaje = "¡EXCELENTE! 🌟";
      emoji = "🎉";
    } else if (porcentaje >= 70) {
      mensaje = "¡MUY BIEN! 👏";
      emoji = "😊";
    } else if (porcentaje >= 50) {
      mensaje = "¡BIEN! 👍";
      emoji = "😄";
    } else {
      mensaje = "¡Sigue practicando! 💪";
      emoji = "😅";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double emojiSize = screenWidth > 600 ? 80 : 60;
            double titleSize = screenWidth > 600 ? 28 : 22;
            double scoreSize = screenWidth > 600 ? 20 : 16;
            double buttonSize = screenWidth > 600 ? 18 : 14;
            
            return AlertDialog(
              backgroundColor: const Color(0xFF3D5A80),
              title: Text(
                emoji,
                style: TextStyle(fontSize: emojiSize),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mensaje,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenWidth > 600 ? 20 : 16),
                  Text(
                    'Puntuación: $_puntuacion/${_preguntasActuales.length * 10}',
                    style: TextStyle(color: Colors.white, fontSize: scoreSize),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '($porcentaje%)',
                    style: TextStyle(color: Colors.white, fontSize: scoreSize - 2),
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
                  child: Text(
                    'Jugar de nuevo',
                    style: TextStyle(color: Colors.white, fontSize: buttonSize),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Menú Principal',
                    style: TextStyle(color: Colors.white, fontSize: buttonSize),
                  ),
                ),
              ],
            );
          },
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

    if (opcion == _preguntaActualData['silaba']) {
      return Colors.green;
    } else if (opcion == _respuestaSeleccionada &&
        opcion != _preguntaActualData['silaba']) {
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

    final opciones = _generarOpciones();

    return Scaffold(
      backgroundColor: const Color(0xFF2A0944),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;
            
            // Cálculos responsivos
            double titleSize = screenWidth > 600 ? 32 : 24;
            double emojiSize = screenWidth > 600 ? 80 : 60;
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
                  '🎯 Formando Palabras 🎯',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.02),

                // Botón de audio (placeholder por ahora)
                GestureDetector(
                  onTap: () {
                    // TODO: Implementar reproducción de audio
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🔊 Audio de la palabra'),
                        duration: Duration(milliseconds: 1500),
                      ),
                    );
                  },
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.volume_up_rounded,
                            color: Colors.white,
                            size: emojiSize * 0.6,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'AUDIO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: emojiSize * 0.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                Text(
                  '¿Cuál sílaba escuchaste?',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: questionSize,
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
                      double aspectRatio = screenWidth > 600 ? 2.2 : 1.8;
                      
                      // Ajustar según la altura disponible
                      if (screenHeight < 400) {
                        aspectRatio = 2.8; // Más ancho en pantallas muy cortas
                        fontSize = 18;
                      }
                      
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                  border: _respuestaSeleccionada == opcion
                                      ? Border.all(color: Colors.white, width: 3)
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
                                        opcion == _preguntaActualData['silaba'])
                                      AnimatedBuilder(
                                        animation: _feedbackAnimation,
                                        builder: (context, child) {
                                          return Transform.scale(
                                            scale: _feedbackAnimation.value,
                                            child: Text(
                                              '✓',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: fontSize + 2,
                                                fontWeight: FontWeight.bold,
                                              ),
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
