import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../modelos/numero_letra.dart';
import '../widgets/contador_puntos_racha.dart';
import '../widgets/dialogo_racha_perdida.dart';

class JuegoNumeros extends StatefulWidget {
  const JuegoNumeros({super.key});

  @override
  State<JuegoNumeros> createState() => _JuegoNumerosState();
}

class _JuegoNumerosState extends State<JuegoNumeros>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showSuccess = false;
  bool _showError = false;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  int _numeroActualIndex = 0;
  late String _palabraSeleccionada;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _seleccionarPalabraAleatoria();
  }

  void _seleccionarPalabraAleatoria() {
    final random = Random();
    final palabras = numerosYLetras[_numeroActualIndex].palabrasRelacionadas;
    _palabraSeleccionada = palabras[random.nextInt(palabras.length)];
  }

  void _checkRespuesta(String respuesta) {
    setState(() {
      if (respuesta == _palabraSeleccionada) {
        _showSuccess = true;
        _score++;
        _streak++;
        if (_streak > _maxStreak) {
          _maxStreak = _streak;
        }
      } else {
        _showError = true;
        if (_streak > 0) {
          final rachaActual = _streak;
          Future.delayed(const Duration(milliseconds: 500), () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => DialogoRachaPerdida(racha: rachaActual),
            );
          });
        }
        _streak = 0;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showSuccess = false;
          _showError = false;
          if (_numeroActualIndex < numerosYLetras.length - 1) {
            _numeroActualIndex++;
            _seleccionarPalabraAleatoria();
          } else {
            // Mostrar diálogo de finalización
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (context) => AlertDialog(
                    backgroundColor: const Color(0xFF2A0944),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      '¡Felicitaciones!',
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Has completado el juego\nPuntuación: $_score de ${numerosYLetras.length}',
                          style: GoogleFonts.fredoka(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Menú',
                                style: GoogleFonts.fredoka(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _numeroActualIndex = 0;
                                  _score = 0;
                                  _seleccionarPalabraAleatoria();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFA500),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                'Jugar de nuevo',
                                style: GoogleFonts.fredoka(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    final numeroActual = numerosYLetras[_numeroActualIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF2A0944), const Color(0xFF3B0B54)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Back button and Score
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA500).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ContadorPuntosRacha(
                          score: _score,
                          streak: _streak,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title
              Positioned(
                top: 80,
                left: 24,
                child: Text(
                  'Números y Letras',
                  style: GoogleFonts.fredoka(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Número e imagen
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: isDesktop ? 200 : 150,
                          height: isDesktop ? 200 : 150,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: isDesktop ? 120 : 100,
                              height: isDesktop ? 120 : 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  numeroActual.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                        size: isDesktop ? 60 : 50,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              numeroActual.numero,
                              style: GoogleFonts.fredoka(
                                fontSize: isDesktop ? 72 : 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Opciones de palabras
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children:
                          numeroActual.palabrasRelacionadas.map((palabra) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 0.0),
                              duration: const Duration(milliseconds: 200),
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(0, value),
                                  child: MouseRegion(
                                    onEnter:
                                        (_) =>
                                            (context as Element)
                                                .markNeedsBuild(),
                                    onExit:
                                        (_) =>
                                            (context as Element)
                                                .markNeedsBuild(),
                                    child: GestureDetector(
                                      onTap: () => _checkRespuesta(palabra),
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: -4),
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        builder: (context, value, child) {
                                          return Transform.translate(
                                            offset: Offset(0, value),
                                            child: Container(
                                              width: isDesktop ? 160 : 140,
                                              height: isDesktop ? 80 : 70,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    const Color(0xFFFFA500),
                                                    const Color(0xFFFF8C00),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  palabra,
                                                  style: GoogleFonts.fredoka(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ], // <-- Add this closing bracket for the Column's children
                ),
              ), // Success/Error overlay
              if (_showSuccess || _showError)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: (_showSuccess ? Colors.green[100] : Colors.red[100])
                      ?.withOpacity(0.15),
                  child: Center(
                    child: Icon(
                      _showSuccess ? Icons.check_circle : Icons.close,
                      color: _showSuccess ? Colors.green[400] : Colors.red[400],
                      size: 100,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
