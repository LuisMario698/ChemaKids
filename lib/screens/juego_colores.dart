import 'package:flutter/material.dart';
import '../widgets/tema_juego_chemakids.dart';

class JuegoColores extends StatefulWidget {
  const JuegoColores({Key? key}) : super(key: key);

  @override
  State<JuegoColores> createState() => _JuegoColoresState();
}

class _JuegoColoresState extends State<JuegoColores> {
  final List<Map<String, dynamic>> _preguntas = [
    {'color': Colors.red, 'nombre': 'Rojo'},
    {'color': Colors.green, 'nombre': 'Verde'},
    {'color': Colors.blue, 'nombre': 'Azul'},
    {'color': Colors.yellow, 'nombre': 'Amarillo'},
  ];
  int _indice = 0;
  bool _respondido = false;
  bool _correcto = false;

  void _verificar(Color color) {
    setState(() {
      _respondido = true;
      _correcto = color == _preguntas[_indice]['color'];
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_indice < _preguntas.length - 1) {
            _indice++;
            _respondido = false;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pregunta = _preguntas[_indice];
    final opciones =
        _preguntas.map((e) => e['color'] as Color).toList()..shuffle();

    return PlantillaJuegoChemaKids(
      titulo: 'Juego de Colores',
      icono: Icons.palette,
      mostrarAyuda: false,
      contenido: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pregunta
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '¿Cuál es el color "${pregunta['nombre']}"?',
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),

            // Opciones de colores
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  opciones.map((color) {
                    return GestureDetector(
                      onTap: _respondido ? null : () => _verificar(color),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 30),

            // Mensaje de feedback
            if (_respondido)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _correcto ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  _correcto ? '¡Correcto!' : 'Intenta de nuevo',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
