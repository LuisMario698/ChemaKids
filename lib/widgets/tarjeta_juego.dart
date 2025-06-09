import 'package:flutter/material.dart';
import 'estilo_infantil.dart';

class TarjetaJuego extends StatelessWidget {
  final String titulo;
  final String emoji;
  final String imageUrl;
  final VoidCallback onTap;
  final int indiceColor;
  final bool esEscritorio;

  const TarjetaJuego({
    Key? key,
    required this.titulo,
    required this.emoji,
    required this.imageUrl,
    required this.onTap,
    required this.indiceColor,
    this.esEscritorio = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.white.withOpacity(0.1),      child: Container(
        width: esEscritorio ? 500 : 280,
        height: esEscritorio ? 300 : 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: EstiloInfantil.temasColores[indiceColor],
          ),
          boxShadow: [
            BoxShadow(
              color: EstiloInfantil.temasColores[indiceColor][0].withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: esEscritorio ? 260 : 200,
              height: esEscritorio ? 200 : 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imageUrl.startsWith('assets/')
                    ? Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
              ),
            ),
            SizedBox(height: esEscritorio ? 24 : 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: esEscritorio ? 28 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  emoji,
                  style: TextStyle(fontSize: esEscritorio ? 28 : 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}