import 'supabase_service.dart';

class ProgresoService {
  static ProgresoService? _instance;
  static ProgresoService get instance => _instance ??= ProgresoService._();

  ProgresoService._();

  final _supabase = SupabaseService.instance;

  /// Obtener progreso de usuario registrado
  Future<Map<String, dynamic>?> obtenerProgresoUsuario(int idProgreso) async {
    try {
      print('📊 [ProgresoService] Obteniendo progreso usuario ID: $idProgreso');

      final response =
          await _supabase.client
              .from('progreso_usuario')
              .select()
              .eq('id', idProgreso)
              .maybeSingle();

      if (response == null) {
        print(
          '❌ [ProgresoService] Progreso usuario no encontrado para ID: $idProgreso',
        );
        return null;
      }

      print('✅ [ProgresoService] Progreso usuario encontrado: $response');
      return response;
    } catch (e) {
      print('❌ [ProgresoService] Error al obtener progreso usuario: $e');
      _supabase.handleError('obtener progreso usuario', e);
      rethrow;
    }
  }

  /// Obtener progreso de invitado
  Future<Map<String, dynamic>?> obtenerProgresoInvitado(int idProgreso) async {
    try {
      print(
        '📊 [ProgresoService] Obteniendo progreso invitado ID: $idProgreso',
      );

      final response =
          await _supabase.client
              .from('progreso_invitado')
              .select()
              .eq('id', idProgreso)
              .maybeSingle();

      if (response == null) {
        print(
          '❌ [ProgresoService] Progreso invitado no encontrado para ID: $idProgreso',
        );
        return null;
      }

      print('✅ [ProgresoService] Progreso invitado encontrado: $response');
      return response;
    } catch (e) {
      print('❌ [ProgresoService] Error al obtener progreso invitado: $e');
      _supabase.handleError('obtener progreso invitado', e);
      rethrow;
    }
  }

  /// Actualizar progreso de usuario registrado
  Future<Map<String, dynamic>> actualizarProgresoUsuario(
    int idProgreso,
    Map<String, dynamic> cambios,
  ) async {
    try {
      print(
        '📈 [ProgresoService] Actualizando progreso usuario ID: $idProgreso con cambios: $cambios',
      );

      final response =
          await _supabase.client
              .from('progreso_usuario')
              .update(cambios)
              .eq('id', idProgreso)
              .select()
              .single();

      print('✅ [ProgresoService] Progreso usuario actualizado: $response');
      return response;
    } catch (e) {
      print('❌ [ProgresoService] Error al actualizar progreso usuario: $e');
      _supabase.handleError('actualizar progreso usuario', e);
      rethrow;
    }
  }

  /// Actualizar progreso de invitado
  Future<Map<String, dynamic>> actualizarProgresoInvitado(
    int idProgreso,
    Map<String, dynamic> cambios,
  ) async {
    try {
      print(
        '📈 [ProgresoService] Actualizando progreso invitado ID: $idProgreso con cambios: $cambios',
      );

      final response =
          await _supabase.client
              .from('progreso_invitado')
              .update(cambios)
              .eq('id', idProgreso)
              .select()
              .single();

      print('✅ [ProgresoService] Progreso invitado actualizado: $response');
      return response;
    } catch (e) {
      print('❌ [ProgresoService] Error al actualizar progreso invitado: $e');
      _supabase.handleError('actualizar progreso invitado', e);
      rethrow;
    }
  }

  /// Crear progreso inicial (método de compatibilidad)
  Future<Map<String, dynamic>?> crearProgreso(Map<String, dynamic> progreso) async {
    try {
      print('📊 [ProgresoService] Creando progreso: $progreso');
      
      // Determinar si es para usuario o invitado
      final esUsuario = progreso.containsKey('id_usuario');
      final tabla = esUsuario ? 'progreso_usuario' : 'progreso_invitado';
      
      final response = await _supabase.client
          .from(tabla)
          .insert(progreso)
          .select()
          .single();

      print('✅ [ProgresoService] Progreso creado: $response');
      return response;
    } catch (e) {
      print('❌ [ProgresoService] Error al crear progreso: $e');
      _supabase.handleError('crear progreso', e);
      return null;
    }
  }

  /// Obtener estadísticas de un juego (método de compatibilidad)
  Future<Map<String, dynamic>> obtenerEstadisticasJuego(int idJuego) async {
    try {
      print('📊 [ProgresoService] Obteniendo estadísticas del juego ID: $idJuego');
      
      // Para estadísticas generales, devolver estructura por defecto
      return {
        'juego_id': idJuego,
        'total_jugadores': 0,
        'promedio_nivel': 1,
        'fecha_consulta': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('❌ [ProgresoService] Error al obtener estadísticas: $e');
      return {
        'juego_id': idJuego,
        'total_jugadores': 0,
        'promedio_nivel': 1,
        'error': e.toString(),
      };
    }
  }

  /// Obtener mejor puntaje (método de compatibilidad)
  Future<Map<String, dynamic>?> obtenerMejorPuntaje(int idUsuario, String nombreJuego) async {
    try {
      print('🏆 [ProgresoService] Obteniendo mejor puntaje para usuario $idUsuario en $nombreJuego');
      
      // Por ahora devolver estructura por defecto
      return {
        'usuario_id': idUsuario,
        'juego': nombreJuego,
        'puntaje': 0,
        'nivel_alcanzado': 1,
        'fecha': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('❌ [ProgresoService] Error al obtener mejor puntaje: $e');
      return null;
    }
  }
}
