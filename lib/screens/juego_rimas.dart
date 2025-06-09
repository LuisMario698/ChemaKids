import 'package:flutter/material.dart';

import 'dart:math' show Random;
import '../widgets/boton_animado.dart';
import '../widgets/contador_puntos_racha.dart';
import '../widgets/dialogo_racha_perdida.dart';
import '../widgets/dialogo_victoria.dart';
import '../widgets/tema_juego_chemakids.dart';

class JuegoRimas extends StatefulWidget {
  const JuegoRimas({super.key});

  @override
  State<JuegoRimas> createState() => _JuegoRimasState();
}

class _JuegoRimasState extends State<JuegoRimas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showSuccess = false;
  bool _showError = false;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  final Random _random = Random();
  late Map<String, dynamic> _rimaActual;
  late List<String> _opciones;
  final List<int> _rimasUsadas = [];
  static const int _puntajeMaximo = 10;

  final List<Map<String, dynamic>> _rimas = [
    {
      'palabra': 'GATO',
      'rima': 'PATO',
      'imagen1':
          'https://img.freepik.com/premium-vector/cat-cute-cartoon-vector-illustration_480744-375.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/duck-cute-cartoon-vector-illustration_480744-376.jpg',
      'opciones': ['PATO', 'PERRO', 'CASA'],
    },
    {
      'palabra': 'OSO',
      'rima': 'POZO',
      'imagen1':
          'https://img.freepik.com/premium-vector/bear-cute-cartoon-vector-illustration_480744-377.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/well-cute-cartoon-vector-illustration_480744-378.jpg',
      'opciones': ['POZO', 'LAGO', 'CIELO'],
    },
    {
      'palabra': 'SILLA',
      'rima': 'ARDILLA',
      'imagen1':
          'https://img.freepik.com/premium-vector/chair-cute-cartoon-vector-illustration_480744-379.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/squirrel-cute-cartoon-vector-illustration_480744-380.jpg',
      'opciones': ['ARDILLA', 'MESA', 'CAMA'],
    },
    {
      'palabra': 'LUNA',
      'rima': 'CUNA',
      'imagen1':
          'https://img.freepik.com/premium-vector/moon-cute-cartoon-vector-illustration_480744-381.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/crib-cute-cartoon-vector-illustration_480744-382.jpg',
      'opciones': ['CUNA', 'NUBE', 'SOL'],
    },
    {
      'palabra': 'FLOR',
      'rima': 'TAMBOR',
      'imagen1':
          'https://img.freepik.com/premium-vector/flower-cute-cartoon-vector-illustration_480744-383.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/drum-cute-cartoon-vector-illustration_480744-384.jpg',
      'opciones': ['TAMBOR', 'MACETA', 'JARDÍN'],
    },
    {
      'palabra': 'PERA',
      'rima': 'TIJERA',
      'imagen1':
          'https://img.freepik.com/premium-vector/pear-cute-cartoon-vector-illustration_480744-385.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/scissors-cute-cartoon-vector-illustration_480744-386.jpg',
      'opciones': ['TIJERA', 'MANZANA', 'PLÁTANO'],
    },
    {
      'palabra': 'PAN',
      'rima': 'IMÁN',
      'imagen1':
          'https://img.freepik.com/premium-vector/bread-cute-cartoon-vector-illustration_480744-387.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/magnet-cute-cartoon-vector-illustration_480744-388.jpg',
      'opciones': ['IMÁN', 'LECHE', 'QUESO'],
    },
    {
      'palabra': 'RATÓN',
      'rima': 'BALÓN',
      'imagen1':
          'https://img.freepik.com/premium-vector/mouse-cute-cartoon-vector-illustration_480744-389.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/ball-cute-cartoon-vector-illustration_480744-390.jpg',
      'opciones': ['BALÓN', 'QUESO', 'GATO'],
    },
    {
      'palabra': 'PINO',
      'rima': 'PEPINO',
      'imagen1':
          'https://img.freepik.com/premium-vector/pine-tree-cute-cartoon-vector-illustration_480744-391.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/cucumber-cute-cartoon-vector-illustration_480744-392.jpg',
      'opciones': ['PEPINO', 'ÁRBOL', 'HOJA'],
    },
    {
      'palabra': 'ROSA',
      'rima': 'MARIPOSA',
      'imagen1':
          'https://img.freepik.com/premium-vector/rose-cute-cartoon-vector-illustration_480744-393.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/butterfly-cute-cartoon-vector-illustration_480744-394.jpg',
      'opciones': ['MARIPOSA', 'TULIPÁN', 'GIRASOL'],
    },
    {
      'palabra': 'TAZA',
      'rima': 'CASA',
      'imagen1':
          'https://img.freepik.com/premium-vector/cup-cute-cartoon-vector-illustration_480744-395.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/house-cute-cartoon-vector-illustration_480744-396.jpg',
      'opciones': ['CASA', 'PLATO', 'VASO'],
    },
    {
      'palabra': 'CAMA',
      'rima': 'RAMA',
      'imagen1':
          'https://img.freepik.com/premium-vector/bed-cute-cartoon-vector-illustration_480744-397.jpg',
      'imagen2':
          'https://img.freepik.com/premium-vector/branch-cute-cartoon-vector-illustration_480744-398.jpg',
      'opciones': ['RAMA', 'SILLA', 'MESA'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _nuevaPregunta();
  }

  void _nuevaPregunta() {
    if (_rimasUsadas.length == _rimas.length) {
      _rimasUsadas.clear();
    }

    List<int> rimasDisponibles =
        List.generate(
          _rimas.length,
          (i) => i,
        ).where((i) => !_rimasUsadas.contains(i)).toList();

    int indiceRima = rimasDisponibles[_random.nextInt(rimasDisponibles.length)];
    _rimasUsadas.add(indiceRima);

    setState(() {
      _rimaActual = _rimas[indiceRima];
      _opciones = List<String>.from(_rimaActual['opciones'])..shuffle(_random);
    });
  }

  void _checkRespuesta(String respuesta) {
    setState(() {
      if (respuesta == _rimaActual['rima']) {
        _showSuccess = true;
        _score++;
        _streak++;
        if (_streak > _maxStreak) {
          _maxStreak = _streak;
        }

        if (_score >= _puntajeMaximo) {
          Future.delayed(Duration(milliseconds: 500), () {
            if (!mounted) return;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (context) => DialogoVictoria(
                    score: _score,
                    maxStreak: _maxStreak,
                    onPlayAgain: () {
                      setState(() {
                        _score = 0;
                        _streak = 0;
                        _maxStreak = 0;
                        _rimasUsadas.clear();
                        _nuevaPregunta();
                      });
                      Navigator.of(context).pop();
                    },
                    onMenu: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
            );
          });
          return;
        }
      } else {
        _showError = true;
        if (_streak >= 2) {
          final rachaActual = _streak;
          Future.delayed(Duration(milliseconds: 500), () {
            if (!mounted) return;
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

    Future.delayed(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _showSuccess = false;
        _showError = false;
        _nuevaPregunta();
      });
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

    return PlantillaJuegoChemaKids(
      titulo: '¿Qué rima con...?',
      icono: Icons.music_note,
      contenido: Stack(
        children: [
          // Score overlay
          Positioned(
            top: 16,
            right: 16,
            child: ContadorPuntosRacha(score: _score, streak: _streak),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Palabra a rimar
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA500),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFA500).withValues(alpha: 77),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        _rimaActual['imagen1'],
                        width: isDesktop ? 150 : 120,
                        height: isDesktop ? 150 : 120,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 80,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _rimaActual['palabra'],
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Opciones de rima
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children:
                      _opciones.map((opcion) {
                        return BotonAnimado(
                          onTap: () => _checkRespuesta(opcion),
                          child: Container(
                            width: isDesktop ? 160 : 140,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 77),
                                  Colors.white.withValues(alpha: 26),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 51),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                opcion,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),

          // Success/Error overlay
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
    );
  }
}
