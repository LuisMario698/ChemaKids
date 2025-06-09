import 'package:flutter/material.dart';
import '../widgets/tema_juego_chemakids.dart';

class JuegoFormas extends StatefulWidget {
  const JuegoFormas({Key? key}) : super(key: key);

  @override
  State<JuegoFormas> createState() => _JuegoFormasState();
}

class _JuegoFormasState extends State<JuegoFormas> {
  final List<Map<String, dynamic>> _preguntas = [
    {'nombre': 'Círculo', 'forma': BoxShape.circle},
    {'nombre': 'Cuadrado', 'forma': BoxShape.rectangle},
  ];
  int _indice = 0;
  bool _respondido = false;
  bool _correcto = false;

  void _verificar(BoxShape forma) {
    setState(() {
      _respondido = true;
      _correcto = forma == _preguntas[_indice]['forma'];
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
        _preguntas.map((e) => e['forma'] as BoxShape).toList()..shuffle();
    
    return PlantillaJuegoChemaKids(
      titulo: 'Formas',
      icono: Icons.circle_outlined,
      contenido: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Cuál es la forma "${pregunta['nombre']}"?',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  opciones.map((forma) {
                    return GestureDetector(
                      onTap: _respondido ? null : () => _verificar(forma),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: forma,
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
