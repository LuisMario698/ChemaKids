import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/usuario_model.dart';

/// Servicio de autenticación con Supabase Auth
/// Maneja registro, login, logout y gestión de sesiones
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Cliente de Supabase
  SupabaseClient get _supabase => Supabase.instance.client;

  /// Obtiene el usuario actual autenticado
  User? get currentUser => _supabase.auth.currentUser;

  /// Verifica si hay una sesión activa
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  /// Stream de cambios en el estado de autenticación
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Registra un nuevo usuario con email y contraseña
  Future<AuthResult> registrarUsuario({
    required String email,
    required String password,
    required String nombre,
    required int edad,
  }) async {
    try {
      print('🔐 [AuthService] Registrando usuario: $email');

      // Registro en Supabase Auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'nombre': nombre, 'edad': edad},
      );

      if (response.user != null) {
        print('✅ [AuthService] Usuario registrado exitosamente');

        // Crear perfil en la tabla usuario
        await _crearPerfilUsuario(
          authUserId: response.user!.id,
          email: email,
          nombre: nombre,
          edad: edad,
        );

        return AuthResult.success(
          message: 'Registro exitoso. Por favor verifica tu email.',
          user: response.user,
        );
      } else {
        return AuthResult.error('Error en el registro');
      }
    } on AuthException catch (e) {
      print('❌ [AuthService] Error de autenticación: ${e.message}');
      return AuthResult.error(_getErrorMessage(e));
    } catch (e) {
      print('❌ [AuthService] Error inesperado: $e');
      return AuthResult.error('Error inesperado en el registro');
    }
  }

  /// Inicia sesión con email y contraseña
  Future<AuthResult> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 [AuthService] Iniciando sesión: $email');

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('✅ [AuthService] Sesión iniciada exitosamente');
        return AuthResult.success(
          message: 'Sesión iniciada correctamente',
          user: response.user,
        );
      } else {
        return AuthResult.error('Error al iniciar sesión');
      }
    } on AuthException catch (e) {
      print('❌ [AuthService] Error de autenticación: ${e.message}');
      return AuthResult.error(_getErrorMessage(e));
    } catch (e) {
      print('❌ [AuthService] Error inesperado: $e');
      return AuthResult.error('Error inesperado al iniciar sesión');
    }
  }

  /// Cierra la sesión actual
  Future<bool> cerrarSesion() async {
    try {
      print('🔐 [AuthService] Cerrando sesión');

      await _supabase.auth.signOut();

      print('✅ [AuthService] Sesión cerrada exitosamente');
      return true;
    } catch (e) {
      print('❌ [AuthService] Error al cerrar sesión: $e');
      return false;
    }
  }

  /// Reenvía el email de verificación
  Future<bool> reenviarVerificacion(String email) async {
    try {
      print('📧 [AuthService] Reenviando verificación a: $email');

      await _supabase.auth.resend(type: OtpType.signup, email: email);

      print('✅ [AuthService] Email de verificación enviado');
      return true;
    } catch (e) {
      print('❌ [AuthService] Error al reenviar verificación: $e');
      return false;
    }
  }

  /// Obtiene el perfil del usuario desde la base de datos
  Future<UsuarioModel?> obtenerPerfilUsuario() async {
    try {
      if (!isAuthenticated) return null;

      print('👤 [AuthService] Obteniendo perfil de usuario');

      final response =
          await _supabase
              .from(SupabaseConfig.usuarioTable)
              .select()
              .eq('auth_user', currentUser!.id)
              .maybeSingle();

      if (response != null) {
        print('✅ [AuthService] Perfil obtenido exitosamente');
        return UsuarioModel.fromJson(response);
      }

      return null;
    } catch (e) {
      print('❌ [AuthService] Error al obtener perfil: $e');
      return null;
    }
  }

  /// Crea el perfil del usuario en la tabla usuario
  Future<void> _crearPerfilUsuario({
    required String authUserId,
    required String email,
    required String nombre,
    required int edad,
  }) async {
    try {
      print('👤 [AuthService] Creando perfil de usuario en BD');

      await _supabase.from(SupabaseConfig.usuarioTable).insert({
        'auth_user': authUserId,
        'email': email,
        'nombre': nombre,
        'edad': edad,
        'nivel': 1, // Nivel inicial
      });

      print('✅ [AuthService] Perfil creado en BD');
    } catch (e) {
      print('❌ [AuthService] Error al crear perfil: $e');
      rethrow;
    }
  }

  /// Convierte errores de Supabase a mensajes amigables
  String _getErrorMessage(AuthException e) {
    switch (e.message) {
      case 'Invalid login credentials':
        return 'Email o contraseña incorrectos';
      case 'Email not confirmed':
        return 'Por favor verifica tu email antes de iniciar sesión';
      case 'User already registered':
        return 'Ya existe una cuenta con este email';
      case 'Password should be at least 6 characters':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'Signup requires a valid password':
        return 'Se requiere una contraseña válida';
      case 'Invalid email format':
        return 'Formato de email inválido';
      default:
        return e.message;
    }
  }
}

/// Resultado de operaciones de autenticación
class AuthResult {
  final bool success;
  final String message;
  final User? user;

  AuthResult._({required this.success, required this.message, this.user});

  factory AuthResult.success({required String message, User? user}) {
    return AuthResult._(success: true, message: message, user: user);
  }

  factory AuthResult.error(String message) {
    return AuthResult._(success: false, message: message);
  }
}
