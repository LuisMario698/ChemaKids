import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../servicios/estado_app.dart';
import '../widgets/nivel_card.dart';
import '../widgets/titulo_pagina.dart';

class PantallaMenu extends StatelessWidget {
  const PantallaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<EstadoApp>().usuario;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo colorido y decorativo
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB2EBF2),
                  Color(0xFFFFF59D),
                  Color(0xFFFFB0B0),
                  Color(0xFFA5D6A7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Burbujas decorativas
          Positioned(
            top: 40,
            left: 20,
            child: _burbuja(60, Colors.pinkAccent.withOpacity(0.18)),
          ),
          Positioned(
            top: 120,
            right: 30,
            child: _burbuja(40, Colors.amber.withOpacity(0.18)),
          ),
          Positioned(
            bottom: 80,
            left: 60,
            child: _burbuja(50, Colors.lightBlue.withOpacity(0.18)),
          ),
          Positioned(
            bottom: 30,
            right: 40,
            child: _burbuja(70, Colors.greenAccent.withOpacity(0.18)),
          ),
          // Personajes decorativos (emojis)
          Positioned(
            top: 10,
            right: 10,
            child: Text('🦄', style: TextStyle(fontSize: 48)),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text('🐻', style: TextStyle(fontSize: 48)),
          ),
          Positioned(
            bottom: 10,
            right: 60,
            child: Text('🐸', style: TextStyle(fontSize: 40)),
          ),
          // Contenido principal
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TituloPagina(
                  texto: '¡Hola ${usuario.nombre}!',
                  fontSize: isDesktop ? 48 : 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Text(
                    '¡Elige un juego para aprender y divertirte!',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.deepPurple[700],
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.6),
                          blurRadius: 6,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (isDesktop) {
                        return Center(
                          child: SizedBox(
                            width: 600,
                            child: _buildNivelGrid(context, usuario),
                          ),
                        );
                      }
                      return _buildNivelGrid(context, usuario);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Cambia la lista a un GridView para hacerlo más interactivo y visual
  Widget _buildNivelGrid(BuildContext context, dynamic usuario) {
    final niveles = [
      NivelCard(
        nivel: 1,
        titulo: 'ABC',
        color: const Color(0xFFE0D3F5),
        onTap: () => Navigator.pushNamed(context, '/abc'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/alphabet-cute-cartoon-vector-illustration_480744-381.jpg',
      ),
      NivelCard(
        nivel: 2,
        titulo: 'Sílabas desde cero',
        color: const Color(0xFFFFE082),
        onTap: () => Navigator.pushNamed(context, '/silabasdesdecero'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/abc-blocks-cute-cartoon-vector-illustration_480744-386.jpg',
      ),
      NivelCard(
        nivel: 3,
        titulo: 'Sílabas Mágicas',
        color: const Color(0xFFFFB0B0),
        onTap: () => Navigator.pushNamed(context, '/silabas'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/book-education-cute-cartoon-vector-illustration_480744-382.jpg',
      ),
      NivelCard(
        nivel: 4,
        titulo: 'Rima Rima',
        color: const Color(0xFF90CAF9),
        onTap: () => Navigator.pushNamed(context, '/rimas'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/poetry-book-cute-cartoon-vector-illustration_480744-383.jpg',
      ),
      NivelCard(
        nivel: 5,
        titulo: '¿Qué es?',
        color: const Color(0xFFFFCC80),
        onTap: () => Navigator.pushNamed(context, '/que-es'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/cute-toy-car-cartoon-vector-illustration_480744-357.jpg',
      ),
      NivelCard(
        nivel: 6,
        titulo: 'Números y Letras',
        color: const Color(0xFFA5D6A7),
        onTap: () => Navigator.pushNamed(context, '/numeros'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/numbers-letters-cute-cartoon-vector-illustration_480744-384.jpg',
      ),
      NivelCard(
        nivel: 7,
        titulo: 'Sumas y Restas',
        color: const Color(0xFFFFF59D),
        onTap: () => Navigator.pushNamed(context, '/sumas-restas'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/math-addition-subtraction-cute-cartoon-vector-illustration_480744-390.jpg',
      ),
      NivelCard(
        nivel: 8,
        titulo: 'Formar Palabras',
        color: const Color(0xFFB2EBF2),
        onTap: () => Navigator.pushNamed(context, '/formar-palabras'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/word-game-cute-cartoon-vector-illustration_480744-387.jpg',
      ),
      NivelCard(
        nivel: 9,
        titulo: 'Sonidos y Palabras',
        color: const Color(0xFFFFAB91),
        onTap: () => Navigator.pushNamed(context, '/animales'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/animals-words-cute-cartoon-vector-illustration_480744-385.jpg',
      ),
      NivelCard(
        nivel: 10,
        titulo: 'Memorama',
        color: const Color(0xFFD1C4E9),
        onTap: () => Navigator.pushNamed(context, '/memorama'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/memory-game-cute-cartoon-vector-illustration_480744-388.jpg',
      ),
      NivelCard(
        nivel: 11,
        titulo: 'Colores',
        color: const Color(0xFFFFF176),
        onTap: () => Navigator.pushNamed(context, '/colores'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/colors-cute-cartoon-vector-illustration_480744-389.jpg',
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 18,
        childAspectRatio: 0.98,
      ),
      itemCount: niveles.length,
      itemBuilder: (context, index) {
        return AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTapDown: (_) => Feedback.forTap(context),
            child: niveles[index],
          ),
        );
      },
    );
  }

  // Widget para burbujas decorativas
  Widget _burbuja(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
