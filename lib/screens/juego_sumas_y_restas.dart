import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/tema_juego_chemakids.dart';

class JuegoSumasYRestas extends StatefulWidget {
  const JuegoSumasYRestas({super.key});

  @override
  State<JuegoSumasYRestas> createState() => _JuegoSumasYRestasState();
}

class _JuegoSumasYRestasState extends State<JuegoSumasYRestas> {
  late int a;
  late int b;
  late bool esSuma;
  String mensaje = '';
  String emoji = '';
  Color feedbackColor = Colors.transparent;

  // Lista de emojis de frutas y objetos amigables
  final List<String> _emojis = [
    '🍎',
    '🍌',
    '🍓',
    '🍇',
    '🍊',
    '🍉',
    '🍍',
    '🍒',
    '🍋',
    '🥝',
    '🥕',
    '🍪',
    '🧁',
    '🍭',
  ];
  late String emojiA;
  late String emojiB;

  @override
  void initState() {
    super.initState();
    _nuevaOperacion();
  }

  void _nuevaOperacion() {
    final rand = Random();
    a = rand.nextInt(6) + 2; // Para que haya al menos 2 elementos
    b = rand.nextInt(6) + 1;
    esSuma = rand.nextBool();
    // Elegir dos emojis diferentes
    emojiA = _emojis[rand.nextInt(_emojis.length)];
    do {
      emojiB = _emojis[rand.nextInt(_emojis.length)];
    } while (emojiB == emojiA);
    if (!esSuma && b > a) {
      final temp = a;
      a = b;
      b = temp;
    }
    mensaje = '';
    emoji = '';
    feedbackColor = Colors.transparent;
    setState(() {});
  }

  List<int> _generarOpciones() {
    int resultado = esSuma ? a + b : a - b;
    Set<int> opciones = {resultado};
    final rand = Random();
    while (opciones.length < 4) {
      int delta = rand.nextInt(4) + 1;
      int opcion = resultado + (rand.nextBool() ? delta : -delta);
      if (opcion > 0) {
        opciones.add(opcion);
      }
    }
    List<int> lista = opciones.toList();
    lista.shuffle();
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    final opciones = _generarOpciones();
    return PlantillaJuegoChemaKids(
      titulo: 'Sumas y Restas',
      icono: Icons.calculate,
      mostrarAyuda: false,
      contenido: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.amber, width: 3),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  esSuma ? '¡Vamos a sumar!' : '¡Vamos a restar!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEmojis(a, emojiA),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        esSuma ? '+' : '-',
                        style: const TextStyle(
                          fontSize: 36,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    _buildEmojis(b, emojiB),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '=',
                        style: TextStyle(fontSize: 36, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    const Text(
                      '?',
                      style: TextStyle(fontSize: 36, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children:
                      opciones.map((opcion) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            minimumSize: const Size(70, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed:
                              mensaje == '¡Muy bien! 🎉'
                                  ? null
                                  : () {
                                    int resultado = esSuma ? a + b : a - b;
                                    setState(() {
                                      if (opcion == resultado) {
                                        mensaje = '¡Muy bien! 🎉';
                                        emoji = '😃';
                                        feedbackColor = Colors.green.shade300;
                                      } else {
                                        mensaje = '¡Intenta de nuevo! 💡';
                                        emoji = '🤔';
                                        feedbackColor = Colors.red.shade200;
                                      }
                                    });
                                  },
                          child: Text(opcion.toString()),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: feedbackColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mensaje,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (emoji.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    _nuevaOperacion();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Siguiente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmojis(int cantidad, String emoji) {
    return Wrap(
      spacing: 4,
      children: List.generate(
        cantidad,
        (index) => Text(emoji, style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}
