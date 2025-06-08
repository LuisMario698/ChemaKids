import 'package:flutter/material.dart';

class DialogoRachaPerdida extends StatefulWidget {
  final int racha;

  const DialogoRachaPerdida({super.key, required this.racha});

  @override
  State<DialogoRachaPerdida> createState() => _DialogoRachaPerdidaState();
}

class _DialogoRachaPerdidaState extends State<DialogoRachaPerdida>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.orange, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51), // 0.2 opacity
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji triste grande              const Text('😢', style: TextStyle(fontSize: 80)),
              Text(
                'Has perdido la racha',
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Animación de fuego apagándose
              Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.grey,
                    size: 120,
                  ),
                  Transform.rotate(
                    angle: -0.5,
                    child: Container(
                      width: 140,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(204), // 0.8 opacity
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withAlpha(77), // 0.3 opacity
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Número de la racha grande
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.racha}',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const Icon(Icons.flash_on, color: Colors.orange, size: 72),
                ],
              ),
              const SizedBox(height: 30),
              // Botón animado para continuar
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 600),
                builder:
                    (context, value, child) => Transform.scale(
                      scale: value,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFA500), Color(0xFFFF8C00)],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFFA500,
                                ).withAlpha(102), // 0.4 opacity
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '¡Otra vez!',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('💪', style: TextStyle(fontSize: 28)),
                            ],
                          ),
                        ),
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
