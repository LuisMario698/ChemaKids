import 'package:flutter/material.dart';

class JuegoSilabasOrdenadas extends StatefulWidget {
  const JuegoSilabasOrdenadas({super.key});

  @override
  State<JuegoSilabasOrdenadas> createState() => _JuegoSilabasOrdenadasState();
}

class _JuegoSilabasOrdenadasState extends State<JuegoSilabasOrdenadas>
    with TickerProviderStateMixin {
  // Consonantes del abecedario en orden
  final List<String> _consonantes = [
    'B',
    'C',
    'D',
    'F',
    'G',
    'H',
    'J',
    'K',
    'L',
    'M',
    'N',
    'Ñ',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  // Vocales
  final List<String> _vocales = ['A', 'E', 'I', 'O', 'U'];

  int _consonanteActualIndex = 0;
  String? _consonanteSeleccionada;
  String? _vocalSeleccionada;
  String _silabaFormada = '';

  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _seleccionarConsonante(String consonante) {
    setState(() {
      _consonanteSeleccionada = consonante;
      _vocalSeleccionada = null;
      _silabaFormada = '';
    });
    _pulseController.forward().then((_) => _pulseController.reverse());
  }

  void _seleccionarVocal(String vocal) {
    if (_consonanteSeleccionada != null) {
      setState(() {
        _vocalSeleccionada = vocal;
        // Casos especiales
        if (_consonanteSeleccionada == 'Q') {
          _silabaFormada =
              vocal == 'E'
                  ? 'QUE'
                  : vocal == 'I'
                  ? 'QUI'
                  : 'Q$vocal';
        } else {
          _silabaFormada = '$_consonanteSeleccionada$vocal';
        }
      });
      _pulseController.forward().then((_) => _pulseController.reverse());
    } else {
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }

  void _anteriorConsonante() {
    setState(() {
      if (_consonanteActualIndex > 0) {
        _consonanteActualIndex--;
      } else {
        _consonanteActualIndex = _consonantes.length - 1;
      }
      _consonanteSeleccionada = null;
      _vocalSeleccionada = null;
      _silabaFormada = '';
    });
  }

  void _siguienteConsonante() {
    setState(() {
      if (_consonanteActualIndex < _consonantes.length - 1) {
        _consonanteActualIndex++;
      } else {
        _consonanteActualIndex = 0;
      }
      _consonanteSeleccionada = null;
      _vocalSeleccionada = null;
      _silabaFormada = '';
    });
  }

  void _reiniciar() {
    setState(() {
      _consonanteSeleccionada = null;
      _vocalSeleccionada = null;
      _silabaFormada = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81C784),
      appBar: AppBar(
        title: const Text('Sílabas Ordenadas'),
        backgroundColor: const Color(0xFF81C784).withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Instrucción principal
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text(
                  'Forma sílabas combinando consonantes con vocales',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30),

              // Navegación de consonantes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNavigationButton(
                    Icons.arrow_back_ios,
                    _anteriorConsonante,
                  ),
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      'Consonante: ${_consonantes[_consonanteActualIndex]}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  _buildNavigationButton(
                    Icons.arrow_forward_ios,
                    _siguienteConsonante,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Consonante actual grande
              AnimatedBuilder(
                animation: _pulseAnimation,
                child: GestureDetector(
                  onTap:
                      () => _seleccionarConsonante(
                        _consonantes[_consonanteActualIndex],
                      ),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color:
                          _consonanteSeleccionada ==
                                  _consonantes[_consonanteActualIndex]
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFF81C784),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _consonantes[_consonanteActualIndex],
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                builder: (context, child) {
                  return Transform.scale(
                    scale:
                        _consonanteSeleccionada ==
                                _consonantes[_consonanteActualIndex]
                            ? _pulseAnimation.value
                            : 1.0,
                    child: child,
                  );
                },
              ),

              const SizedBox(height: 30),

              // Mensaje de instrucción
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Text(
                  _consonanteSeleccionada == null
                      ? '1. Toca la consonante ${_consonantes[_consonanteActualIndex]} para seleccionarla'
                      : '2. Ahora toca una vocal para formar la sílaba',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30),

              // Vocales
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    _vocales.map((vocal) {
                      return AnimatedBuilder(
                        animation: _shakeAnimation,
                        child: GestureDetector(
                          onTap: () => _seleccionarVocal(vocal),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color:
                                  _vocalSeleccionada == vocal
                                      ? const Color(0xFFFF9800)
                                      : const Color(0xFFFFB74D),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                vocal,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        builder: (context, child) {
                          return Transform.translate(
                            offset:
                                _consonanteSeleccionada == null &&
                                        _shakeController.isAnimating
                                    ? Offset(_shakeAnimation.value, 0)
                                    : Offset.zero,
                            child: child,
                          );
                        },
                      );
                    }).toList(),
              ),

              const SizedBox(height: 40),

              // Sílaba formada
              if (_silabaFormada.isNotEmpty)
                Column(
                  children: [
                    const Text(
                      '¡Sílaba formada!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        _silabaFormada,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),

              const Spacer(),

              // Botón de reiniciar
              if (_silabaFormada.isNotEmpty)
                ElevatedButton(
                  onPressed: _reiniciar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Formar otra sílaba',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
