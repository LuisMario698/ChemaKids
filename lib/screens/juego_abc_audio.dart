import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/tema_juego_chemakids.dart';
import '../widgets/boton_animado.dart';

class JuegoAbcAudio extends StatefulWidget {
  const JuegoAbcAudio({Key? key}) : super(key: key);

  @override
  State<JuegoAbcAudio> createState() => _JuegoAbcAudioState();
}

class _JuegoAbcAudioState extends State<JuegoAbcAudio>
    with TickerProviderStateMixin {
  final List<String> _letras = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  String _letraActual = '';
  List<String> _opciones = [];
  bool _mostrandoLetra = false;
  bool _puedeSeleccionar = false;
  bool _respondido = false;
  bool _respuestaCorrecta = false;
  int _puntos = 0;
  int _racha = 0;
  int _maxRacha = 0;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticInOut),
    );

    _waveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    _nuevaRonda();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _nuevaRonda() {
    setState(() {
      _letraActual = _letras[_random.nextInt(_letras.length)];
      _mostrandoLetra = false;
      _puedeSeleccionar = false;
      _respondido = false;
      _respuestaCorrecta = false;
    });

    _generarOpciones();
  }

  void _generarOpciones() {
    _opciones.clear();
    _opciones.add(_letraActual);

    // Agregar 3 letras incorrectas
    while (_opciones.length < 4) {
      String letraAleatoria = _letras[_random.nextInt(_letras.length)];
      if (!_opciones.contains(letraAleatoria)) {
        _opciones.add(letraAleatoria);
      }
    }

    _opciones.shuffle(_random);
  }

  void _reproducirSonido() async {
    setState(() {
      _mostrandoLetra = true;
      _puedeSeleccionar = false;
    });

    // Animación de pulso y ondas
    _pulseController.repeat(reverse: true);
    _waveController.repeat();

    // Simular duración del audio (3 segundos)
    await Future.delayed(const Duration(seconds: 3));

    _pulseController.stop();
    _waveController.stop();

    setState(() {
      _mostrandoLetra = false;
      _puedeSeleccionar = true;
    });
  }

  void _seleccionarLetra(String letra) {
    if (!_puedeSeleccionar || _respondido) return;

    setState(() {
      _respondido = true;
      _respuestaCorrecta = letra == _letraActual;

      if (_respuestaCorrecta) {
        _puntos += 10;
        _racha++;
        if (_racha > _maxRacha) {
          _maxRacha = _racha;
        }
      } else {
        _racha = 0;
      }
    });

    // Mostrar resultado por 2 segundos antes de continuar
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nuevaRonda();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlantillaJuegoChemaKids(
      titulo: 'ABC Audio',
      icono: Icons.volume_up_rounded,
      contenido: Column(
        children: [
          // Contador de puntos y racha
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(height: 4),
                    Text(
                      '$_puntos',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_racha',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.yellow,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_maxRacha',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Botón de reproducir sonido
          if (!_mostrandoLetra && !_puedeSeleccionar && !_respondido)
            BotonAnimado(
              onTap: _reproducirSonido,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),

          // Indicador visual de sonido
          if (_mostrandoLetra)
            Stack(
              alignment: Alignment.center,
              children: [
                // Ondas de sonido animadas
                AnimatedBuilder(
                  animation: _waveAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 200 + (_waveAnimation.value * 100),
                      height: 200 + (_waveAnimation.value * 100),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue.withOpacity(
                            0.3 - _waveAnimation.value * 0.3,
                          ),
                          width: 3,
                        ),
                      ),
                    );
                  },
                ),

                // Indicador de audio sin mostrar la letra
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

          // Texto de instrucción
          if (_mostrandoLetra)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                '🔊 Escucha atentamente...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          if (_puedeSeleccionar && !_respondido)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                '¿Qué letra sonó?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const Spacer(),

          // Opciones de letras
          if (_puedeSeleccionar || _respondido)
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children:
                    _opciones.map((letra) {
                      bool esCorrecta = letra == _letraActual;
                      bool seleccionada =
                          _respondido &&
                          (esCorrecta ||
                              (!_respuestaCorrecta &&
                                  letra == _opciones.first));

                      Color colorBoton = Colors.white;
                      if (_respondido) {
                        if (esCorrecta) {
                          colorBoton = Colors.green;
                        } else if (seleccionada && !_respuestaCorrecta) {
                          colorBoton = Colors.red;
                        }
                      }

                      return BotonAnimado(
                        onTap: _respondido 
                            ? () {} 
                            : () => _seleccionarLetra(letra),
                        child: Container(
                          width: 80,
                          height: 105,
                          decoration: BoxDecoration(
                            color: colorBoton,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: colorBoton.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              letra,
                              style: TextStyle(
                                color:
                                    _respondido && colorBoton != Colors.white
                                        ? Colors.white
                                        : Colors.deepPurple,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

          // Mensaje de resultado
          if (_respondido)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _respuestaCorrecta ? Icons.check_circle : Icons.cancel,
                    color: _respuestaCorrecta ? Colors.green : Colors.red,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _respuestaCorrecta ? '¡Correcto!' : 'Era: $_letraActual',
                    style: TextStyle(
                      color: _respuestaCorrecta ? Colors.green : Colors.red,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          const Spacer(),
        ],
      ),
    );
  }
}
