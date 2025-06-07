import 'package:flutter/material.dart';

import 'package:chemakids/modelos/question_que_es.dart';
import '../widgets/boton_animado.dart';
import '../widgets/dialogo_racha_perdida.dart';
import '../widgets/contador_puntos_racha.dart';

class JuegoQueEs extends StatefulWidget {
  const JuegoQueEs({super.key});

  @override
  State<JuegoQueEs> createState() => _JuegoQueEsState();
}

class _JuegoQueEsState extends State<JuegoQueEs>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showSuccess = false;
  bool _showError = false;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAnswer(bool isCorrect) {
    setState(() {
      if (isCorrect) {
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

          if (isCorrect) {
            if (_currentQuestionIndex < questions.length - 1) {
              _currentQuestionIndex++;
            } else {
              // Show completion dialog
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Has completado el juego\nPuntuación: $_score de ${questions.length}',
                            style: const TextStyle(
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
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _currentQuestionIndex = 0;
                                    _score = 0;
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
                                  style: const TextStyle(
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
          }
        });
      }
    });
  }

  Widget _buildOptionButton({required String text, required bool isCorrect}) {
    return BotonAnimado(
      onTap: () => _handleAnswer(isCorrect),
      child: Container(
        width: 160,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFA500), // Orange
              const Color(0xFFFF8C00), // Dark Orange
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 51), // 0.2 * 255 = 51
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    final currentQuestion = questions[_currentQuestionIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2A0944), // Dark Purple
              const Color(0xFF3B0B54), // Lighter Purple
            ],
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
                      ContadorPuntosRacha(score: _score, streak: _streak),
                    ],
                  ),
                ),
              ), // Title
              Positioned(
                top: 80,
                left: 24,
                child: Text(
                  '¿Qué es?',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Main image
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Transform.scale(
                    scale: _showSuccess ? 1.1 : 1.0,
                    child: Container(
                      width: isDesktop ? 400 : 300,
                      height: isDesktop ? 400 : 300,
                      decoration: BoxDecoration(
                        color:
                            _showSuccess
                                ? Colors.green[100]?.withOpacity(0.15)
                                : _showError
                                ? Colors.red[100]?.withOpacity(0.15)
                                : Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_showSuccess
                                    ? Colors.green[400]
                                    : _showError
                                    ? Colors.red[400]
                                    : Colors.white)!
                                .withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.network(
                          currentQuestion.imageUrl,
                          width: isDesktop ? 300 : 200,
                          height: isDesktop ? 300 : 200,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(
                                Icons.image_not_supported,
                                color: Colors.red,
                                size: isDesktop ? 200 : 150,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Option buttons - Randomize the order
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (DateTime.now().millisecondsSinceEpoch % 2 == 0) ...[
                      _buildOptionButton(
                        text: currentQuestion.wrongAnswer,
                        isCorrect: false,
                      ),
                      _buildOptionButton(
                        text: currentQuestion.correctAnswer,
                        isCorrect: true,
                      ),
                    ] else ...[
                      _buildOptionButton(
                        text: currentQuestion.correctAnswer,
                        isCorrect: true,
                      ),
                      _buildOptionButton(
                        text: currentQuestion.wrongAnswer,
                        isCorrect: false,
                      ),
                    ],
                  ],
                ),
              ),

              // Success/Error overlay
              if (_showSuccess || _showError)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: (_showSuccess ? Colors.green : Colors.red).withValues(
                    alpha: 26,
                  ),
                  child: Center(
                    child: Icon(
                      _showSuccess ? Icons.check_circle : Icons.close,
                      color: _showSuccess ? Colors.green : Colors.red,
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
