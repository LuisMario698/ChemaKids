import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../services/estado_app.dart';
import '../widgets/fondo_menu_abc.dart';

class JuegoSumasBasicas extends StatefulWidget {
  const JuegoSumasBasicas({super.key});

  @override
  State<JuegoSumasBasicas> createState() => _JuegoSumasBasicasState();
}

class _JuegoSumasBasicasState extends State<JuegoSumasBasicas>
    with TickerProviderStateMixin {
  late AnimationController _appearanceController;
  late AnimationController _fusionController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fusionAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _numero1 = 0;
  int _numero2 = 0;
  int _respuestaCorrecta = 0;
  List<int> _opciones = [];
  bool _respondido = false;
  bool _esRespuestaCorrecta = false;
  bool _mostrandoFusion = false;  int _puntuacion = 0;
  int _rachaActual = 0;
  
  final List<String> _objetosDisponibles = ['🦆', '🐰', '🎈', '⭐', '🌺', '🍓', '🎁', '🦋'];
  String _objetoActual = '🦆';

  @override
  void initState() {
    super.initState();
    
    _appearanceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fusionController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _appearanceController, curve: Curves.elasticOut),
    );
    
    _fusionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fusionController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _fusionController, curve: Curves.easeInOut));
    
    _generarPregunta();
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    _fusionController.dispose();
    super.dispose();
  }

  void _generarPregunta() {
    final random = Random();
    
    setState(() {
      _numero1 = random.nextInt(5) + 1; // 1-5
      _numero2 = random.nextInt(5) + 1; // 1-5
      _respuestaCorrecta = _numero1 + _numero2;
      
      // Seleccionar objeto aleatorio
      _objetoActual = _objetosDisponibles[random.nextInt(_objetosDisponibles.length)];
      
      // Generar opciones de respuesta
      _opciones = [];
      _opciones.add(_respuestaCorrecta);
      
      // Agregar dos opciones incorrectas
      while (_opciones.length < 3) {
        int opcionIncorrecta = _respuestaCorrecta + random.nextInt(5) - 2;
        if (opcionIncorrecta > 0 && 
            opcionIncorrecta != _respuestaCorrecta && 
            !_opciones.contains(opcionIncorrecta)) {
          _opciones.add(opcionIncorrecta);
        }
      }
      
      _opciones.shuffle();
      _respondido = false;
      _esRespuestaCorrecta = false;
      _mostrandoFusion = false;
    });
    
    _appearanceController.reset();
    _fusionController.reset();
    _appearanceController.forward();
  }

  void _verificarRespuesta(int respuestaSeleccionada) {
    if (_respondido) return;
      setState(() {
      _respondido = true;
      _esRespuestaCorrecta = respuestaSeleccionada == _respuestaCorrecta;
      
      if (_esRespuestaCorrecta) {
        _puntuacion += 10;
        _rachaActual++;
        _mostrandoFusion = true;
      } else {
        _rachaActual = 0;
      }
    });

    // Actualizar racha máxima si es necesario
    if (_esRespuestaCorrecta) {
      
      
      
      // Mostrar animación de fusión
      _fusionController.forward();
    }

    // Generar nueva pregunta después de un delay
    Future.delayed(Duration(seconds: _esRespuestaCorrecta ? 3 : 2), () {
      if (mounted) {
        _generarPregunta();
      }
    });
  }

  Widget _construirGrupoObjetos(int cantidad, bool esSegundoGrupo) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '$cantidad',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: esSegundoGrupo ? Colors.green[700] : Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 10),
                if (_mostrandoFusion && _esRespuestaCorrecta)
                  AnimatedBuilder(
                    animation: _fusionController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: esSegundoGrupo ? _slideAnimation : Tween<Offset>(
                          begin: const Offset(0.0, 0.0),
                          end: const Offset(1.0, 0.0),
                        ).animate(_fusionController),
                        child: Opacity(
                          opacity: 1.0 - _fusionAnimation.value,
                          child: _construirObjetosIndividuales(cantidad),
                        ),
                      );
                    },
                  )
                else
                  _construirObjetosIndividuales(cantidad),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _construirObjetosIndividuales(int cantidad) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        cantidad,
        (index) => TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Text(
                _objetoActual,
                style: const TextStyle(fontSize: 28),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _construirResultadoFusion() {
    if (!_mostrandoFusion || !_esRespuestaCorrecta) return const SizedBox.shrink();
    
    return AnimatedBuilder(
      animation: _fusionController,
      builder: (context, child) {
        return Opacity(
          opacity: _fusionAnimation.value,
          child: Transform.scale(
            scale: _fusionAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '¡Resultado!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_respuestaCorrecta',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: List.generate(
                      _respuestaCorrecta,
                      (index) => Text(
                        _objetoActual,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _construirBotonRespuesta(int numero) {
    bool esCorrecta = numero == _respuestaCorrecta;
    Color colorBoton;
    
    if (_respondido) {
      if (esCorrecta) {
        colorBoton = Colors.green;
      } else {
        colorBoton = Colors.red.withOpacity(0.3);
      }
    } else {
      colorBoton = Colors.orange;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: _respondido ? null : () => _verificarRespuesta(numero),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorBoton,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: _respondido ? 2 : 8,
          ),
          child: Text(
            '$numero',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              const Icon(Icons.add_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'Sumas Básicas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.yellow),
                    const SizedBox(width: 4),
                    Text(
                      '$_puntuacion',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Título de la pregunta
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '¿Cuántos $_objetoActual hay en total?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Ecuación visual
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Primer grupo
                    Expanded(child: _construirGrupoObjetos(_numero1, false)),
                    
                    // Símbolo de suma
                    Container(
                      width: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '+',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Segundo grupo
                    Expanded(child: _construirGrupoObjetos(_numero2, true)),
                    
                    // Símbolo igual
                    Container(
                      width: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '=',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Resultado (aparece con animación si es correcto)
                    Expanded(child: _construirResultadoFusion()),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Ecuación numérica
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '$_numero1 + $_numero2 = ?',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Botones de respuesta
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Elige la respuesta correcta:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: _opciones.map((numero) => _construirBotonRespuesta(numero)).toList(),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Feedback
              if (_respondido)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _esRespuestaCorrecta ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _esRespuestaCorrecta ? Icons.check_circle : Icons.cancel,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _esRespuestaCorrecta 
                          ? '¡Perfecto! 🎉' 
                          : 'Inténtalo de nuevo 💪',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Información de racha
              if (_rachaActual > 1)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        'Racha: $_rachaActual',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}