import 'package:flutter/material.dart';
import '../widgets/tema_juego_chemakids.dart';
import '../services/tts_service.dart';

class JuegoPresentacionSumas extends StatefulWidget {
  const JuegoPresentacionSumas({super.key});

  @override
  State<JuegoPresentacionSumas> createState() => _JuegoPresentacionSumasState();
}

class _JuegoPresentacionSumasState extends State<JuegoPresentacionSumas> with TickerProviderStateMixin {
  int _sumaActual = 0;
  final int _sumaMaxima = 7; // Sumas del 1+1 hasta el 3+3
  late AnimationController _numeroController;
  late AnimationController _pulseController;
  late Animation<double> _numeroAnimation;
  late Animation<double> _pulseAnimation;
  final TTSService _ttsService = TTSService();
  bool _isPlayingAudio = false;
  late ScrollController _selectorScrollController;

  // Lista de sumas simples para enseñar el concepto
  final List<Map<String, dynamic>> _sumas = [
    {
      'operacion': '1 + 1',
      'numero1': 1,
      'numero2': 1,
      'resultado': 2,
      'objetosGrupo1': ['🍎'],
      'objetosGrupo2': ['🍎'],
      'objetosTotal': ['🍎', '🍎'],
      'color': const Color(0xFFE91E63),
      'descripcion': 'Una manzana más una manzana son dos manzanas',
      'explicacion': 'Cuando juntamos una cosa con otra cosa, obtenemos dos cosas',
    },
    {
      'operacion': '1 + 2',
      'numero1': 1,
      'numero2': 2,
      'resultado': 3,
      'objetosGrupo1': ['🟡'],
      'objetosGrupo2': ['🟡', '🟡'],
      'objetosTotal': ['🟡', '🟡', '🟡'],
      'color': const Color(0xFF2196F3),
      'descripcion': 'Un círculo más dos círculos son tres círculos',
      'explicacion': 'Sumar significa juntar grupos para contar cuántos hay en total',
    },
    {
      'operacion': '2 + 1',
      'numero1': 2,
      'numero2': 1,
      'resultado': 3,
      'objetosGrupo1': ['🚗', '🚗'],
      'objetosGrupo2': ['🚗'],
      'objetosTotal': ['🚗', '🚗', '🚗'],
      'color': const Color(0xFF4CAF50),
      'descripcion': 'Dos carros más un carro son tres carros',
      'explicacion': 'No importa el orden: 2 + 1 es igual que 1 + 2',
    },
    {
      'operacion': '2 + 2',
      'numero1': 2,
      'numero2': 2,
      'resultado': 4,
      'objetosGrupo1': ['🌟', '🌟'],
      'objetosGrupo2': ['🌟', '🌟'],
      'objetosTotal': ['🌟', '🌟', '🌟', '🌟'],
      'color': const Color(0xFFFF9800),
      'descripcion': 'Dos estrellas más dos estrellas son cuatro estrellas',
      'explicacion': 'Cuando sumamos números iguales, obtenemos el doble',
    },
    {
      'operacion': '1 + 3',
      'numero1': 1,
      'numero2': 3,
      'resultado': 4,
      'objetosGrupo1': ['🎈'],
      'objetosGrupo2': ['🎈', '🎈', '🎈'],
      'objetosTotal': ['🎈', '🎈', '🎈', '🎈'],
      'color': const Color(0xFF9C27B0),
      'descripcion': 'Un globo más tres globos son cuatro globos',
      'explicacion': 'Podemos sumar números diferentes para obtener el mismo resultado',
    },
    {
      'operacion': '3 + 1',
      'numero1': 3,
      'numero2': 1,
      'resultado': 4,
      'objetosGrupo1': ['🐶', '🐶', '🐶'],
      'objetosGrupo2': ['🐶'],
      'objetosTotal': ['🐶', '🐶', '🐶', '🐶'],
      'color': const Color(0xFF009688),
      'descripcion': 'Tres perritos más un perrito son cuatro perritos',
      'explicacion': 'Otra forma de hacer cuatro: cambiamos el orden de los números',
    },
    {
      'operacion': '2 + 3',
      'numero1': 2,
      'numero2': 3,
      'resultado': 5,
      'objetosGrupo1': ['🎁', '🎁'],
      'objetosGrupo2': ['🎁', '🎁', '🎁'],
      'objetosTotal': ['🎁', '🎁', '🎁', '🎁', '🎁'],
      'color': const Color(0xFFFF5722),
      'descripcion': 'Dos regalos más tres regalos son cinco regalos',
      'explicacion': 'Sumar nos ayuda a contar rápidamente cuántos objetos tenemos',
    },
    {
      'operacion': '3 + 3',
      'numero1': 3,
      'numero2': 3,
      'resultado': 6,
      'objetosGrupo1': ['🦆', '🦆', '🦆'],
      'objetosGrupo2': ['🦆', '🦆', '🦆'],
      'objetosTotal': ['🦆', '🦆', '🦆', '🦆', '🦆', '🦆'],
      'color': const Color(0xFF795548),
      'descripcion': 'Tres patitos más tres patitos son seis patitos',
      'explicacion': '¡Felicidades! Ya sabes cómo funciona la suma',
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

    _selectorScrollController = ScrollController();

    _numeroAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _numeroController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
    _numeroController.forward();
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _pulseController.dispose();
    _selectorScrollController.dispose();
    super.dispose();
  }

  void _siguienteSuma() {
    if (_sumaActual < _sumaMaxima) {
      _numeroController.reset();
      setState(() {
        _sumaActual++;
      });
      _numeroController.forward();
      _scrollToCurrentSuma();
    }
  }

  void _sumaAnterior() {
    if (_sumaActual > 0) {
      _numeroController.reset();
      setState(() {
        _sumaActual--;
      });
      _numeroController.forward();
      _scrollToCurrentSuma();
    }
  }

  void _irASuma(int suma) {
    if (suma >= 0 && suma <= _sumaMaxima && suma != _sumaActual) {
      _numeroController.reset();
      setState(() {
        _sumaActual = suma;
      });
      _numeroController.forward();
      _scrollToCurrentSuma();
    }
  }

  void _scrollToCurrentSuma() {
    if (_selectorScrollController.hasClients) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isDesktop = screenWidth > 600;
      final isTablet = screenWidth > 400 && screenWidth <= 600;
      final selectorItemSize = isDesktop ? 60.0 : (isTablet ? 55.0 : 50.0);

      const marginPerItem = 12.0;
      final itemWidth = selectorItemSize + marginPerItem;
      final targetOffset = _sumaActual * itemWidth - (screenWidth / 2 - itemWidth / 2);
      final maxOffset = _selectorScrollController.position.maxScrollExtent;
      final clampedOffset = targetOffset.clamp(0.0, maxOffset);

      _selectorScrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _reproducirSuma() async {
    if (_isPlayingAudio) return;

    setState(() {
      _isPlayingAudio = true;
    });

    try {
      final sumaData = _sumas[_sumaActual];
      await _ttsService.speak(
        "Observa: tenemos ${sumaData['numero1']} objeto${sumaData['numero1'] > 1 ? 's' : ''} "
        "más ${sumaData['numero2']} objeto${sumaData['numero2'] > 1 ? 's' : ''}. "
        "Cuando los juntamos, obtenemos ${sumaData['resultado']} objetos en total. "
        "${sumaData['operacion']} es igual a ${sumaData['resultado']}."
      );
    } catch (e) {
      print('❌ Error reproduciendo suma: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    }
  }

  Future<void> _reproducirExplicacion() async {
    if (_isPlayingAudio) return;

    setState(() {
      _isPlayingAudio = true;
    });

    try {
      final sumaData = _sumas[_sumaActual];
      await _ttsService.speak(sumaData['explicacion']);
    } catch (e) {
      print('❌ Error reproduciendo explicación: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    }
  }

  void _mostrarAyuda() {
    final sumaData = _sumas[_sumaActual];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: sumaData['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calculate, color: sumaData['color'], size: 32),
              const SizedBox(width: 8),
              Text(
                'Suma ${sumaData['operacion']}',
                style: TextStyle(
                  color: sumaData['color'],
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
            Text(
              sumaData['descripcion'],
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              sumaData['explicacion'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('Grupo 1', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Row(
                        children: sumaData['objetosGrupo1'].map<Widget>((objeto) => 
                          Text(objeto, style: const TextStyle(fontSize: 24))
                        ).toList(),
                      ),
                      Text('${sumaData['numero1']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Text('+', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  Column(
                    children: [
                      Text('Grupo 2', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Row(
                        children: sumaData['objetosGrupo2'].map<Widget>((objeto) => 
                          Text(objeto, style: const TextStyle(fontSize: 24))
                        ).toList(),
                      ),
                      Text('${sumaData['numero2']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Text('=', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  Column(
                    children: [
                      Text('Total', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Wrap(
                        children: sumaData['objetosTotal'].map<Widget>((objeto) => 
                          Text(objeto, style: const TextStyle(fontSize: 20))
                        ).toList(),
                      ),
                      Text('${sumaData['resultado']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: sumaData['color'])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Entendido',
              style: TextStyle(
                color: sumaData['color'],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectsGrid(List<dynamic> objetos, {bool isTotal = false}) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: List.generate(
        objetos.length,
        (index) => TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 150)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isTotal ? Colors.yellow[50] : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isTotal ? Colors.orange[400]! : Colors.grey[400]!,
                    width: isTotal ? 2.5 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isTotal ? Colors.orange : Colors.grey[400]!).withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  objetos[index],
                  style: TextStyle(
                    fontSize: 36,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    final isTablet = screenWidth > 400 && screenWidth <= 600;
    
    final sumaData = _sumas[_sumaActual];
    
    // Tamaños responsivos
    final numberFontSize = isDesktop ? 52.0 : (isTablet ? 46.0 : 40.0);
    final wordFontSize = isDesktop ? 30.0 : (isTablet ? 26.0 : 22.0);
    final buttonFontSize = isDesktop ? 20.0 : (isTablet ? 18.0 : 16.0);
    final horizontalPadding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);

    return PlantillaJuegoChemaKids(
      titulo: '🧮 Aprende a Sumar',
      icono: Icons.calculate,
      onAyuda: _mostrarAyuda,
      contenido: Column(
        children: [
          const SizedBox(height: 16),
          
          // Indicador de progreso mejorado con mejor contraste
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.08)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Suma ${_sumaActual + 1} de ${_sumaMaxima + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: (_sumaActual + 1) / (_sumaMaxima + 1),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              sumaData['color'],
                              sumaData['color'].withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: sumaData['color'].withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Contenido principal de la suma
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Operación matemática principal con mejor contraste
                    AnimatedBuilder(
                      animation: _numeroAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _numeroAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  sumaData['color'],
                                  sumaData['color'].withOpacity(0.85),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: sumaData['color'].withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              '${sumaData['operacion']} = ${sumaData['resultado']}',
                              style: TextStyle(
                                fontSize: numberFontSize,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                    color: Colors.black38,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 20),

                    // Descripción de la suma con mejor contraste
                    AnimatedBuilder(
                      animation: _numeroAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - _numeroAnimation.value)),
                          child: Opacity(
                            opacity: _numeroAnimation.value.clamp(0.0, 1.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                sumaData['descripcion'],
                                style: TextStyle(
                                  fontSize: wordFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.3,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black38,
                                      blurRadius: 3,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 20),

                    // Visualización de los grupos
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                      ),
                      child: Column(
                        children: [
                          // Grupos separados
                          Row(
                            children: [
                              // Grupo 1
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Grupo 1',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Colors.blue[300]!, width: 2),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildObjectsGrid(sumaData['objetosGrupo1']),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${sumaData['numero1']}',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Símbolo +
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange[400],
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              // Grupo 2
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Grupo 2',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Colors.green[300]!, width: 2),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildObjectsGrid(sumaData['objetosGrupo2']),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${sumaData['numero2']}',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Símbolo =
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.purple[400],
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '=',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Resultado total
                          Column(
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[100],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.orange[400]!, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    _buildObjectsGrid(sumaData['objetosTotal'], isTotal: true),
                                    const SizedBox(height: 12),
                                    Text(
                                      '${sumaData['resultado']}',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Botones de audio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Botón explicar suma
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green[400]!, Colors.green[600]!],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: _reproducirSuma,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding - 8,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isPlayingAudio ? Icons.volume_up : Icons.play_circle,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Explicar',
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

                        // Botón consejos
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple[400]!, Colors.purple[600]!],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: _reproducirExplicacion,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding - 8,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lightbulb,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Consejo',
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
                      ],
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
                  'Selecciona una suma:',
                  style: TextStyle(
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 12),

                // Selector rápido de sumas
                Container(
                  height: 70,
                  child: ListView.builder(
                    controller: _selectorScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    itemCount: _sumaMaxima + 1,
                    itemBuilder: (context, index) {
                      final isSelected = index == _sumaActual;
                      final colorSuma = _sumas[index]['color'];

                      return GestureDetector(
                        onTap: () => _irASuma(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? colorSuma : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorSuma,
                              width: isSelected ? 3 : 2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: colorSuma.withOpacity(0.4),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                          ),
                          child: Center(
                            child: Text(
                              _sumas[index]['operacion'],
                              style: TextStyle(
                                fontSize: isSelected ? buttonFontSize : buttonFontSize - 2,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : colorSuma,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
                          colors: _sumaActual > 0
                              ? [Colors.blue[400]!, Colors.blue[600]!]
                              : [Colors.grey[400]!, Colors.grey[500]!],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: _sumaActual > 0
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
                          onTap: _sumaActual > 0 ? _sumaAnterior : null,
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
                                  size: 28,
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
                          colors: _sumaActual < _sumaMaxima
                              ? [Colors.orange[400]!, Colors.orange[600]!]
                              : [Colors.grey[400]!, Colors.grey[500]!],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: _sumaActual < _sumaMaxima
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
                          onTap: _sumaActual < _sumaMaxima ? _siguienteSuma : null,
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
                                  size: 28,
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