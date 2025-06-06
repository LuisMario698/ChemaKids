import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Colores')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Cuál es el color "${pregunta['nombre']}"?',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  opciones.map((color) {
                    return GestureDetector(
                      onTap: _respondido ? null : () => _verificar(color),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(width: 3, color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 30),
            if (_respondido)
              Text(
                _correcto ? '¡Correcto!' : 'Intenta de nuevo',
                style: TextStyle(
                  color: _correcto ? Colors.green : Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
