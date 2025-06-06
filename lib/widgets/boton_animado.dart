import 'package:flutter/material.dart';
import 'dart:math';

class BotonAnimado extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double amplitude;

  const BotonAnimado({
    super.key,
    required this.child,
    required this.onTap,
    this.amplitude = 8.0,
  });

  @override
  State<BotonAnimado> createState() => _BotonAnimadoState();
}

class _BotonAnimadoState extends State<BotonAnimado>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _verticalAnimation;
  late Animation<double> _horizontalAnimation;
  late Animation<double> _scaleAnimation;
  final random = Random();
  late double _randomOffset;
  late double _randomAmplitude;
  late double _randomAngle;  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);_randomAmplitude = widget.amplitude * (0.8 + random.nextDouble() * 0.4);
    _randomOffset = (random.nextDouble() - 0.5) * 4.0;
    _randomAngle = (random.nextDouble() - 0.5) * 0.1;

    _verticalAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -_randomAmplitude)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -_randomAmplitude, end: 0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 60.0,
      ),
    ]).animate(_controller);

    _horizontalAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: _randomOffset)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: _randomOffset, end: 0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50.0,
      ),
    ]).animate(_controller);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.05)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 70.0,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        widget.onTap();
        // Agregar un efecto de "pulse" sin detener la animación principal
        setState(() {
          _randomAmplitude = widget.amplitude * (0.8 + random.nextDouble() * 0.4);
          _randomOffset = (random.nextDouble() - 0.5) * 4.0;
          _randomAngle = (random.nextDouble() - 0.5) * 0.1;
        });
      },
      child: AnimatedBuilder(
        animation: _controller,        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: _isPressed
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFFA500).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Transform(
              transform: Matrix4.identity()
                ..translate(
                  _horizontalAnimation.value,
                  _verticalAnimation.value,
                )
                ..rotateZ(_randomAngle * sin(_controller.value * pi))
                ..scale(_scaleAnimation.value * (_isPressed ? 0.95 : 1.0)),
              alignment: Alignment.center,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
