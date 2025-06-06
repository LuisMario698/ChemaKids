import 'package:flutter/material.dart';
import 'dart:math';

class JuegoFormarPalabras extends StatefulWidget {
  const JuegoFormarPalabras({Key? key}) : super(key: key);

  @override
  State<JuegoFormarPalabras> createState() => _JuegoFormarPalabrasState();
}

class _JuegoFormarPalabrasState extends State<JuegoFormarPalabras>
    with SingleTickerProviderStateMixin {
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

  late AnimationController _bgController;
  late Animation<double> _bgAnimation;
  final Random _random = Random();

  // Paleta de colores llamativos y suaves para las burbujas
  final List<Color> _bubbleColors = [
    Color(0xFFFFB74D),
    Color(0xFF64B5F6),
    Color(0xFF81C784),
    Color(0xFFE57373),
    Color(0xFFBA68C8),
    Color(0xFFFFF176),
    Color(0xFFFF8A65),
    Color(0xFF4DD0E1),
    Color(0xFFAED581),
    Color(0xFFFFD54F),
  ];

  @override
  void initState() {
    super.initState();
    _iniciarPalabra();
    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    _bgAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
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

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      // Quita el AppBar y usa un encabezado visual uniforme y amigable
      body: Stack(
        children: [
          // Fondo animado con burbujas suaves y colores llamativos
          AnimatedBuilder(
            animation: _bgAnimation,
            builder: (context, child) {
              final width = MediaQuery.of(context).size.width;
              final height = MediaQuery.of(context).size.height;
              return Stack(
                children: List.generate(10, (i) {
                  final double size =
                      70 +
                      40 *
                          (i % 2 == 0
                              ? _bgAnimation.value
                              : 1 - _bgAnimation.value);
                  final double top = (height *
                          (0.1 +
                              0.7 *
                                  ((i * 0.13 +
                                          _bgAnimation.value *
                                              (i.isEven ? 0.5 : -0.5)) %
                                      1)))
                      .clamp(0, height - size);
                  final double left = (width *
                          (0.05 +
                              0.8 *
                                  ((i * 0.19 +
                                          (1 - _bgAnimation.value) *
                                              (i.isOdd ? 0.4 : -0.4)) %
                                      1)))
                      .clamp(0, width - size);
                  final color = _bubbleColors[i % _bubbleColors.length]
                      .withOpacity(0.18 + 0.07 * (i % 3));
                  return Positioned(
                    top: top,
                    left: left,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.25),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Encabezado visual uniforme y amigable
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.deepPurple,
                          size: 32,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Volver',
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[100],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Formar Palabras',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.lightbulb,
                          color: Colors.amber,
                          size: 32,
                        ),
                        tooltip: 'Pista',
                        onPressed:
                            _completado
                                ? null
                                : () {
                                  setState(() {
                                    _mostrarPista = true;
                                  });
                                  Future.delayed(
                                    const Duration(milliseconds: 300),
                                    () {
                                      _mostrarLetraPista();
                                    },
                                  );
                                },
                      ),
                    ],
                  ),
                ),
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
                const SizedBox(height: 24),
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
                Wrap(
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
                const SizedBox(height: 32),
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
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            final bool esUltima =
                                _indice >= _palabras.length - 1;
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
                                    const Text(
                                      '🎉🌟',
                                      style: TextStyle(fontSize: 48),
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
                                        esUltima
                                            ? Icons.replay
                                            : Icons.arrow_forward,
                                      ),
                                      label: Text(
                                        esUltima
                                            ? 'Jugar de nuevo'
                                            : 'Siguiente',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(
                                          fontSize: 20,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
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
