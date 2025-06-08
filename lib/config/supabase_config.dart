/// Configuración de Supabase para ChemaKids
///
/// IMPORTANTE: Estas credenciales son de ejemplo y deben ser reemplazadas
/// con las credenciales reales de tu proyecto Supabase.
///
/// Para obtener tus credenciales:
/// 1. Ve a https://supabase.com/dashboard
/// 2. Selecciona tu proyecto ChemaKids
/// 3. Ve a Settings > API
/// 4. Copia la URL y la anon key

class SupabaseConfig {
  // 🚨 REEMPLAZA ESTOS VALORES CON TUS CREDENCIALES REALES
  static const String supabaseUrl = 'https://iohasepuybqedahdgtxv.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlvaGFzZXB1eWJxZWRhaGRndHh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkyODI2MDYsImV4cCI6MjA2NDg1ODYwNn0.4X6EhiF3RP2w7UemHvqfVeuDYOVyO5R21cn_emYKmEA';

  // URLs de desarrollo (opcional para testing local)
  static const String devUrl = 'http://localhost:54321';
  static const String devAnonKey = 'tu-dev-key-aqui';

  // Determina si usar credenciales de desarrollo o producción
  static const bool isDevelopment = false;

  /// Obtiene la URL según el entorno
  static String get url => isDevelopment ? devUrl : supabaseUrl;

  /// Obtiene la clave anónima según el entorno
  static String get anonKey => isDevelopment ? devAnonKey : supabaseAnonKey;

  /// Configuración de la base de datos
  static const String schema = 'public';

  /// Nombres de las tablas
  static const String usuarioTable = 'usuario';
  static const String invitadoTable = 'invitado';
  static const String juegosTable = 'juegos';
  static const String progresoTable = 'progreso';

  /// Configuración de autenticación
  static const bool enableAuth = true;
  static const bool persistSession = true;
  static const bool autoRefreshToken = true;

  /// Configuración de real-time
  static const bool enableRealtime = true;

  /// Configuración de logging
  static const bool enableLogging = true;
  static const bool debugMode = true;
}

/// Instrucciones para configurar Supabase:
/// 
/// 1. Crea un proyecto en https://supabase.com
/// 2. Ejecuta el script SQL de database_schemas.sql en el SQL Editor
/// 3. Copia las credenciales desde Settings > API
/// 4. Reemplaza las credenciales en este archivo
/// 5. Considera usar variables de entorno para producción
/// 
/// Variables de entorno recomendadas:
/// - SUPABASE_URL
/// - SUPABASE_ANON_KEY
/// 
/// Ejemplo de uso con variables de entorno:
/// ```dart
/// static String get supabaseUrl => 
///   const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://tu-proyecto.supabase.co');
/// ```
