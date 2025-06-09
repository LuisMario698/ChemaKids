import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/estado_app.dart';
import '../widgets/boton_animado.dart';

class PantallaNombreEdad extends StatefulWidget {
  final bool esLogin;

  const PantallaNombreEdad({super.key, this.esLogin = false});

  @override
  State<PantallaNombreEdad> createState() => _PantallaNombreEdadState();
}

class _PantallaNombreEdadState extends State<PantallaNombreEdad>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final AuthService _authService = AuthService();

  // Controladores de formulario
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  // Estado del formulario
  bool _isRegistro = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();

    // Configurar el estado inicial según el parámetro
    _isRegistro = !widget.esLogin;

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Iniciar animaciones
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nombreController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A0944),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Botón de cerrar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    // Verificar si hay sesión activa para mostrar botón de cerrar sesión
                    if (_authService.isAuthenticated)
                      TextButton.icon(
                        onPressed: _cerrarSesion,
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // Título animado
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    _isRegistro
                        ? '¡Únete a ChemaKids!'
                        : '¡Bienvenido de vuelta!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 10),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    _isRegistro
                        ? 'Crea tu cuenta para guardar tu progreso'
                        : 'Inicia sesión para continuar tu aventura',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),

                // Formulario animado
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          // Campos del formulario
          if (_isRegistro) ...[
            _buildTextField(
              controller: _nombreController,
              label: 'Nombre',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _edadController,
              label: 'Edad',
              icon: Icons.cake,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
            ),
            const SizedBox(height: 16),
          ],

          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _passwordController,
            label: 'Contraseña',
            icon: Icons.lock,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.white.withOpacity(0.7),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),

          const SizedBox(height: 24),

          // Mensajes de error/éxito
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

          if (_successMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _successMessage!,
                      style: const TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

          // Botón principal
          BotonAnimado(
            onTap: _isLoading ? () {} : _submitForm,
            child:
                _isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Text(
                      _isRegistro ? 'Registrarse' : 'Iniciar Sesión',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
          ),

          const SizedBox(height: 16),

          // Alternar entre registro e inicio de sesión
          TextButton(
            onPressed:
                _isLoading
                    ? null
                    : () {
                      setState(() {
                        _isRegistro = !_isRegistro;
                        _errorMessage = null;
                        _successMessage = null;
                      });
                    },
            child: RichText(
              text: TextSpan(
                text:
                    _isRegistro
                        ? '¿Ya tienes una cuenta? '
                        : '¿No tienes cuenta? ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: _isRegistro ? 'Inicia Sesión' : 'Regístrate',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.yellow, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    // Limpiar mensajes anteriores
    setState(() {
      _errorMessage = null;
      _successMessage = null;
      _isLoading = true;
    });

    // Validar campos
    if (!_validateFields()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      if (_isRegistro) {
        await _registrarUsuario();
      } else {
        await _iniciarSesion();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateFields() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor ingresa tu email';
      });
      return false;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        _errorMessage = 'Ingresa un email válido';
      });
      return false;
    }

    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor ingresa tu contraseña';
      });
      return false;
    }

    if (_isRegistro) {
      final nombre = _nombreController.text.trim();
      final edadText = _edadController.text;

      if (nombre.isEmpty) {
        setState(() {
          _errorMessage = 'Por favor ingresa tu nombre';
        });
        return false;
      }

      if (edadText.isEmpty) {
        setState(() {
          _errorMessage = 'Por favor ingresa tu edad';
        });
        return false;
      }

      final edad = int.tryParse(edadText);
      if (edad == null || edad < 3 || edad > 12) {
        setState(() {
          _errorMessage = 'La edad debe estar entre 3 y 12 años';
        });
        return false;
      }

      if (password.length < 6) {
        setState(() {
          _errorMessage = 'La contraseña debe tener al menos 6 caracteres';
        });
        return false;
      }
    }

    return true;
  }

  Future<void> _registrarUsuario() async {
    final result = await _authService.registrarUsuario(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      nombre: _nombreController.text.trim(),
      edad: int.parse(_edadController.text),
    );

    if (mounted) {
      if (result.success) {
        setState(() {
          _successMessage = result.message;
        });

        // Si el usuario se registró exitosamente, intentar obtener su perfil
        if (result.user != null) {
          try {
            final perfil = await _authService.obtenerPerfilUsuario();
            if (perfil != null) {
              // Actualizar el EstadoApp con el usuario registrado
              final estadoApp = context.read<EstadoApp>();
              await estadoApp.establecerUsuarioAutenticado(perfil);

              print(
                '✅ [PantallaNombreEdad] Usuario registrado y EstadoApp actualizado',
              );
            }
          } catch (e) {
            print(
              '⚠️ [PantallaNombreEdad] Error al obtener perfil después del registro: $e',
            );
          }
        }

        // Mostrar diálogo de verificación de email
        _showEmailVerificationDialog();
      } else {
        setState(() {
          _errorMessage = result.message;
        });
      }
    }
  }

  Future<void> _iniciarSesion() async {
    final result = await _authService.iniciarSesionSinVerificacion(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted) {
      if (result.success) {
        // Obtener el perfil del usuario autenticado
        try {
          final perfil = await _authService.obtenerPerfilUsuario();
          if (perfil != null) {
            // Actualizar el EstadoApp con el usuario autenticado
            final estadoApp = context.read<EstadoApp>();
            await estadoApp.establecerUsuarioAutenticado(perfil);

            print(
              '✅ [PantallaNombreEdad] Usuario autenticado y EstadoApp actualizado',
            );
          }
        } catch (e) {
          print('⚠️ [PantallaNombreEdad] Error al obtener perfil: $e');
        }

        // Regresar al menú principal
        Navigator.of(context).pop();
      } else {
        setState(() {
          _errorMessage = result.message;
        });
      }
    }
  }

  Future<void> _cerrarSesion() async {
    final success = await _authService.cerrarSesion();
    if (success && mounted) {
      setState(() {
        _successMessage = 'Sesión cerrada exitosamente';
      });
      // Actualizar el estado del widget
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _successMessage = null;
          });
        }
      });
    }
  }

  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A0944),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.email, color: Colors.yellow, size: 30),
              SizedBox(width: 10),
              Text('Verifica tu email', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hemos enviado un email de verificación a:',
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
              const SizedBox(height: 8),
              Text(
                _emailController.text.trim(),
                style: const TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Por favor revisa tu correo y haz clic en el enlace de verificación para activar tu cuenta.',
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(
                  context,
                ).pop(); // Cerrar también la pantalla de registro
              },
              child: const Text(
                'Entendido',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _authService.reenviarVerificacion(
                  _emailController.text.trim(),
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email de verificación reenviado'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text(
                'Reenviar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
