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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  final InvitadoService _invitadoService = InvitadoService.instance;

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

    // Iniciar animaciones
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB2EBF2),
              Color(0xFFFFF59D),
              Color(0xFFFFB0B0),
              Color(0xFFA5D6A7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Botón de regresar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 32,
                      ),
                      tooltip: 'Regresar',
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        width: isDesktop ? 500 : double.infinity,
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Título con emoji
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '🎮',
                                    style: TextStyle(fontSize: 48),
                                  ),
                                  const SizedBox(width: 16),
                                  Flexible(
                                    child: Text(
                                      '¡Jugar como Invitado!',
                                      style: TextStyle(
                                        fontSize: isDesktop ? 32 : 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Ingresa tu nombre y edad para empezar a jugar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Campo de nombre
                              _buildCampoTexto(
                                controller: _nombreController,
                                label: 'Tu nombre',
                                hint: 'Ej: María, Juan, Ana...',
                                icon: Icons.person,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Por favor ingresa tu nombre';
                                  }
                                  if (value.trim().length < 2) {
                                    return 'El nombre debe tener al menos 2 caracteres';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Campo de edad
                              _buildCampoTexto(
                                controller: _edadController,
                                label: 'Tu edad',
                                hint: 'Ej: 5, 6, 7...',
                                icon: Icons.cake,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Por favor ingresa tu edad';
                                  }
                                  final edad = int.tryParse(value);
                                  if (edad == null) {
                                    return 'Por favor ingresa un número válido';
                                  }
                                  if (edad < 3 || edad > 12) {
                                    return 'La edad debe estar entre 3 y 12 años';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 32),

                              // Botón de registro
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : _buildBotonRegistro(),

                              const SizedBox(height: 16),

                              // Información adicional
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.blue[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.blue[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Como invitado podrás jugar todos los niveles, pero tu progreso no se guardará.',
                                        style: TextStyle(
                                          color: Colors.blue[800],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
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
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildBotonRegistro() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _registrarInvitado,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.deepPurple.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.play_arrow, size: 24),
            SizedBox(width: 8),
            Text(
              '¡Empezar a Jugar!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
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
  int get nivel => 1; // Los invitados empiezan en nivel 1, el progreso se maneja por EstadoApp
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
