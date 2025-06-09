import 'package:flutter/material.dart';
import 'dart:math';

/// Widget que crea un fondo animado para el menú basado en el diseño del juego ABC
/// 
/// Características:
/// - Gradiente púrpura rotativo como en el juego ABC
/// - Círculos animados de diferentes tamaños 
/// - Efecto de profundidad y movimiento
/// - Optimizado para uso como fondo de pantalla
class FondoMenuABC extends StatefulWidget {
  /// Widget hijo que se renderiza sobre el fondo animado
  final Widget child;
  
  /// Duración de la animación completa (por defecto 8 segundos)
  final Duration duracion;
  
  /// Intensidad de la animación (0.0 a 1.0)
  final double intensidad;

  const FondoMenuABC({
    super.key,
    required this.child,
    this.duracion = const Duration(seconds: 8),
    this.intensidad = 1.0,
  });

  @override
  State<FondoMenuABC> createState() => _FondoMenuABCState();
}

class _FondoMenuABCState extends State<FondoMenuABC>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duracion,
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo base con gradiente rotativo estilo ABC
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [
                      Color(0xFF2A0944), // Dark Purple del ABC
                      Color(0xFF3B0B54), // Lighter Purple del ABC
                      Color(0xFF2A0944), // Regreso al dark purple
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    transform: GradientRotation(
                      _rotationAnimation.value * widget.intensidad,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Círculos animados de fondo estilo ABC
          ...List.generate(5, (index) {
            final size = (index + 1) * 80.0;
            final speed = (index + 1).toDouble();
            final opacity = (0.4 - (index * 0.05)).clamp(0.0, 1.0);
            
            return Positioned(
              top: -size / 2,
              right: (index % 2 == 0) ? -size / 2 : null,
              left: (index % 2 == 1) ? -size / 2 : null,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * speed * widget.intensidad,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.purple.withOpacity(opacity * 0.6),
                            Colors.purple.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          
          // Círculos inferiores para balance visual
          ...List.generate(3, (index) {
            final size = (index + 2) * 60.0;
            final speed = -(index + 1).toDouble() * 0.5; // Rotación inversa
            final opacity = (0.3 - (index * 0.05)).clamp(0.0, 1.0);
            
            return Positioned(
              bottom: -size / 3,
              left: (index % 2 == 0) ? -size / 3 : null,
              right: (index % 2 == 1) ? -size / 3 : null,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * speed * widget.intensidad,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.deepPurple.withOpacity(opacity * 0.4),
                            Colors.deepPurple.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          
          // Elementos decorativos flotantes
          ...List.generate(8, (index) {
            final random = Random(index);
            final size = 15.0 + random.nextDouble() * 25.0;
            final left = random.nextDouble() * 0.8;
            final top = random.nextDouble() * 0.8;
            final delay = random.nextDouble() * 2.0;
            
            return Positioned(
              left: MediaQuery.of(context).size.width * left,
              top: MediaQuery.of(context).size.height * top,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final animationValue = (_controller.value + delay) % 1.0;
                  final offset = sin(animationValue * 2 * pi) * 20 * widget.intensidad;
                  final opacity = (sin(animationValue * pi) * 0.3 + 0.1).clamp(0.0, 1.0);
                  
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0xFFFFA5A5).withOpacity(opacity), // Rosa del ABC
                            Color(0xFFFF7676).withOpacity(opacity * 0.5), // Rosa coral del ABC
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.7, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          
          // Contenido principal
          widget.child,
        ],
      ),
    );
  }
}

/// Versión simplificada del fondo para uso en widgets más pequeños
class FondoMenuABCMini extends StatefulWidget {
  final Widget child;
  final double altura;
  final double anchura;

  const FondoMenuABCMini({
    super.key,
    required this.child,
    this.altura = 200,
    this.anchura = double.infinity,
  });

  @override
  State<FondoMenuABCMini> createState() => _FondoMenuABCMiniState();
}

class _FondoMenuABCMiniState extends State<FondoMenuABCMini>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.altura,
      width: widget.anchura,
      child: Stack(
        children: [
          // Fondo gradiente
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [
                      Color(0xFF2A0944),
                      Color(0xFF3B0B54),
                      Color(0xFF2A0944),
                    ],
                    transform: GradientRotation(_controller.value * 2 * pi),
                  ),
                ),
              );
            },
          ),
          
          // Un círculo animado simple
          Positioned(
            top: -30,
            right: -30,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.purple.withOpacity(0.3),
                          Colors.purple.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Contenido
          widget.child,
        ],
      ),
    );
  }
}

/// Utilidades para crear efectos ABC en otros widgets
class EfectosABC {
  /// Colores principales del tema ABC
  static const List<Color> coloresPrincipales = [
    Color(0xFF2A0944), // Dark Purple
    Color(0xFF3B0B54), // Lighter Purple
  ];
  
  static const List<Color> coloresSecundarios = [
    Color(0xFFFFA5A5), // Rosa
    Color(0xFFFF7676), // Rosa coral
    Color(0xFFE0D3F5), // Lila claro
  ];
  
  /// Crea un gradiente estilo ABC
  static LinearGradient crearGradienteABC({
    double rotacion = 0.0,
    List<Color>? coloresCustom,
  }) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: coloresCustom ?? coloresPrincipales,
      transform: GradientRotation(rotacion),
    );
  }
  
  /// Crea un círculo decorativo estilo ABC
  static Widget crearCirculoABC({
    required double tamano,
    required double opacidad,
    Color? color,
  }) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            (color ?? Colors.purple).withOpacity(opacidad),
            (color ?? Colors.purple).withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}
