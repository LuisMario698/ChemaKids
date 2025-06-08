import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/deep_link_service.dart';

/// Pantalla para manejar autenticación y testing de deep links
class PantallaAuth extends StatefulWidget {
  const PantallaAuth({super.key});

  @override
  State<PantallaAuth> createState() => _PantallaAuthState();
}

class _PantallaAuthState extends State<PantallaAuth> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isLoginMode = true;
  String _mensaje = '';

  @override
  void dispose() {
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
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Iniciar Sesión' : 'Registrarse'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo o icono
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Título
                    Text(
                      _isLoginMode
                          ? '¡Bienvenido de vuelta!'
                          : '¡Únete a ChemaKids!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _isLoginMode
                          ? 'Inicia sesión para continuar tu aventura'
                          : 'Crea tu cuenta para comenzar a aprender',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Campos del formulario
                    if (!_isLoginMode) ...[
                      _buildTextField(
                        controller: _nombreController,
                        label: 'Nombre',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _edadController,
                        label: 'Edad',
                        icon: Icons.cake,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu edad';
                          }
                          final edad = int.tryParse(value);
                          if (edad == null || edad < 3 || edad > 12) {
                            return 'La edad debe estar entre 3 y 12 años';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Ingresa un email válido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Mensaje de estado
                    if (_mensaje.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              _mensaje.startsWith('✅')
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _mensaje,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Botón principal
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  _isLoginMode
                                      ? 'Iniciar Sesión'
                                      : 'Registrarse',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botón para cambiar modo
                    TextButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                setState(() {
                                  _isLoginMode = !_isLoginMode;
                                  _mensaje = '';
                                });
                              },
                      child: Text(
                        _isLoginMode
                            ? '¿No tienes cuenta? Regístrate'
                            : '¿Ya tienes cuenta? Inicia sesión',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Estado del usuario actual (si está autenticado)
                    if (_authService.isAuthenticated) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '✅ Usuario autenticado',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Email: ${_authService.currentUser?.email ?? "N/A"}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _verificarPerfil,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Verificar Perfil'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _repararPerfil,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Reparar Perfil'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _cerrarSesion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Cerrar Sesión'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Información sobre deep links
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🔗 Deep Link configurado',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'URL: ${DeepLinkService.redirectUrl}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.7)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
      ),
    );
  }

  Future<void> _verificarPerfil() async {
    setState(() {
      _isLoading = true;
      _mensaje = '';
    });

    try {
      final perfil = await _authService.obtenerPerfilUsuario();

      setState(() {
        if (perfil != null) {
          _mensaje =
              '✅ Perfil encontrado: ${perfil.nombre}';
        } else {
          _mensaje = '⚠️ No se encontró perfil en la base de datos';
        }
      });
    } catch (e) {
      setState(() {
        _mensaje = '❌ Error al verificar perfil: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _repararPerfil() async {
    setState(() {
      _isLoading = true;
      _mensaje = '';
    });

    try {
      final reparado = await _authService.repararPerfilUsuario();

      setState(() {
        _mensaje =
            reparado
                ? '✅ Perfil reparado exitosamente'
                : '❌ No se pudo reparar el perfil';
      });
    } catch (e) {
      setState(() {
        _mensaje = '❌ Error al reparar perfil: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _cerrarSesion() async {
    setState(() {
      _isLoading = true;
      _mensaje = '';
    });

    try {
      final success = await _authService.cerrarSesion();

      setState(() {
        _mensaje =
            success
                ? '✅ Sesión cerrada correctamente'
                : '❌ Error al cerrar sesión';
      });

      if (success) {
        // Limpiar formularios
        _emailController.clear();
        _passwordController.clear();
        _nombreController.clear();
        _edadController.clear();
      }
    } catch (e) {
      setState(() {
        _mensaje = '❌ Error al cerrar sesión: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _mensaje = '';
    });

    try {
      if (_isLoginMode) {
        // Iniciar sesión
        final result = await _authService.iniciarSesionSinVerificacion(
          _emailController.text.trim(),
          _passwordController.text,
        );

        setState(() {
          _mensaje =
              result.success
                  ? '🔍 Verificando perfil...'
                  : '❌ ${result.message}';
        });

        if (result.success) {
          // Verificar vinculación completa
          final vinculacionCompleta =
              await _authService.verificarVinculacionCompleta();

          setState(() {
            if (vinculacionCompleta) {
              _mensaje =
                  '✅ ¡Sesión iniciada!\n'
                  '🎮 Perfil completo y listo para jugar\n'
                  '📊 El progreso se guardará correctamente';
            } else {
              _mensaje =
                  '⚠️ Sesión iniciada pero perfil incompleto\n'
                  'Usa "Reparar Perfil" para corregir';
            }
          });

          // Navegar al menú principal si todo está bien
          if (vinculacionCompleta) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/menu');
              }
            });
          }
        }
      } else {
        // Registrarse
        final result = await _authService.registrarUsuario(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          nombre: _nombreController.text.trim(),
          edad: int.parse(_edadController.text),
        );

        setState(() {
          _mensaje =
              result.success
                  ? '🔍 Verificando registro...'
                  : '❌ ${result.message}';
        });

        if (result.success) {
          // Verificar que el perfil se creó correctamente
          await Future.delayed(const Duration(seconds: 1));

          final perfil = await _authService.obtenerPerfilUsuario();
          if (perfil != null) {
            setState(() {
              _mensaje =
                  '✅ ¡Registro completo!\n'
                  '👤 Usuario creado en Auth y BD\n'
                  '🎮 ID: ${perfil.id}\n'
                  '📧 Verifica tu email para continuar\n'
                  '🎯 ¡Listo para jugar y guardar progreso!';
            });
          } else {
            setState(() {
              _mensaje =
                  '⚠️ Usuario registrado en Auth pero no en BD.\n'
                  'Usa "Reparar Perfil" después de verificar email.';
            });
          }

          // Limpiar formulario y cambiar a modo login
          _passwordController.clear();
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _isLoginMode = true;
              });
            }
          });
        }
      }
    } catch (e) {
      setState(() {
        _mensaje = '❌ Error inesperado: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
