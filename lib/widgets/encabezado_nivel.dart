import 'package:flutter/material.dart';
import 'estilo_infantil.dart';

class EncabezadoNivel extends StatefulWidget {
  final String nivel;
  final String titulo;
  final String emoji;

  const EncabezadoNivel({
    Key? key,
    required this.nivel,
    required this.titulo,
    required this.emoji,
  }) : super(key: key);

  @override
  State<EncabezadoNivel> createState() => _EncabezadoNivelState();
}

class _EncabezadoNivelState extends State<EncabezadoNivel> with SingleTickerProviderStateMixin {
  late AnimationController _controlador;
  late Animation<double> _rebote;

  @override
  void initState() {
    super.initState();
    _controlador = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rebote = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controlador, curve: Curves.elasticInOut),
    );
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Stack(
        children: [
          // Fondo con forma personalizada
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF8E44AD),
                  Color(0xFF9B59B6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Número de nivel con animación
                AnimatedBuilder(
                  animation: _controlador,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _rebote.value),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              widget.emoji,
                              style: TextStyle(fontSize: 40),
                            ),
                            Text(
                              widget.nivel,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 20),
                // Título del nivel
                Expanded(
                  child: Text(
                    widget.titulo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}