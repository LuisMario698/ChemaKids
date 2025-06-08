
import '../config/supabase_config.dart';
import 'supabase_service.dart';
import 'usuario_service.dart';
import 'invitado_service.dart';
import 'juego_service.dart';
import 'progreso_service.dart';

/// Gestor centralizado para todos los servicios de base de datos
/// Este archivo proporciona un punto único de acceso a todos los servicios
class DatabaseManager {
  static DatabaseManager? _instance;
  
  DatabaseManager._();
  
  static DatabaseManager get instance {
    _instance ??= DatabaseManager._();
    return _instance!;
  }

  // Servicios disponibles
  UsuarioService get usuarios => UsuarioService.instance;
  InvitadoService get invitados => InvitadoService.instance;
  JuegoService get juegos => JuegoService.instance;
  ProgresoService get progreso => ProgresoService.instance;

  /// Inicializa todos los servicios de base de datos
  Future<bool> inicializar() async {
    try {
      print('🚀 Iniciando DatabaseManager...');
      print('🔧 Configuración:');
      print('   🌐 URL: ${SupabaseConfig.url}');
      print('   🔑 Entorno: ${SupabaseConfig.isDevelopment ? "Desarrollo" : "Producción"}');
      print('   📊 Logging: ${SupabaseConfig.enableLogging ? "Habilitado" : "Deshabilitado"}');
      
      // Inicializar Supabase
      await SupabaseService.initializeStatic(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
      );

      // Verificar conexión
      final connectionTest = await SupabaseService.instance.testConnection();
      
      if (!connectionTest) {
        print('❌ Fallo en la prueba de conexión');
        return false;
      }

      print('✅ DatabaseManager inicializado exitosamente');
      print('📋 Servicios disponibles:');
      print('   👤 UsuarioService: Listo');
      print('   👥 InvitadoService: Listo');
      print('   🎮 JuegoService: Listo');
      print('   📈 ProgresoService: Listo');
      
      return true;
      
    } catch (e) {
      print('❌ Error al inicializar DatabaseManager: $e');
      return false;
    }
  }

  /// Verifica el estado de todos los servicios
  Future<Map<String, bool>> verificarEstadoServicios() async {
    final estados = <String, bool>{};
    
    try {
      print('🔍 Verificando estado de servicios...');
      
      // Verificar conexión base
      estados['conexion'] = SupabaseService.instance.isConnected;
      
      // Verificar cada servicio con una operación simple
      try {
        await usuarios.obtenerTodos();
        estados['usuarios'] = true;
        print('   ✅ UsuarioService: Funcionando');
      } catch (e) {
        estados['usuarios'] = false;
        print('   ❌ UsuarioService: Error');
      }

      try {
        await invitados.obtenerTodos();
        estados['invitados'] = true;
        print('   ✅ InvitadoService: Funcionando');
      } catch (e) {
        estados['invitados'] = false;
        print('   ❌ InvitadoService: Error');
      }

      try {
        await juegos.obtenerJuegos();
        estados['juegos'] = true;
        print('   ✅ JuegoService: Funcionando');
      } catch (e) {
        estados['juegos'] = false;
        print('   ❌ JuegoService: Error');
      }

      try {
        // Para progreso, intentamos obtener estadísticas de un juego inexistente
        await progreso.obtenerEstadisticasJuego(-1);
        estados['progreso'] = true;
        print('   ✅ ProgresoService: Funcionando');
      } catch (e) {
        estados['progreso'] = false;
        print('   ❌ ProgresoService: Error');
      }

      final serviciosFuncionando = estados.values.where((estado) => estado).length;
      final totalServicios = estados.length;
      
      print('📊 Resumen: $serviciosFuncionando/$totalServicios servicios funcionando');
      
    } catch (e) {
      print('❌ Error al verificar servicios: $e');
    }
    
    return estados;
  }

  /// Obtiene estadísticas generales de la aplicación
  Future<Map<String, dynamic>> obtenerEstadisticasGenerales() async {
    try {
      print('📊 Obteniendo estadísticas generales...');
      
      final usuariosList = await usuarios.obtenerTodos();
      final invitadosList = await invitados.obtenerTodos();
      final juegosList = await juegos.obtenerJuegos();
      
      final totalUsuarios = usuariosList.length;
      final totalInvitados = invitadosList.length;
      final totalJuegos = juegosList.length;
      
      final estadisticas = {
        'usuarios': totalUsuarios,
        'invitados': totalInvitados,
        'juegos': totalJuegos,
        'fechaConsulta': DateTime.now().toIso8601String(),
      };

      print('✅ Estadísticas obtenidas:');
      print('   👤 Usuarios: $totalUsuarios');
      print('   👥 Invitados: $totalInvitados');
      print('   🎮 Juegos: $totalJuegos');
      
      return estadisticas;
      
    } catch (e) {
      print('❌ Error al obtener estadísticas generales: $e');
      return {
        'usuarios': 0,
        'invitados': 0,
        'juegos': 0,
        'error': e.toString(),
      };
    }
  }

  /// Limpia la caché y reinicia las conexiones
  Future<void> reiniciar() async {
    try {
      print('🔄 Reiniciando DatabaseManager...');
      
      // Limpiar instancias de servicios
      _instance = null;
      await SupabaseService.disposeStatic();
      
      print('✅ DatabaseManager reiniciado');
      
    } catch (e) {
      print('❌ Error al reiniciar DatabaseManager: $e');
    }
  }

  /// Cierra todas las conexiones
  void cerrar() {
    print('🔌 Cerrando DatabaseManager...');
    SupabaseService.disposeStatic();
    _instance = null;
    print('✅ DatabaseManager cerrado');
  }
}
