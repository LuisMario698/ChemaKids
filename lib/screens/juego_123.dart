import 'package:flutter/material.dart';
import '../widgets/tema_juego_chemakids.dart';
import '../services/tts_service.dart';

class Juego123 extends StatefulWidget {
  const Juego123({super.key});

  @override
  State<Juego123> createState() => _Juego123State();
}

class _Juego123State extends State<Juego123> with TickerProviderStateMixin {
  int _numeroActual = 1;
  final int _numeroMaximo = 10;
  late AnimationController _numeroController;
  late AnimationController _pulseController;
  late Animation<double> _numeroAnimation;
  late Animation<double> _pulseAnimation;
  final TTSService _ttsService = TTSService();
  bool _isPlayingAudio = false;
  late ScrollController _selectorScrollController;

  // Lista de números con datos más ricos para una experiencia más inmersiva
  final List<Map<String, dynamic>> _numeros = [
    {
      'numero': 1,
      'palabra': 'UNO',
      'objetos': ['🔴'],
      'color': const Color(0xFFE91E63),
      'descripcion': 'El número uno representa la unidad',
    },
    {
      'numero': 2,
      'palabra': 'DOS',
      'objetos': ['🔴', '🔴'],
      'color': const Color(0xFF2196F3),
      'descripcion': 'Dos significa un par de cosas',
    },
    {
      'numero': 3,
      'palabra': 'TRES',
      'objetos': ['🔴', '🔴', '🔴'],
      'color': const Color(0xFF4CAF50),
      'descripcion': 'Tres forma un pequeño grupo',
    },
    {
      'numero': 4,
      'palabra': 'CUATRO',
      'objetos': ['🔴', '🔴', '🔴', '🔴'],
      'color': const Color(0xFFFF9800),
      'descripcion': 'Cuatro elementos juntos',
    },
    {
      'numero': 5,
      'palabra': 'CINCO',
      'objetos': ['🟡', '🟡', '🟡', '🟡', '🟡'],
      'color': const Color(0xFF9C27B0),
      'descripcion': 'Cinco como los dedos de una mano',
    },
    {
      'numero': 6,
      'palabra': 'SEIS',
      'objetos': ['🟡', '🟡', '🟡', '🟡', '🟡', '🟡'],
      'color': const Color(0xFF009688),
      'descripcion': 'Seis círculos brillantes',
    },
    {
      'numero': 7,
      'palabra': 'SIETE',
      'objetos': ['🟢', '🟢', '🟢', '🟢', '🟢', '🟢', '🟢'],
      'color': const Color(0xFFFF5722),
      'descripcion': 'Siete es un número especial',
    },
    {
      'numero': 8,
      'palabra': 'OCHO',
      'objetos': ['🟢', '🟢', '🟢', '🟢', '🟢', '🟢', '🟢', '🟢'],
      'color': const Color(0xFF795548),
      'descripcion': 'Ocho círculos en el cielo',
    },
    {
      'numero': 9,
      'palabra': 'NUEVE',
      'objetos': ['🔵', '🔵', '🔵', '🔵', '🔵', '🔵', '🔵', '🔵', '🔵'],
      'color': const Color(0xFF607D8B),
      'descripcion': 'Nueve círculos de colores',
    },
    {
      'numero': 10,
      'palabra': 'DIEZ',
      'objetos': ['🔵', '🔵', '🔵', '🔵', '🔵', '🔵', '🔵', '🔵', '🔵', '🔵'],
      'color': const Color(0xFF3F51B5),
      'descripcion': 'Diez es nuestro número completo',
    },
  ];

  @override
  void initState() {
    super.initState();
    _numeroController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Inicializar el scroll controller para el selector de números
    _selectorScrollController = ScrollController();

    _numeroAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _numeroController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _numeroController.forward();
    _pulseController.repeat(reverse: true);

    // Inicializar el servicio TTS
    _initializeTTS();

    // Hacer scroll inicial después de que se construya el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentNumber();
    });
  }

  /// Inicializa el servicio TTS
  Future<void> _initializeTTS() async {
    try {
      await _ttsService.initialize();
      print('🎵 TTS Service inicializado para juego 123');
    } catch (e) {
      print('❌ Error inicializando TTS en juego 123: $e');
    }
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _pulseController.dispose();
    _selectorScrollController.dispose();
    _ttsService.stop(); // Detener cualquier reproducción en curso
    super.dispose();
  }

  void _siguienteNumero() {
    if (_numeroActual < _numeroMaximo) {
      _numeroController.reset();
      setState(() {
        _numeroActual++;
      });
      _numeroController.forward();
      _scrollToCurrentNumber();
    }
  }

  void _numeroAnterior() {
    if (_numeroActual > 1) {
      _numeroController.reset();
      setState(() {
        _numeroActual--;
      });
      _numeroController.forward();
      _scrollToCurrentNumber();
    }
  }

  void _irANumero(int numero) {
    if (numero >= 1 && numero <= _numeroMaximo && numero != _numeroActual) {
      _numeroController.reset();
      setState(() {
        _numeroActual = numero;
      });
      _numeroController.forward();
      _scrollToCurrentNumber();
    }
  }

  /// Hace scroll al número actual en el selector horizontal
  void _scrollToCurrentNumber() {
    if (_selectorScrollController.hasClients) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isDesktop = screenWidth > 600;
      final isTablet = screenWidth > 400 && screenWidth <= 600;
      final selectorItemSize = isDesktop ? 60.0 : (isTablet ? 55.0 : 50.0);

      // Calcular el ancho total de cada item incluyendo márgenes
      const marginPerItem = 12.0; // 6 de cada lado
      final itemWidth = selectorItemSize + marginPerItem;

      // Calcular la posición objetivo para centrar el número actual
      final targetOffset =
          (_numeroActual - 1) * itemWidth - (screenWidth / 2 - itemWidth / 2);

      // Aplicar límites para evitar scroll fuera de rango
      final maxOffset = _selectorScrollController.position.maxScrollExtent;
      final clampedOffset = targetOffset.clamp(0.0, maxOffset);

      _selectorScrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Reproduce el número actual (número + palabra)
  Future<void> _reproducirNumero() async {
    if (_isPlayingAudio) return;

    setState(() {
      _isPlayingAudio = true;
    });

    try {
      // Reproducir el número usando el método speakNumber
      await _ttsService.speakNumber(_numeroActual);

      print('🔊 Reproduciendo número: $_numeroActual');
    } catch (e) {
      print('❌ Error reproduciendo número: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    }
  }

  /// Reproduce solo la palabra del número actual
  Future<void> _reproducirPalabra() async {
    if (_isPlayingAudio) return;

    setState(() {
      _isPlayingAudio = true;
    });

    try {
      final numeroData = _numeros[_numeroActual - 1];
      final palabra = numeroData['palabra'];

      await _ttsService.speak(palabra);
      print('🔊 Reproduciendo palabra: $palabra');
    } catch (e) {
      print('❌ Error reproduciendo palabra: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    }
  }

  /// Reproduce una cuenta hacia el número actual
  Future<void> _reproducirConteo() async {
    if (_isPlayingAudio) return;

    setState(() {
      _isPlayingAudio = true;
    });

    try {
      final numeroActual = _numeroActual;

      // Contar del 1 al número actual
      for (int i = 1; i <= numeroActual; i++) {
        await _ttsService.speakNumber(i);
        if (i < numeroActual) {
          await Future.delayed(const Duration(milliseconds: 800));
        }
      }

      print('🔊 Reproduciendo conteo hasta: $numeroActual');
    } catch (e) {
      print('❌ Error reproduciendo conteo: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    }
  }

  Widget _buildObjectsGrid(Map<String, dynamic> numeroData) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: List.generate(
        numeroData['objetos'].length,
        (index) => _ObjectAnimatedItem(
          key: ValueKey('${numeroData['numero']}_$index'),
          objeto: numeroData['objetos'][index],
          color: numeroData['color'],
          delay: Duration(milliseconds: 200 + (index * 100)),
        ),
      ),
    );
  }

  void _mostrarAyuda() {
    final numeroData = _numeros[_numeroActual - 1];
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: numeroData['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lightbulb, color: numeroData['color'], size: 32),
                  const SizedBox(width: 8),
                  Text(
                    'Número ${numeroData['numero']}',
                    style: TextStyle(
                      color: numeroData['color'],
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Número grande animado
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: numeroData['color'],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: numeroData['color'].withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${numeroData['numero']}',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Palabra
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Text(
                    numeroData['palabra'],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Descripción
                Text(
                  numeroData['descripcion'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Objetos para contar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Cuenta los objetos:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            numeroData['objetos']
                                .map<Widget>(
                                  (objeto) => Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      objeto,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text(
                    '¡Entendido!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: numeroData['color'],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final numeroData = _numeros[_numeroActual - 1];
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    final isTablet = screenWidth > 400 && screenWidth <= 600;

    // Tamaños responsivos - haciendo los elementos centrales más pequeños
    final circleSize = isDesktop ? 120.0 : (isTablet ? 100.0 : 80.0);
    final numberFontSize = isDesktop ? 48.0 : (isTablet ? 40.0 : 32.0);
    final wordFontSize = isDesktop ? 24.0 : (isTablet ? 20.0 : 18.0);
    final horizontalPadding = isDesktop ? 24.0 : (isTablet ? 20.0 : 16.0);
    final buttonFontSize = isDesktop ? 18.0 : (isTablet ? 16.0 : 14.0);
    final iconSize = isDesktop ? 32.0 : (isTablet ? 28.0 : 24.0);
    final selectorHeight = isDesktop ? 70.0 : (isTablet ? 65.0 : 60.0);
    final selectorItemSize = isDesktop ? 60.0 : (isTablet ? 55.0 : 50.0);
    final verticalSpacing = isDesktop ? 20.0 : (isTablet ? 16.0 : 12.0);
    final countSectionFontSize = isDesktop ? 18.0 : (isTablet ? 16.0 : 14.0);

    return PlantillaJuegoChemaKids(
      titulo: '123 - Aprende Números',
      icono: Icons.looks_one,
      onAyuda: _mostrarAyuda,
      contenido: Column(
        children: [
          const SizedBox(height: 16),

          // Indicador de progreso mejorado
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Barra de progreso visual
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _numeroActual / _numeroMaximo,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            numeroData['color'],
                            numeroData['color'].withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Texto del progreso
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Número $_numeroActual',
                      style: TextStyle(
                        fontSize: 16,
                        color: numeroData['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$_numeroActual de $_numeroMaximo',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Contenido principal del número
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Número principal con animación
                    AnimatedBuilder(
                      animation: _numeroAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _numeroAnimation.value,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: GestureDetector(
                                  onTap: _reproducirNumero,
                                  child: Container(
                                    width: circleSize,
                                    height: circleSize,
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                        colors: [
                                          numeroData['color'],
                                          numeroData['color'].withOpacity(0.8),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: numeroData['color']
                                              .withOpacity(0.4),
                                          blurRadius: 30,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${numeroData['numero']}',
                                        style: TextStyle(
                                          fontSize: numberFontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(2, 2),
                                              blurRadius: 4,
                                              color: Colors.black26,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    SizedBox(height: verticalSpacing),

                    // Palabra del número con animación
                    AnimatedBuilder(
                      animation: _numeroAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - _numeroAnimation.value)),
                          child: Opacity(
                            opacity: _numeroAnimation.value.clamp(0.0, 1.0),
                            child: GestureDetector(
                              onTap: _reproducirPalabra,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.amber[300]!,
                                      Colors.amber[400]!,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amber.withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  numeroData['palabra'],
                                  style: TextStyle(
                                    fontSize: wordFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 3,
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 3,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Objetos para contar con animación escalonada
                    AnimatedBuilder(
                      animation: _numeroAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - _numeroAnimation.value)),
                          child: Opacity(
                            opacity: _numeroAnimation.value.clamp(0.0, 1.0),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: numeroData['color'].withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: _reproducirConteo,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: numeroData['color'].withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: numeroData['color']
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.play_circle,
                                            color: numeroData['color'],
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Cuenta conmigo:',
                                            style: TextStyle(
                                              fontSize: countSectionFontSize,
                                              color: numeroData['color'],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildObjectsGrid(numeroData),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: verticalSpacing),

                    // Botón de audio mejorado
                    AnimatedBuilder(
                      animation: _numeroAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - _numeroAnimation.value)),
                          child: Opacity(
                            opacity: _numeroAnimation.value.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green[400]!,
                                    Colors.green[600]!,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.4),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(28),
                                  onTap: _reproducirNumero,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _isPlayingAudio
                                              ? Icons.volume_up
                                              : Icons.volume_up_outlined,
                                          color: Colors.white,
                                          size: iconSize,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Escuchar número',
                                          style: TextStyle(
                                            fontSize: buttonFontSize + 2,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Navegación mejorada
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Título del selector
                Text(
                  'Selecciona un número:',
                  style: TextStyle(
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),

                // Contenedor del selector con indicadores de scroll
                Stack(
                  children: [
                    // Selector rápido de números con scroll horizontal mejorado
                    Container(
                      height: selectorHeight,
                      child: ListView.builder(
                        controller: _selectorScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        itemCount: _numeroMaximo,
                        itemBuilder: (context, index) {
                          final numero = index + 1;
                          final isSelected = numero == _numeroActual;
                          final colorNumero = _numeros[index]['color'];

                          return GestureDetector(
                            onTap: () => _irANumero(numero),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: selectorItemSize,
                              height: selectorItemSize,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? colorNumero : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorNumero,
                                  width: isSelected ? 3 : 2,
                                ),
                                boxShadow:
                                    isSelected
                                        ? [
                                          BoxShadow(
                                            color: colorNumero.withOpacity(0.4),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                        : [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                              ),
                              child: Center(
                                child: Text(
                                  '$numero',
                                  style: TextStyle(
                                    fontSize:
                                        isSelected
                                            ? buttonFontSize + 2
                                            : buttonFontSize,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isSelected ? Colors.white : colorNumero,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Indicadores de scroll sutiles en los extremos
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white.withOpacity(0.8),
                              Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.grey[400],
                          size: 16,
                        ),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.white.withOpacity(0.8),
                              Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.grey[400],
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                // Texto de ayuda sutil
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swipe, color: Colors.grey[400], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Desliza para ver todos los números',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Botones de navegación principales
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Botón anterior
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              _numeroActual > 1
                                  ? [Colors.blue[400]!, Colors.blue[600]!]
                                  : [Colors.grey[400]!, Colors.grey[500]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow:
                            _numeroActual > 1
                                ? [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                                : [],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: _numeroActual > 1 ? _numeroAnterior : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: 14,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: iconSize,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Anterior',
                                  style: TextStyle(
                                    fontSize: buttonFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Botón siguiente
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              _numeroActual < _numeroMaximo
                                  ? [Colors.orange[400]!, Colors.orange[600]!]
                                  : [Colors.grey[400]!, Colors.grey[500]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow:
                            _numeroActual < _numeroMaximo
                                ? [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                                : [],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap:
                              _numeroActual < _numeroMaximo
                                  ? _siguienteNumero
                                  : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: 14,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Siguiente',
                                  style: TextStyle(
                                    fontSize: buttonFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: iconSize,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ObjectAnimatedItem extends StatefulWidget {
  final String objeto;
  final Color color;
  final Duration delay;

  const _ObjectAnimatedItem({
    required Key key,
    required this.objeto,
    required this.color,
    required this.delay,
  }) : super(key: key);

  @override
  State<_ObjectAnimatedItem> createState() => _ObjectAnimatedItemState();
}

class _ObjectAnimatedItemState extends State<_ObjectAnimatedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    // Iniciar animación con retraso
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    final isTablet = screenWidth > 400 && screenWidth <= 600;

    // Tamaños responsivos para objetos más pequeños
    final objectSize = isDesktop ? 40.0 : (isTablet ? 35.0 : 30.0);
    final objectFontSize = isDesktop ? 24.0 : (isTablet ? 20.0 : 18.0);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: objectSize,
            height: objectSize,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.color.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                widget.objeto,
                style: TextStyle(fontSize: objectFontSize),
              ),
            ),
          ),
        );
      },
    );
  }
}
