import 'package:flutter/material.dart';
import '../widgets/tema_juego_chemakids.dart';

class JuegoAnimales extends StatefulWidget {
  const JuegoAnimales({Key? key}) : super(key: key);

  @override
  State<JuegoAnimales> createState() => _JuegoAnimalesState();
}

class _JuegoAnimalesState extends State<JuegoAnimales> {
  final List<Map<String, dynamic>> _preguntas = [
    {'nombre': 'Perro', 'emoji': '🐶'},
    {'nombre': 'Gato', 'emoji': '🐱'},
    {'nombre': 'Vaca', 'emoji': '🐮'},
    {'nombre': 'Cerdo', 'emoji': '🐷'},
  ];
  int _indice = 0;
  bool _respondido = false;
  bool _correcto = false;

  void _verificar(String nombre) {
    setState(() {
      _respondido = true;
      _correcto = nombre == _preguntas[_indice]['nombre'];
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
        _preguntas.map((e) => e['nombre'] as String).toList()..shuffle();

    return PlantillaJuegoChemaKids(
      titulo: 'Animales',
      icono: Icons.pets,
      contenido: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Cuál es el animal "${pregunta['nombre']}"?',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  opciones.map((nombre) {
                    final emoji =
                        _preguntas.firstWhere(
                          (e) => e['nombre'] == nombre,
                        )['emoji'];
                    return GestureDetector(
                      onTap: _respondido ? null : () => _verificar(nombre),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          shape: BoxShape.circle,
                          border: Border.all(width: 3, color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
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
