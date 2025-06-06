import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
  });
}

class JuegoABC extends StatefulWidget {
  const JuegoABC({super.key});

  @override
  State<JuegoABC> createState() => _JuegoABCState();
}

class _JuegoABCState extends State<JuegoABC> with SingleTickerProviderStateMixin {
  final List<String> _letras = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  ];

  int _letraActualIndex = 0;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _floatAnimation;
  
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
    ));

    _floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _createParticles() {
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle(
        x: 0,
        y: 0,
        vx: _random.nextDouble() * 10 - 5,
        vy: _random.nextDouble() * -15,
        color: Color.lerp(
          const Color(0xFFFFA5A5),
          const Color(0xFFFF7676),
          _random.nextDouble(),
        )!,
      ));
    }
    setState(() {});
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _particles.clear();
        });
      }
    });
  }

  void _reproducirSonido() {
    _createParticles();
    _controller.forward().then((_) => _controller.reverse());
  }

  void _siguienteLetra() {
    setState(() {
      _letraActualIndex = (_letraActualIndex + 1) % _letras.length;
    });
  }

  void _letraAnterior() {
    setState(() {
      _letraActualIndex = (_letraActualIndex - 1 + _letras.length) % _letras.length;
    });
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _letras.length,
        itemBuilder: (context, index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == _letraActualIndex
                  ? const Color(0xFFFFA5A5)
                  : Colors.white.withOpacity(0.3),
            ),
          );
        },
      ),
    );
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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2A0944),
              const Color(0xFF3B0B54),
              const Color(0xFF2A0944),
            ],
            transform: GradientRotation(_controller.value * 2 * pi),
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background animated circles
              ...List.generate(3, (index) {
                final size = (index + 1) * 100.0;
                return Positioned(
                  top: -size / 2,
                  right: -size / 2,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * pi * (index + 1),
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.withOpacity(0.3),
                                Colors.purple.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),

              // Back button
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              
              // Title text
              const Positioned(
                top: 80,
                left: 24,
                child: Text(
                  '¿Como se escucha?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE0D3F5),
                  ),
                ),
              ),

              // Progress indicator
              Positioned(
                top: 140,
                left: 24,
                right: 24,
                child: _buildProgressIndicator(),
              ),

              // Main content
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildArrowButton(
                        icon: Icons.arrow_back_ios_rounded,
                        onTap: _letraAnterior,
                      ),
                      
                      Expanded(
                        child: GestureDetector(
                          onTapDown: (_) => _reproducirSonido(),
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity! > 0) {
                              _letraAnterior();
                            } else if (details.primaryVelocity! < 0) {
                              _siguienteLetra();
                            }
                          },
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _floatAnimation.value),
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Stack(
                                    children: [
                                      // Particles
                                      if (_particles.isNotEmpty)
                                        CustomPaint(
                                          size: Size(isDesktop ? 280 : 200, isDesktop ? 280 : 200),
                                          painter: _ParticlePainter(_particles),
                                        ),
                                      
                                      // Letter shadow and main display
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: ShaderMask(
                                            shaderCallback: (Rect bounds) {
                                              return LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.white,
                                                  Colors.white.withOpacity(0.8),
                                                ],
                                              ).createShader(bounds);
                                            },
                                            child: Stack(
                                              children: [
                                                // Shadow
                                                Text(
                                                  _letras[_letraActualIndex],
                                                  style: GoogleFonts.fredoka(
                                                    fontSize: isDesktop ? 280 : 200,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.black.withOpacity(0.2),
                                                    height: 1,
                                                  ),
                                                ),
                                                // Main letter
                                                Text(
                                                  _letras[_letraActualIndex],
                                                  style: GoogleFonts.fredoka(
                                                    fontSize: isDesktop ? 280 : 200,
                                                    fontWeight: FontWeight.w900,
                                                    foreground: Paint()
                                                      ..shader = LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: [
                                                          const Color(0xFFFFA5A5),
                                                          const Color(0xFFFF7676),
                                                        ],
                                                      ).createShader(
                                                        Rect.fromLTWH(0, 0, isDesktop ? 280 : 200, isDesktop ? 280 : 200),
                                                      ),
                                                    height: 1,
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
                              );
                            },
                          ),
                        ),
                      ),

                      _buildArrowButton(
                        icon: Icons.arrow_forward_ios_rounded,
                        onTap: _siguienteLetra,
                      ),
                    ],
                  ),
                ),
              ),              // Sound button
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _reproducirSonido,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Sombra exterior
                        Container(
                          width: isDesktop ? 340 : 280,
                          height: isDesktop ? 120 : 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D47A1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        // Botón principal con efecto 3D
                        Positioned(
                          top: 0,
                          child: Container(
                            width: isDesktop ? 340 : 280,
                            height: isDesktop ? 110 : 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF2196F3),
                                  Color(0xFF1976D2),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(0, 4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Megáfono imagen
                                    Image.network(
                                      'https://raw.githubusercontent.com/kubilayckmk/puppilot/main/assets/megaphone.png',
                                      width: isDesktop ? 80 : 70,
                                      height: isDesktop ? 80 : 70,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.campaign_rounded,
                                        color: Colors.white,
                                        size: isDesktop ? 50 : 40,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Ondas de sonido animadas
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(3, (index) {
                                        return TweenAnimationBuilder<double>(
                                          tween: Tween(begin: 0.3, end: 1.0),
                                          duration: Duration(milliseconds: 400 + (index * 200)),
                                          curve: Curves.easeInOut,
                                          builder: (context, value, child) {
                                            return Container(
                                              width: 6,
                                              height: (index + 1) * (isDesktop ? 20 : 15),
                                              margin: const EdgeInsets.symmetric(horizontal: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(value),
                                                borderRadius: BorderRadius.circular(3),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white.withOpacity(value * 0.3),
                                                    blurRadius: 8,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.x += particle.vx;
      particle.y += particle.vy;
      particle.vy += 0.5; // Gravity

      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width / 2 + particle.x, size.height / 2 + particle.y),
        3,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
