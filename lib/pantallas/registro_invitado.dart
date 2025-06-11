import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/invitado_model.dart';
import '../services/invitado_service.dart';
import '../services/estado_app.dart';
import '../screens/menu.dart';

/// Pantalla para registrar invitados que quieren jugar sin crear una cuenta
class PantallaRegistroInvitado extends StatefulWidget {
  const PantallaRegistroInvitado({super.key});

  @override
  State<PantallaRegistroInvitado> createState() =>
      _PantallaRegistroInvitadoState();
}

class _PantallaRegistroInvitadoState extends State<PantallaRegistroInvitado>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  bool _isLoading = false;

  final _invitadoService = InvitadoService.instance;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut));

    // Iniciar animaciones
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[200]!,
              Colors.purple[200]!,
              Colors.pink[200]!,
              Colors.orange[200]!,
            ],
            stops: const [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior con botón de regresar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Botón de regresar con efecto hover
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.arrow_back, color: Colors.white, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Regresar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido principal
              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: isDesktop ? 500 : double.infinity,
                          margin: const EdgeInsets.all(24),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.1),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Título animado con emoji
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RotationTransition(
                                      turns: _rotateAnimation,
                                      child: const Text(
                                        '🎮',
                                        style: TextStyle(fontSize: 48),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Flexible(
                                      child: Text(
                                        '¡Jugar como Invitado!',
                                        style: TextStyle(
                                          fontSize: isDesktop ? 32 : 28,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..shader = LinearGradient(
                                              colors: [
                                                Colors.purple,
                                                Colors.blue,
                                                Colors.purple,
                                              ],
                                            ).createShader(
                                              const Rect.fromLTWH(0, 0, 200, 70),
                                            ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Subtítulo animado
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      Colors.blue[400]!,
                                      Colors.purple[400]!,
                                    ],
                                  ).createShader(bounds),
                                  child: Text(
                                    '¡Prepárate para una aventura química!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 1.5,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Campo de nombre animado
                                _buildCampoTexto(
                                  controller: _nombreController,
                                  label: '¿Cómo te llamas?',
                                  hint: '¡Escribe tu nombre aquí!',
                                  icon: Icons.emoji_emotions,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return '¡Ups! No olvides escribir tu nombre';
                                    }
                                    if (value.trim().length < 2) {
                                      return 'Tu nombre debe tener al menos 2 letras';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Campo de edad animado
                                _buildCampoTexto(
                                  controller: _edadController,
                                  label: '¿Cuántos años tienes?',
                                  hint: 'Tu edad (3-12)',
                                  icon: Icons.cake,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return '¡No olvides decirnos tu edad!';
                                    }
                                    final edad = int.tryParse(value);
                                    if (edad == null) {
                                      return 'Por favor, escribe un número';
                                    }
                                    if (edad < 3 || edad > 12) {
                                      return 'La edad debe estar entre 3 y 12 años';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 32),

                                // Botón de registro animado
                                _isLoading
                                    ? const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.purple,
                                        ),
                                      )
                                    : _buildBotonRegistro(),

                                const SizedBox(height: 24),

                                // Mensaje informativo con diseño mejorado
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue[50]!,
                                        Colors.purple[50]!,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.blue[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.info_outline,
                                          color: Colors.blue[800],
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Como invitado podrás jugar todos los niveles, pero tu progreso no se guardará.',
                                          style: TextStyle(
                                            color: Colors.blue[900],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.purple, size: 24),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.purple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red[400]!, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red[400]!, width: 2),
        ),
        errorStyle: TextStyle(
          color: Colors.red[400],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBotonRegistro() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple,
            Colors.blue[600]!,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _registrarInvitado,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.play_circle_filled,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Text(
                    '¡Empezar a Jugar!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registrarInvitado() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final nombre = _nombreController.text.trim();
      final edad = int.parse(_edadController.text.trim());

      print('🎮 [RegistroInvitado] Registrando invitado: $nombre, edad: $edad');

      // Crear invitado con id de progreso inicial (se asignará en el servicio)
      final nuevoInvitado = InvitadoModel(
        id: 0, // Se asignará automáticamente en la base de datos
        nombre: nombre,
        edad: edad,
        idProgreso: 0, // Se asignará automáticamente en el servicio
      );

      final invitadoCreado = await _invitadoService.crear(nuevoInvitado);

      print(
        '✅ [RegistroInvitado] Invitado creado: ${invitadoCreado.toString()}',
      );

      if (mounted) {
        // Establecer el invitado en el estado de la app
        final estadoApp = context.read<EstadoApp>();
        await estadoApp.establecerUsuarioInvitado(invitadoCreado);

        print('✅ [RegistroInvitado] Estado de la app actualizado con invitado');

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('¡Bienvenid@ $nombre! 🎉'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navegar al menú después de un breve delay
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const PantallaMenu();
              },
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(
                  begin: begin,
                  end: end,
                ).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ [RegistroInvitado] Error al crear invitado: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Error al registrar. Inténtalo de nuevo.'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

/// Clase auxiliar para manejar usuarios invitados en el menú
class UsuarioInvitado {
  final InvitadoModel invitado;

  UsuarioInvitado({required this.invitado});

  String get nombre => invitado.nombre;
  int get nivel =>
      1; // Los invitados empiezan en nivel 1, el progreso se maneja por EstadoApp
  int get edad => invitado.edad;

  // Métodos compatibles con el sistema de menú
  bool nivelDesbloqueado(int nivel) =>
      true; // Los invitados tienen acceso a todos los niveles

  void desbloquearNivel(int nivel) {
    // Los invitados no guardan progreso permanente
    print(
      '🎮 [UsuarioInvitado] Nivel $nivel desbloqueado para invitado ${invitado.nombre}',
    );
  }

  void actualizarPuntuacion(String nivel, int puntos) {
    // Los invitados no guardan puntuaciones permanentes
    print(
      '🎮 [UsuarioInvitado] Puntuación $puntos en nivel $nivel para invitado ${invitado.nombre}',
    );
  }
}