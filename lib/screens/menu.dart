import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/estado_app.dart';
import '../widgets/nivel_card.dart';
import '../widgets/titulo_pagina.dart';
import '../widgets/fondo_menu_abc.dart';

class PantallaMenu extends StatelessWidget {
  const PantallaMenu({super.key});
  @override
  Widget build(BuildContext context) {
    final estadoApp = context.watch<EstadoApp>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return FondoMenuABC(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título y botón de cerrar sesión
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TituloPagina(
                      texto: '¡Hola ${estadoApp.nombreUsuario}!',
                      fontSize: isDesktop ? 48 : 40,
                    ),
                  ), // Botón de inicio
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _regresarInicio(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.home, color: Colors.white, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              'Inicio',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                '¡Elige un juego para aprender y divertirte!',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
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
                        child: _buildNivelGrid(context, estadoApp),
                      ),
                    );
                  }
                  return _buildNivelGrid(context, estadoApp);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cambia la lista a un GridView para hacerlo más interactivo y visual
  Widget _buildNivelGrid(BuildContext context, EstadoApp estadoApp) {
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
        nivel: 1,
        titulo: 'ABC Audio',
        color: const Color(0xFFB39DDB),
        onTap: () => Navigator.pushNamed(context, '/abc-audio'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/headphones-music-cute-cartoon-vector-illustration_480744-395.jpg',
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
        nivel: 2,
        titulo: 'Sílabas Audio',
        color: const Color(0xFF9C27B0),
        onTap: () => Navigator.pushNamed(context, '/silabas-audio'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/sound-speaker-cute-cartoon-vector-illustration_480744-392.jpg',
      ),
      NivelCard(
        nivel: 3,
        titulo: 'Completar Palabras',
        color: const Color(0xFFFFB0B0),
        onTap: () => Navigator.pushNamed(context, '/silabas'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/book-education-cute-cartoon-vector-illustration_480744-382.jpg',
      ),
      NivelCard(
        nivel: 3,
        titulo: 'Formar Palabras',
        color: const Color(0xFFB2EBF2),
        onTap: () => Navigator.pushNamed(context, '/formar-palabras'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/word-game-cute-cartoon-vector-illustration_480744-387.jpg',
      ),
      NivelCard(
        nivel: 3,
        titulo: 'Memorama',
        color: const Color(0xFFD1C4E9),
        onTap: () => Navigator.pushNamed(context, '/memorama'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/memory-game-cute-cartoon-vector-illustration_480744-388.jpg',
      ),
      NivelCard(
        nivel: 3,
        titulo: 'Colores',
        color: const Color(0xFFFFF176),
        onTap: () => Navigator.pushNamed(context, '/colores'),
        bloqueado: false,
        imagenUrl:
            'https://img.freepik.com/premium-vector/colors-cute-cartoon-vector-illustration_480744-389.jpg',
      ),

      // NivelCard(
      //   nivel: 6,
      //   titulo: 'Rima Rima',
      //   color: const Color(0xFF90CAF9),
      //   onTap: () => Navigator.pushNamed(context, '/rimas'),
      //   bloqueado: false,
      //   imagenUrl:
      //       'https://img.freepik.com/premium-vector/poetry-book-cute-cartoon-vector-illustration_480744-383.jpg',
      // ),
      // NivelCard(
      //   nivel: 7,
      //   titulo: '¿Qué es?',
      //   color: const Color(0xFFFFCC80),
      //   onTap: () => Navigator.pushNamed(context, '/que-es'),
      //   bloqueado: false,
      //   imagenUrl:
      //       'https://img.freepik.com/premium-vector/cute-toy-car-cartoon-vector-illustration_480744-357.jpg',
      // ),
      //   NivelCard(
      //   nivel: 8,
      //   titulo: 'Números y Letras',
      //   color: const Color(0xFFA5D6A7),
      //   onTap: () => Navigator.pushNamed(context, '/numeros'),
      //   bloqueado: false,
      //   imagenUrl:
      //       'https://img.freepik.com/premium-vector/numbers-letters-cute-cartoon-vector-illustration_480744-384.jpg',
      // ),
      // NivelCard(
      //   nivel: 9,
      //   titulo: 'Sumas y Restas',
      //   color: const Color(0xFFFFF59D),
      //   onTap: () => Navigator.pushNamed(context, '/sumas-restas'),
      //   bloqueado: false,
      //   imagenUrl:
      //       'https://img.freepik.com/premium-vector/math-addition-subtraction-cute-cartoon-vector-illustration_480744-390.jpg',
      // ),
      // NivelCard(
      //   nivel: 11,
      //   titulo: 'Sonidos y Palabras',
      //   color: const Color(0xFFFFAB91),
      //   onTap: () => Navigator.pushNamed(context, '/animales'),
      //   bloqueado: false,
      //   imagenUrl:
      //       'https://img.freepik.com/premium-vector/animals-words-cute-cartoon-vector-illustration_480744-385.jpg',
      // ),
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

  // Método para regresar al inicio
  void _regresarInicio(BuildContext context) {
    // Navegar de vuelta a la pantalla de inicio
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
