import 'package:flutter/material.dart';

class DialogoVictoria extends StatelessWidget {
  final int score;
  final int maxStreak;
  final VoidCallback onPlayAgain;
  final VoidCallback onMenu;

  const DialogoVictoria({
    super.key,
    required this.score,
    required this.maxStreak,
    required this.onPlayAgain,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2A0944), Color(0xFF3B0B54)],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.amber, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emojis de celebración con animación
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.5, end: 1.0),
              duration: const Duration(milliseconds: 800),
              builder:
                  (context, value, child) => Transform.scale(
                    scale: value,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('🎉', style: TextStyle(fontSize: 60)),
                        Text('🏆', style: TextStyle(fontSize: 80)),
                        Text('✨', style: TextStyle(fontSize: 60)),
                      ],
                    ),
                  ),
            ),
            const SizedBox(height: 20),
            // Puntuación grande
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(26), // 0.1 opacity
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$score',
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 70),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Mostrar la racha máxima
                  if (maxStreak == 10) ...[
                    // Racha perfecta con efectos especiales
                    const SizedBox(height: 20),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      builder:
                          (context, value, child) => Transform.scale(
                            scale: value,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF6B00),
                                    Color(0xFFFF3800),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF6B00,
                                    ).withAlpha(100),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Efectos de fondo mejorados
                                  ...List.generate(8, (index) {
                                    final random = index * 1.2;
                                    return TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                        begin: 0.0,
                                        end: 1.0,
                                      ),
                                      duration: Duration(
                                        milliseconds: 800 + (index * 100),
                                      ),
                                      builder:
                                          (context, val, child) => Positioned(
                                            left: 20.0 + random * 40,
                                            top: random * 4,
                                            child: Transform.scale(
                                              scale: val,
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.yellow
                                                          .withAlpha(150),
                                                      blurRadius: 25,
                                                      spreadRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                    );
                                  }), // Contenido principal mejorado
                                  Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 25,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(30),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withAlpha(100),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withAlpha(30),
                                              blurRadius: 15,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TweenAnimationBuilder<double>(
                                              tween: Tween(
                                                begin: 0.5,
                                                end: 1.0,
                                              ),
                                              duration: const Duration(
                                                milliseconds: 500,
                                              ),
                                              builder:
                                                  (
                                                    context,
                                                    val,
                                                    child,
                                                  ) => Transform.scale(
                                                    scale: val,
                                                    child: Text(
                                                      '10',
                                                      style: const TextStyle(
                                                        fontSize: 60,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        shadows: [
                                                          Shadow(
                                                            color:
                                                                Colors.orange,
                                                            blurRadius: 10,
                                                            offset: Offset(
                                                              0,
                                                              2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                            const SizedBox(width: 10),
                                            TweenAnimationBuilder<double>(
                                              tween: Tween(
                                                begin: 0.0,
                                                end: 1.0,
                                              ),
                                              duration: const Duration(
                                                milliseconds: 800,
                                              ),
                                              builder:
                                                  (context, val, child) =>
                                                      Transform.rotate(
                                                        angle: val * 6.28319,
                                                        child: const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                          size: 50,
                                                        ),
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        duration: const Duration(
                                          milliseconds: 1000,
                                        ),
                                        builder:
                                            (
                                              context,
                                              val,
                                              child,
                                            ) => Transform.scale(
                                              scale: val,
                                              child: ShaderMask(
                                                shaderCallback:
                                                    (bounds) =>
                                                        const LinearGradient(
                                                          colors: [
                                                            Colors.white,
                                                            Color(0xFFFFD700),
                                                          ],
                                                        ).createShader(bounds),
                                                child: Text(
                                                  '¡RACHA PERFECTA!',
                                                  style: const TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ] else ...[
                    // Racha normal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.orange.withAlpha(255),
                          size: 40,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$maxStreak',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Botones de navegación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onMenu,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.purple[300],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple[300]!.withAlpha(102),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.home_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onPlayAgain,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFA500).withAlpha(102),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
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
