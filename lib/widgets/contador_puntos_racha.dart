import 'package:flutter/material.dart';

class ContadorPuntosRacha extends StatelessWidget {
  final int score;
  final int streak;

  const ContadorPuntosRacha({
    super.key,
    required this.score,
    required this.streak,
  });
  List<BoxShadow> _getStreakGlow(int streak) {
    if (streak == 0) return [];

    final intensity = (streak / 10).clamp(0.0, 1.0);
    final color =
        Color.lerp(
          const Color(0xFFFFA500), // Naranja normal
          const Color(0xFFFF0000), // Rojo intenso
          intensity,
        )!;

    return [
      BoxShadow(
        color: color.withAlpha(40),
        blurRadius: 8 + (streak * 2),
        spreadRadius: 2 + streak.toDouble(),
      ),
      BoxShadow(
        color: color.withAlpha(60),
        blurRadius: 4 + streak.toDouble(),
        spreadRadius: 1 + (streak * 0.5),
      ),
    ];
  }

  Color _getStreakColor(int streak) {
    if (streak == 0) return Colors.white54;

    final intensity = (streak / 10).clamp(0.0, 1.0);
    return Color.lerp(
      const Color(0xFFFFA500), // Naranja normal
      const Color(0xFFFF0000), // Rojo intenso
      intensity,
    )!;
  }

  double _getStreakSize(int streak) {
    return 36 + (streak * 2); // Crece 2 pixels por cada punto de racha
  }

  @override
  Widget build(BuildContext context) {
    final streakColor = _getStreakColor(streak);
    final streakGlow = _getStreakGlow(streak);
    final streakSize = _getStreakSize(streak);
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: isDesktop ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51), // 0.2 opacity
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: streakColor, width: streak > 0 ? 2 : 0),
        boxShadow: streakGlow,
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width > 600 ? 32 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Puntos',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Container(
            height: 40,
            width: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder:
                    (context, scale, child) => Transform.scale(
                      scale: scale,
                      child: Stack(
                        children: [
                          if (streak > 0)
                            Icon(
                              Icons.local_fire_department,
                              color: streakColor.withAlpha(100),
                              size: streakSize + 8,
                            ),
                          Icon(
                            Icons.local_fire_department,
                            color: streakColor,
                            size: streakSize,
                          ),
                        ],
                      ),
                    ),
              ),
              const SizedBox(width: 8),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder:
                    (context, scale, child) => Transform.scale(
                      scale: scale,
                      child: Text(
                        '$streak',
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width > 600
                                  ? streakSize - 4
                                  : streakSize - 8,
                          fontWeight: FontWeight.bold,
                          color: streakColor,
                          shadows:
                              streak > 0
                                  ? [
                                    Shadow(
                                      color: streakColor.withAlpha(150),
                                      blurRadius: 8,
                                    ),
                                  ]
                                  : [],
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
