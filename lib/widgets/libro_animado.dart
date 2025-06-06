import 'package:flutter/material.dart';
import 'dart:math' as math;

class LibroAnimado extends StatefulWidget {
  const LibroAnimado({super.key});

  @override
  State<LibroAnimado> createState() => _LibroAnimadoState();
}

class _LibroAnimadoState extends State<LibroAnimado> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late List<Animation<double>> _letrasAnimaciones;
  final List<Color> _coloresLetras = [
    const Color(0xFF76FF03), // Verde brillante
    const Color(0xFFFF4081), // Rosa
    const Color(0xFF00B0FF), // Azul brillante
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Crear animaciones para cada letra con diferentes offsets
    _letrasAnimaciones = List.generate(3, (index) {
      return Tween<double>(
        begin: -15.0,
        end: 15.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.2,
          0.6 + index * 0.2,
          curve: Curves.easeInOut,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Libro base
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Líneas del libro
                      ...List.generate(5, (index) {
                        return Positioned(
                          left: 20,
                          right: 20,
                          top: 30 + (index * 20),
                          child: Container(
                            height: 2,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
          // Letras flotantes
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _letrasAnimaciones[index],
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -40.0 + (index * 40),
                    _letrasAnimaciones[index].value + (index * 5),
                  ),
                  child: Transform.rotate(
                    angle: math.pi / 12 * _letrasAnimaciones[index].value / 15,
                    child: Text(
                      ['A', 'B', 'C'][index],
                      style: TextStyle(
                        color: _coloresLetras[index],
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          // Estrellas
          ...List.generate(5, (index) {
            return Positioned(
              top: 20.0 + (index * 30),
              left: 60.0 + (index * 30) * math.cos(index * math.pi / 3),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + 0.2 * math.sin(_controller.value * math.pi + index),
                    child: Icon(
                      Icons.star,
                      size: 20,
                      color: Colors.amber.withOpacity(0.6),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
