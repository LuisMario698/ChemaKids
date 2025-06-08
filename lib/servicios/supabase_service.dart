import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  
  SupabaseService._();
  
  late final SupabaseClient _client;
  SupabaseClient get client => _client;
  
  bool _initialized = false;
  bool get isInitialized => _initialized;
  
  /// Inicializa la conexión con Supabase
  Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    try {
      print('🚀 [SupabaseService] Inicializando conexión con Supabase...');
      
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
        debug: kDebugMode,
      );
      
      _client = Supabase.instance.client;
      _initialized = true;
      
      print('✅ [SupabaseService] Conexión establecida exitosamente');
      print('📊 [SupabaseService] URL: $url');
      print('🔑 [SupabaseService] Clave anónima configurada');
      
      // Verificar conexión
      await _testConnection();
      
    } catch (e) {
      print('❌ [SupabaseService] Error al inicializar Supabase: $e');
      _initialized = false;
      rethrow;
    }
  }
  
  /// Prueba la conexión a la base de datos
  Future<void> _testConnection() async {
    try {
      print('🔍 [SupabaseService] Probando conexión...');
      
      // Hacer una consulta simple para probar la conexión
      final response = await _client
          .from('juegos')
          .select('count')
          .count();
      
      print('✅ [SupabaseService] Conexión verificada - Respuesta: ${response.count}');
      
    } catch (e) {
      print('⚠️ [SupabaseService] Advertencia - No se pudo verificar la conexión: $e');
      // No lanzamos error aquí porque las tablas pueden no existir aún
    }
  }
  
  /// Obtiene el cliente de Supabase actual
  SupabaseClient getClient() {
    if (!_initialized) {
      throw Exception('SupabaseService no ha sido inicializado. Llama a initialize() primero.');
    }
    return _client;
  }
  
  /// Verifica si hay una sesión de usuario activa
  User? get currentUser {
    if (!_initialized) return null;
    return _client.auth.currentUser;
  }
  
  /// Obtiene la sesión actual
  Session? get currentSession {
    if (!_initialized) return null;
    return _client.auth.currentSession;
  }
  
  /// Cierra la conexión (opcional)
  Future<void> dispose() async {
    print('🔚 [SupabaseService] Cerrando conexión...');
    _initialized = false;
    print('✅ [SupabaseService] Conexión cerrada');
  }
  
  /// Manejo de errores centralizados
  void handleError(String operation, dynamic error) {
    print('❌ [SupabaseService] Error en $operation: $error');
    
    if (error is PostgrestException) {
      print('📋 [SupabaseService] Detalles del error PostgreSQL:');
      print('   - Código: ${error.code}');
      print('   - Mensaje: ${error.message}');
      print('   - Detalles: ${error.details}');
    }
  }

  /// Verifica si la conexión está activa
  bool get isConnected => _initialized;

  /// Método para testing - permite verificar la conexión
  Future<bool> testConnection() async {
    try {
      print('🔍 [SupabaseService] Probando conexión con Supabase...');
      
      if (!_initialized) {
        print('❌ [SupabaseService] Servicio no inicializado');
        return false;
      }
      
      // Intenta hacer una consulta simple para verificar la conexión
      await _client.from('usuario').select('count').limit(1);
      
      print('✅ [SupabaseService] Conexión con Supabase exitosa');
      return true;
      
    } catch (e) {
      print('❌ [SupabaseService] Error en la conexión con Supabase: $e');
      return false;
    }
  }

  /// Método estático para inicializar (compatible con DatabaseManager)
  static Future<void> initializeStatic({
    required String url,
    required String anonKey,
  }) async {
    await instance.initialize(url: url, anonKey: anonKey);
  }

  /// Método estático para cerrar conexión
  static Future<void> disposeStatic() async {
    await instance.dispose();
  }
}
