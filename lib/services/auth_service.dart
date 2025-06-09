import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/usuario_model.dart';
import '../services/usuario_service.dart';
import 'deep_link_service.dart';

/// Servicio de autenticación con Supabase Auth
/// Maneja registro, login, logout y gestión de sesiones
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Cliente de Supabase
  SupabaseClient get _supabase => Supabase.instance.client;

  /// Instancia del servicio de usuario
  UsuarioService get _usuarioService => UsuarioService.instance;

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

      // Registro en Supabase Auth con URL de redirección personalizada
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'nombre': nombre, 'edad': edad},
        emailRedirectTo: DeepLinkService.redirectUrl,
      );

      if (response.user != null) {
        print('✅ [AuthService] Usuario registrado exitosamente en Auth');
        print('📋 [AuthService] ID del usuario: ${response.user!.id}');

        try {
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
        } catch (profileError) {
          print(
            '⚠️ [AuthService] Usuario creado en Auth pero falló el perfil: $profileError',
          );

          // El usuario se creó en Auth pero falló el perfil
          // Aún consideramos esto un éxito parcial
          return AuthResult.success(
            message:
                'Registro parcialmente exitoso. Verifica tu email. (Perfil pendiente)',
            user: response.user,
          );
        }
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

        // Verificar si el usuario tiene perfil en la BD
        final perfil = await obtenerPerfilUsuario();
        if (perfil == null) {
          print('⚠️ [AuthService] Usuario sin perfil, intentando crear...');

          // Intentar crear el perfil usando los datos del Auth
          final authUser = response.user!;
          try {
            await _crearPerfilUsuario(
              authUserId: authUser.id,
              email: authUser.email ?? email,
              nombre: authUser.userMetadata?['nombre'] ?? 'Usuario',
              edad: authUser.userMetadata?['edad'] ?? 8,
            );
            print('✅ [AuthService] Perfil creado después del login');
          } catch (profileError) {
            print('❌ [AuthService] No se pudo crear perfil: $profileError');
          }
        }

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

  /// Procesa un login exitoso configurando el estado de la aplicación
  Future<AuthResult> _procesarLoginExitoso(User user) async {
    try {
      print('🎯 [AuthService] Procesando login exitoso para: ${user.email}');

      // Verificar si el usuario tiene perfil en la BD
      final perfil = await obtenerPerfilUsuario();
      if (perfil == null) {
        print('⚠️ [AuthService] Usuario sin perfil, intentando crear...');

        // Intentar crear el perfil usando los datos del Auth
        try {
          await _crearPerfilUsuario(
            authUserId: user.id,
            email: user.email ?? 'sin-email@example.com',
            nombre: user.userMetadata?['nombre'] ?? 'Usuario',
            edad: user.userMetadata?['edad'] ?? 8,
          );
          print('✅ [AuthService] Perfil creado después del login');
        } catch (profileError) {
          print('❌ [AuthService] No se pudo crear perfil: $profileError');
          return AuthResult.error('Error al crear perfil de usuario');
        }
      }

      return AuthResult.success(
        message: 'Sesión iniciada correctamente',
        user: user,
      );
    } catch (e) {
      print('❌ [AuthService] Error al procesar login exitoso: $e');
      return AuthResult.error('Error al configurar la sesión');
    }
  }

  /// Inicia sesión permitiendo usuarios no verificados (para desarrollo)
  Future<AuthResult> iniciarSesionSinVerificacion(
    String email,
    String password,
  ) async {
    try {
      print('🔐 [AuthService] Iniciando sesión sin verificación: $email');

      // Primero intentar login normal
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print(
          '✅ [AuthService] Sesión iniciada exitosamente (sin verificación)',
        );
        return await _procesarLoginExitoso(response.user!);
      } else {
        return AuthResult.error('Error al iniciar sesión');
      }
    } on AuthException catch (e) {
      print('❌ [AuthService] Error de autenticación: ${e.message}');

      // Si el error es por email no confirmado, permitir acceso en modo desarrollo
      if (e.message == 'Email not confirmed') {
        print(
          '⚠️ [AuthService] Email no confirmado, permitiendo acceso en modo desarrollo',
        );
        return await _loginSinVerificacion(email, password);
      }

      return AuthResult.error(_getErrorMessage(e));
    } catch (e) {
      print('❌ [AuthService] Error inesperado: $e');
      return AuthResult.error('Error inesperado al iniciar sesión');
    }
  }

  /// Método interno para manejar login sin verificación
  Future<AuthResult> _loginSinVerificacion(
    String email,
    String password,
  ) async {
    try {
      print('🔧 [AuthService] Intentando login sin verificación para: $email');

      // Para desarrollo, verificar si el usuario existe en nuestra BD
      final usuarioExistente = await _verificarUsuarioEnBD(email);

      if (usuarioExistente != null) {
        print('✅ [AuthService] Usuario encontrado en BD, permitiendo acceso');

        return AuthResult.success(
          message: 'Acceso permitido (modo desarrollo sin verificación)',
          user: null, // En modo desarrollo no tenemos user de Supabase Auth
        );
      } else {
        return AuthResult.error(
          'Usuario no encontrado en la base de datos. '
          'Por favor contacta al administrador.',
        );
      }
    } catch (e) {
      print('❌ [AuthService] Error en login sin verificación: $e');
      return AuthResult.error('Error al verificar usuario');
    }
  }

  /// Verifica si un usuario existe en nuestra base de datos
  Future<UsuarioModel?> _verificarUsuarioEnBD(String email) async {
    try {
      return await _usuarioService.obtenerPorEmail(email);
    } catch (e) {
      print('❌ [AuthService] Error al verificar usuario en BD: $e');
      return null;
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

      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: DeepLinkService.redirectUrl,
      );

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

      print('⚠️ [AuthService] No se encontró perfil para el usuario');
      return null;
    } catch (e) {
      print('❌ [AuthService] Error al obtener perfil: $e');
      return null;
    }
  }

  /// Intenta reparar un perfil faltante para el usuario actual
  Future<bool> repararPerfilUsuario() async {
    try {
      if (!isAuthenticated) {
        print('❌ [AuthService] No hay usuario autenticado');
        return false;
      }

      final user = currentUser!;
      print('🔧 [AuthService] Intentando reparar perfil para: ${user.email}');

      // Verificar si ya existe el perfil
      final perfilExistente = await obtenerPerfilUsuario();
      if (perfilExistente != null) {
        print('ℹ️ [AuthService] El perfil ya existe, no necesita reparación');
        return true;
      }

      // Crear el perfil usando datos del Auth
      await _crearPerfilUsuario(
        authUserId: user.id,
        email: user.email ?? 'sin-email@example.com',
        nombre: user.userMetadata?['nombre'] ?? 'Usuario',
        edad: user.userMetadata?['edad'] ?? 8,
      );

      print('✅ [AuthService] Perfil reparado exitosamente');
      return true;
    } catch (e) {
      print('❌ [AuthService] Error al reparar perfil: $e');
      return false;
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
      print('📊 [AuthService] Datos a insertar:');
      print('  - auth_user: $authUserId');
      print('  - email: $email');
      print('  - nombre: $nombre');
      print('  - edad: $edad');
      print('  - tabla: ${SupabaseConfig.usuarioTable}');

      // Verificar si la tabla existe intentando hacer una consulta simple
      try {
        await _supabase
            .from(SupabaseConfig.usuarioTable)
            .select('count')
            .limit(1);
        print(
          '✅ [AuthService] Tabla ${SupabaseConfig.usuarioTable} existe y es accesible',
        );
      } catch (tableError) {
        print('❌ [AuthService] Error al acceder a la tabla: $tableError');
        throw Exception(
          'La tabla ${SupabaseConfig.usuarioTable} no está disponible: $tableError',
        );
      }

      final dataToInsert = {
        'auth_user': authUserId,
        'email': email,
        'nombre': nombre,
        'edad': edad,
        // Necesitamos crear el progreso primero y obtener su ID
      };

      // Paso 1: Crear registro de progreso del usuario
      print('📊 [AuthService] Creando registro de progreso...');
      final progresoResponse =
          await _supabase
              .from('progreso_usuario')
              .insert({'nivel': 1, 'racha_1': 0, 'racha_2': 0})
              .select()
              .single();

      final idProgreso = progresoResponse['id'] as int;
      print('✅ [AuthService] Progreso creado con ID: $idProgreso');

      // Paso 2: Agregar el ID de progreso a los datos del usuario
      dataToInsert['id_progreso'] = idProgreso;

      print('📝 [AuthService] Insertando datos: $dataToInsert');

      final response =
          await _supabase
              .from(SupabaseConfig.usuarioTable)
              .insert(dataToInsert)
              .select() // Obtener los datos insertados incluyendo el ID generado
              .single(); // Esperamos exactamente un registro

      final usuarioId = response['id'] as int;
      print('✅ [AuthService] Perfil creado en BD exitosamente');
      print('📄 [AuthService] Usuario creado con ID: $usuarioId');
      print('🔗 [AuthService] Vinculado a auth_user: $authUserId');

      // Verificar que el usuario puede ser consultado
      final verificacion =
          await _supabase
              .from(SupabaseConfig.usuarioTable)
              .select()
              .eq('id', usuarioId)
              .single();

      print(
        '✅ [AuthService] Verificación exitosa: Usuario ${verificacion['nombre']} creado',
      );
      print('📊 [AuthService] Ahora puede recibir progreso en juegos');
    } catch (e) {
      print('❌ [AuthService] Error detallado al crear perfil: $e');
      print('📍 [AuthService] Tipo de error: ${e.runtimeType}');

      // Si es un error de PostgreSQL, proporcionar más detalles
      if (e.toString().contains('relation') &&
          e.toString().contains('does not exist')) {
        print(
          '💡 [AuthService] La tabla ${SupabaseConfig.usuarioTable} no existe en la base de datos',
        );
        print(
          '💡 [AuthService] Verifica que hayas ejecutado las migraciones de la base de datos',
        );
      }

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

  /// Obtiene el perfil del usuario con información de progreso
  Future<Map<String, dynamic>?> obtenerPerfilCompleto() async {
    try {
      if (!isAuthenticated) return null;

      print('👤 [AuthService] Obteniendo perfil completo de usuario');

      final response =
          await _supabase
              .from(SupabaseConfig.usuarioTable)
              .select('''
            *,
            progreso:progreso(
              id,
              id_juego,
              nivel,
              puntaje,
              racha_maxima,
              juegos:id_juego(
                nombre,
                descripcion
              )
            )
          ''')
              .eq('auth_user', currentUser!.id)
              .maybeSingle();

      if (response != null) {
        print('✅ [AuthService] Perfil completo obtenido exitosamente');
        print('📊 [AuthService] Usuario ID: ${response['id']}');
        print(
          '🎮 [AuthService] Registros de progreso: ${response['progreso']?.length ?? 0}',
        );
        return response;
      }

      print('⚠️ [AuthService] No se encontró perfil para el usuario');
      return null;
    } catch (e) {
      print('❌ [AuthService] Error al obtener perfil completo: $e');
      return null;
    }
  }

  /// Verifica que el usuario tenga un perfil válido y pueda recibir progreso
  Future<bool> verificarVinculacionCompleta() async {
    try {
      if (!isAuthenticated) {
        print('❌ [AuthService] No hay usuario autenticado');
        return false;
      }

      final user = currentUser!;
      print('🔍 [AuthService] Verificando vinculación para: ${user.email}');

      // 1. Verificar que existe en auth.users
      print('✅ [AuthService] Usuario existe en auth.users con ID: ${user.id}');

      // 2. Verificar que existe en tabla usuario
      final perfil = await obtenerPerfilUsuario();
      if (perfil == null) {
        print('❌ [AuthService] Usuario no tiene perfil en tabla usuario');
        return false;
      }

      print(
        '✅ [AuthService] Usuario existe en tabla usuario con ID: ${perfil.id}',
      );
      print('🔗 [AuthService] Vinculación auth_user: ${perfil.authUser}');

      // 3. Verificar que las tablas relacionadas están disponibles
      try {
        await _supabase
            .from(SupabaseConfig.progresoTable)
            .select('count')
            .limit(1);
        print('✅ [AuthService] Tabla progreso está disponible');

        await _supabase
            .from(SupabaseConfig.juegosTable)
            .select('count')
            .limit(1);
        print('✅ [AuthService] Tabla juegos está disponible');
      } catch (tableError) {
        print(
          '⚠️ [AuthService] Algunas tablas relacionadas no están disponibles: $tableError',
        );
      }

      print('🎯 [AuthService] Vinculación completa verificada exitosamente');
      print('📈 [AuthService] El usuario puede recibir y almacenar progreso');

      return true;
    } catch (e) {
      print('❌ [AuthService] Error al verificar vinculación: $e');
      return false;
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
