import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/tema_juego_chemakids.dart';
import '../widgets/dialogo_instrucciones.dart';
import '../services/tts_service.dart';

class JuegoFormarPalabras extends StatefulWidget {
  const JuegoFormarPalabras({Key? key}) : super(key: key);

  @override
  State<JuegoFormarPalabras> createState() => _JuegoFormarPalabrasState();
}

class _JuegoFormarPalabrasState extends State<JuegoFormarPalabras>
    with SingleTickerProviderStateMixin {
  final TTSService _ttsService = TTSService();

  final List<Map<String, dynamic>> _palabras = [
    {
      'palabra': 'mono',
      'img':
          'https://cdn.pixabay.com/photo/2024/01/26/15/08/smiling-8534123_1280.png',
    },
    {
      'palabra': 'sol',
      'img':
          'https://static.vecteezy.com/system/resources/previews/018/931/339/original/kawaii-sun-icon-png.png',
    },
    {
      'palabra': 'gato',
      'img':
          'https://1.bp.blogspot.com/-Mxy-rlTODB8/YCUlVzPyghI/AAAAAAAKsHc/zu6tq61Pj8AuRTHKrGApf1BEIBJbsHLUwCLcBGAsYHQ/s1389/cat5_1534270.png',
    },
    {
      'palabra': 'flor',
      'img':
          'https://i.pinimg.com/originals/aa/a4/8f/aaa48f4a1c63cb4b1670e6565f2d93b8.png',
    },
    {
      'palabra': 'luna',
      'img':
          'https://cdn.pixabay.com/photo/2013/07/13/12/46/moon-146239_1280.png',
    },
    {
      'palabra': 'pez',
      'img':
          'https://cdn.pixabay.com/photo/2017/01/31/13/14/fish-2023925_1280.png',
    },
    {
      'palabra': 'oso',
      'img':
          'https://cdn.pixabay.com/photo/2017/01/31/13/14/bear-2023923_1280.png',
    },
    {
      'palabra': 'pato',
      'img':
          'https://cdn.pixabay.com/photo/2017/01/31/13/14/duck-2023927_1280.png',
    },
    {
      'palabra': 'arbol',
      'img':
          'https://cdn.pixabay.com/photo/2012/04/13/00/22/tree-31253_1280.png',
    },
    {
      'palabra': 'casa',
      'img':
          'https://cdn.pixabay.com/photo/2012/04/13/00/21/home-31224_1280.png',
    },
    {
      'palabra': 'tren',
      'img':
          'https://cdn.pixabay.com/photo/2013/07/13/12/46/train-146237_1280.png',
    },
    {
      'palabra': 'leon',
      'img':
          'https://cdn.pixabay.com/photo/2017/01/31/13/14/lion-2023928_1280.png',
    },
    {
      'palabra': 'uva',
      'img':
          'https://cdn.pixabay.com/photo/2013/07/13/12/46/grapes-146230_1280.png',
    },
    {
      'palabra': 'raton',
      'img':
          'https://cdn.pixabay.com/photo/2017/01/31/13/14/mouse-2023929_1280.png',
    },
    {
      'palabra': 'nube',
      'img':
          'https://cdn.pixabay.com/photo/2013/07/13/12/46/cloud-146231_1280.png',
    },
  ];

  int _indice = 0;
  List<String?> _espacios = [];
  List<String> _letrasDisponibles = [];
  bool _completado = false;
  bool _mostrarPista = false;
  List<bool> _errorEnEspacio = [];
  @override
  void initState() {
    super.initState();
    _iniciarPalabra();
    _initializeTTS();
  }

  void _initializeTTS() async {
    await _ttsService.initialize();

    // Mostrar instrucciones al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mostrarDialogoInstrucciones();
    });
  }

  Future<void> _mostrarDialogoInstrucciones() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogoInstrucciones(
          titulo: '¡Formar Palabras!',
          descripcion: 'Completa palabras letra por letra',
          instrucciones: [
            '¡Hola! Vamos a formar palabras letra por letra.',
            'Verás una imagen y espacios para las letras.',
            'Toca las letras de abajo para completar la palabra.',
            'Si te equivocas, puedes tocar otra letra.',
            'Usa el botón de sonido para escuchar la palabra.',
            '¡Completa todas las palabras!',
          ],
          icono: Icons.spellcheck,
          onComenzar: () {
            // Reproducir la primera palabra
            _reproducirPalabra();
          },
        );
      },
    );
  }

  Future<void> _reproducirPalabra() async {
    final palabra = _palabras[_indice]['palabra'] as String;
    await _ttsService.speak(palabra);
  }

  Future<void> _reproducirLetra(String letra) async {
    await _ttsService.speakLetter(letra);
  }

  Future<void> _reproducirFelicitacion() async {
    await _ttsService.speakCelebration();
  }

  void _iniciarPalabra() {
    final palabra = _palabras[_indice]['palabra'] as String;
    _espacios = List<String?>.filled(palabra.length, null);
    _errorEnEspacio = List<bool>.filled(palabra.length, false);

    // Calcula cuántas letras extra puedes mostrar sin que se desborde la pantalla
    // Máximo 8 letras en total (ajusta según tu diseño)
    final int maxLetras = 8;
    final int extrasCount =
        (palabra.length >= maxLetras) ? 0 : maxLetras - palabra.length;

    final extras = _letrasExtra(extrasCount);
    _letrasDisponibles = palabra.split('')..addAll(extras);
    _letrasDisponibles.shuffle();
    _completado = false;
    setState(() {});
  }

  List<String> _letrasExtra(int cantidad) {
    // Letras extra para confundir, siempre consonantes/vocales distintas
    const extras = [
      'a',
      'e',
      'i',
      'o',
      'u',
      'l',
      'm',
      'n',
      'p',
      'r',
      's',
      't',
      'd',
      'g',
      'z',
      'v',
      'c',
    ];
    final random = Random();
    final extrasList = List<String>.from(extras);
    extrasList.shuffle(random);
    return extrasList.take(cantidad).toList();
  }

  void _ponerLetra(int pos, String letra) {
    final palabra = _palabras[_indice]['palabra'] as String;
    if (_espacios[pos] == null && _letrasDisponibles.contains(letra)) {
      setState(() {
        if (letra == palabra[pos]) {
          _espacios[pos] = letra;
          _letrasDisponibles.remove(letra);
          _errorEnEspacio[pos] = false;
          _verificarPalabra();

          // Reproducir sonido de la letra al colocarla correctamente
          _reproducirLetra(letra);
        } else {
          // Letra incorrecta: marcar error y quitar letra después de un breve delay
          _errorEnEspacio[pos] = true;
          Future.delayed(const Duration(milliseconds: 400), () {
            setState(() {
              _errorEnEspacio[pos] = false;
            });
          });
        }
      });
    }
  }

  void _quitarLetra(int pos) {
    if (_espacios[pos] != null) {
      setState(() {
        _letrasDisponibles.add(_espacios[pos]!);
        _espacios[pos] = null;
        _completado = false;
      });
    }
  }

  void _verificarPalabra() {
    final palabra = _palabras[_indice]['palabra'] as String;
    if (_espacios.every((l) => l != null)) {
      setState(() {
        _completado = _espacios.join() == palabra;
      });

      // Si se completó correctamente, reproducir felicitación
      if (_completado) {
        _reproducirFelicitacion();
      }
    }
  }

  void _siguiente() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop(); // Cierra el diálogo si está abierto
    }
    if (_indice < _palabras.length - 1) {
      _indice++;
    } else {
      _indice = 0;
    }
    _iniciarPalabra();
  }

  void _mostrarLetraPista() {
    final palabra = _palabras[_indice]['palabra'] as String;
    // Encuentra el primer espacio vacío y coloca la letra correcta ahí
    for (int i = 0; i < _espacios.length; i++) {
      if (_espacios[i] == null) {
        String letraCorrecta = palabra[i];
        if (_letrasDisponibles.contains(letraCorrecta)) {
          setState(() {
            _espacios[i] = letraCorrecta;
            _letrasDisponibles.remove(letraCorrecta);
            _verificarPalabra();
            _mostrarPista = false;
          });
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palabra = _palabras[_indice]['palabra'] as String;
    final imgUrl = _palabras[_indice]['img'] as String;
    return PlantillaJuegoChemaKids(
      titulo: 'Formar Palabras',
      icono: Icons.star_rounded,
      mostrarAyuda: true,
      onAyuda:
          _completado
              ? null
              : () {
                setState(() {
                  _mostrarPista = true;
                });
                Future.delayed(const Duration(milliseconds: 300), () {
                  _mostrarLetraPista();
                });
              },
      contenido: Column(
        children: [
          const SizedBox(height: 10),
          // Imagen animada en vez de icono, ahora un poco más chica y centrada
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.85, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: MediaQuery.of(context).size.width * 0.40,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.08),
                        blurRadius: 18,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      imgUrl,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: Colors.deepPurple,
                          ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Botón de audio para escuchar la palabra
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton.icon(
              onPressed: _reproducirPalabra,
              icon: const Icon(Icons.volume_up, size: 24),
              label: const Text('Escuchar palabra'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[100],
                foregroundColor: Colors.deepPurple,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Espacios para la palabra
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(palabra.length, (i) {
              return DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  return GestureDetector(
                    onTap: () => _quitarLetra(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 54,
                      height: 66,
                      decoration: BoxDecoration(
                        color:
                            _espacios[i] != null
                                ? Colors.deepPurple[100]
                                : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              _errorEnEspacio[i]
                                  ? Colors.red
                                  : (candidateData.isNotEmpty
                                      ? Colors.orange
                                      : (_espacios[i] != null
                                          ? Colors.deepPurple
                                          : Colors.grey[400]!)),
                          width:
                              _errorEnEspacio[i]
                                  ? 4
                                  : (candidateData.isNotEmpty ? 3 : 2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            _espacios[i]?.toUpperCase() ?? '',
                            key: ValueKey(_espacios[i]),
                            style: TextStyle(
                              fontSize: 38,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                onWillAccept: (data) => _espacios[i] == null,
                onAccept: (letra) => _ponerLetra(i, letra),
              );
            }),
          ),
          const SizedBox(height: 40),
          // Letras disponibles animadas
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 18,
                runSpacing: 18,
                alignment: WrapAlignment.center,
                children:
                    _letrasDisponibles.map((letra) {
                      return Draggable<String>(
                        data: letra,
                        feedback: Material(
                          color: Colors.transparent,
                          child: _buildLetraDraggable(letra, dragging: true),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: _buildLetraDraggable(letra),
                        ),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.0),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.elasticOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: _buildLetraDraggable(letra),
                            );
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          if (_completado)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.7, end: 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                // Mostrar un diálogo animado en pantalla al completar la palabra
                Future.microtask(() async {
                  // Evita mostrar múltiples diálogos si ya está abierto
                  if (ModalRoute.of(context)?.isCurrent != true) return;

                  // Reproducir la palabra completada
                  await _reproducirPalabra();

                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      final bool esUltima = _indice >= _palabras.length - 1;
                      return Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Iconos de celebración con Material Design
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.celebration,
                                    color: Colors.amber,
                                    size: 48,
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 48,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                '¡Lo lograste!',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.amber,
                                      blurRadius: 12,
                                      offset: Offset(1, 2),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '¡Eres un/a súper lector/a!',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                icon: Icon(
                                  esUltima ? Icons.replay : Icons.arrow_forward,
                                ),
                                label: Text(
                                  esUltima ? 'Jugar de nuevo' : 'Siguiente',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(fontSize: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: _siguiente,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });
                // Oculta el widget de mensaje anterior
                return const SizedBox.shrink();
              },
            ),
          if (_mostrarPista)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.7, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Text(
                      '¡Pista! Se ha colocado una letra correcta.',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLetraDraggable(String letra, {bool dragging = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color:
            dragging
                ? Colors.deepPurple
                : Colors
                    .primaries[letra.codeUnitAt(0) % Colors.primaries.length]
                    .withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          letra.toUpperCase(),
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 4,
                offset: const Offset(1, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
