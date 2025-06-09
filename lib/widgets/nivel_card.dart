import 'package:flutter/material.dart';

class NivelCard extends StatelessWidget {
  final int nivel;
  final String titulo;
  final Color color;
  final VoidCallback? onTap;
  final bool bloqueado;
  final String? imagenUrl;
  final Widget? imagenDecorativa;
  final double? width;

  const NivelCard({
    super.key,
    this.nivel = 1,
    required this.titulo,
    required this.color,
    this.onTap,
    this.bloqueado = false,
    this.imagenUrl,
    this.imagenDecorativa,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    final cardWidth = width ?? (isDesktop ? 400.0 : screenWidth - 48);

    return SizedBox(
      width: cardWidth,
      height: cardWidth / 2.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: bloqueado ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [                if (imagenUrl != null || imagenDecorativa != null)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: imagenUrl != null
                          ? Image.network(
                              imagenUrl!,
                              fit: BoxFit.cover,
                              opacity: const AlwaysStoppedAnimation(0.3),
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox.shrink(),
                            )
                          : imagenDecorativa!,
                    ),
                  ),
                if (bloqueado)
                  Center(
                    child: Icon(
                      Icons.lock,
                      size: isDesktop ? 48 : 40,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nivel $nivel',
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 16,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        titulo,
                        style: TextStyle(
                          fontSize: isDesktop ? 28 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!bloqueado)
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: Icon(
                      Icons.play_circle_fill,
                      size: isDesktop ? 48 : 40,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}