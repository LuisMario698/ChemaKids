import '../models/progreso_model.dart';
import '../services/supabase_service.dart';

class ProgresoService {
  static ProgresoService? _instance;

  ProgresoService._();

  static ProgresoService get instance {
    _instance ??= ProgresoService._();
    return _instance!;
  }

  static const String tableName = 'progreso';

  /// Crea un nuevo registro de progreso
  Future<ProgresoModel?> crearProgreso(ProgresoModel progreso) async {
    try {
      print('📈 Creando nuevo progreso:');
      print('   🎮 Juego ID: ${progreso.idJuego}');
      print('   👤 Usuario ID: ${progreso.idUsuario}');
      print('   👥 Invitado ID: ${progreso.idInvitado}');
      print('   🎯 Nivel: ${progreso.nivel}');
      print('   ⭐ Puntaje: ${progreso.puntaje}');

      final response =
          await SupabaseService.instance.client
              .from(tableName)
              .insert(progreso.toJson())
              .select()
              .single();

      final progresoCreado = ProgresoModel.fromJson(response);

      print('✅ Progreso creado exitosamente:');
      print('   🆔 ID: ${progresoCreado.id}');
      print('   🏆 Racha máxima: ${progresoCreado.rachaMaxima}');

      return progresoCreado;
    } catch (e) {
      print('❌ Error al crear progreso');
      SupabaseService.instance.handleError('crear progreso', e);
      return null;
    }
  }

  /// Obtiene el progreso de un usuario en un juego específico
  Future<List<ProgresoModel>> obtenerProgresoUsuarioJuego(
    int idUsuario,
    int idJuego,
  ) async {
    try {
      print('📊 Obteniendo progreso del usuario $idUsuario en juego $idJuego');

      final response = await SupabaseService.instance.client
          .from(tableName)
          .select()
          .eq('id_usuario', idUsuario)
          .eq('id_juego', idJuego)
          .order('nivel', ascending: true);

      final progresos =
          (response as List)
              .map((json) => ProgresoModel.fromJson(json))
              .toList();

      print('✅ Progreso obtenido:');
      print('   📈 Registros encontrados: ${progresos.length}');

      for (var progreso in progresos) {
        print(
          '   🎯 Nivel ${progreso.nivel}: ${progreso.puntaje} pts (Racha: ${progreso.rachaMaxima})',
        );
      }

      return progresos;
    } catch (e) {
      print(
        '❌ Error al obtener progreso del usuario $idUsuario en juego $idJuego',
      );
      SupabaseService.instance.handleError('obtener progreso usuario-juego', e);
      return [];
    }
  }

  /// Obtiene todo el progreso de un usuario
  Future<List<ProgresoModel>> obtenerProgresoUsuario(int idUsuario) async {
    try {
      print('📊 Obteniendo todo el progreso del usuario $idUsuario');

      final response = await SupabaseService.instance.client
          .from(tableName)
          .select()
          .eq('id_usuario', idUsuario)
          .order('id_juego', ascending: true)
          .order('nivel', ascending: true);

      final progresos =
          (response as List)
              .map((json) => ProgresoModel.fromJson(json))
              .toList();

      print('✅ Progreso del usuario obtenido:');
      print('   📈 Total de registros: ${progresos.length}');

      // Agrupar por juego para mostrar estadísticas
      final juegoStats = <int, Map<String, dynamic>>{};
      for (var progreso in progresos) {
        if (!juegoStats.containsKey(progreso.idJuego)) {
          juegoStats[progreso.idJuego] = {
            'niveles': 0,
            'puntajeTotal': 0,
            'mejorRacha': 0,
          };
        }
        juegoStats[progreso.idJuego]!['niveles']++;
        juegoStats[progreso.idJuego]!['puntajeTotal'] += progreso.puntaje;
        if (progreso.rachaMaxima >
            juegoStats[progreso.idJuego]!['mejorRacha']) {
          juegoStats[progreso.idJuego]!['mejorRacha'] = progreso.rachaMaxima;
        }
      }

      juegoStats.forEach((juegoId, stats) {
        print(
          '   🎮 Juego $juegoId: ${stats['niveles']} niveles, ${stats['puntajeTotal']} pts total, racha máx: ${stats['mejorRacha']}',
        );
      });

      return progresos;
    } catch (e) {
      print('❌ Error al obtener progreso del usuario $idUsuario');
      SupabaseService.instance.handleError('obtener progreso usuario', e);
      return [];
    }
  }

  /// Obtiene el progreso de un invitado en un juego específico
  Future<List<ProgresoModel>> obtenerProgresoInvitadoJuego(
    int idInvitado,
    int idJuego,
  ) async {
    try {
      print(
        '📊 Obteniendo progreso del invitado $idInvitado en juego $idJuego',
      );

      final response = await SupabaseService.instance.client
          .from(tableName)
          .select()
          .eq('id_invitado', idInvitado)
          .eq('id_juego', idJuego)
          .order('nivel', ascending: true);

      final progresos =
          (response as List)
              .map((json) => ProgresoModel.fromJson(json))
              .toList();

      print('✅ Progreso del invitado obtenido:');
      print('   📈 Registros encontrados: ${progresos.length}');

      for (var progreso in progresos) {
        print(
          '   🎯 Nivel ${progreso.nivel}: ${progreso.puntaje} pts (Racha: ${progreso.rachaMaxima})',
        );
      }

      return progresos;
    } catch (e) {
      print(
        '❌ Error al obtener progreso del invitado $idInvitado en juego $idJuego',
      );
      SupabaseService.instance.handleError(
        'obtener progreso invitado-juego',
        e,
      );
      return [];
    }
  }

  /// Actualiza un registro de progreso existente
  Future<ProgresoModel?> actualizarProgreso(ProgresoModel progreso) async {
    try {
      print('📝 Actualizando progreso (ID: ${progreso.id})');
      print('   🎯 Nuevo nivel: ${progreso.nivel}');
      print('   ⭐ Nuevo puntaje: ${progreso.puntaje}');
      print('   🏆 Nueva racha máxima: ${progreso.rachaMaxima}');

      final response =
          await SupabaseService.instance.client
              .from(tableName)
              .update(progreso.toJson())
              .eq('id', progreso.id)
              .select()
              .single();

      final progresoActualizado = ProgresoModel.fromJson(response);

      print('✅ Progreso actualizado exitosamente');

      return progresoActualizado;
    } catch (e) {
      print('❌ Error al actualizar progreso (ID: ${progreso.id})');
      SupabaseService.instance.handleError('actualizar progreso', e);
      return null;
    }
  }

  /// Obtiene el mejor puntaje de un usuario en un juego específico
  Future<ProgresoModel?> obtenerMejorPuntaje(int idUsuario, int idJuego) async {
    try {
      print(
        '🏆 Buscando mejor puntaje del usuario $idUsuario en juego $idJuego',
      );

      final response = await SupabaseService.instance.client
          .from(tableName)
          .select()
          .eq('id_usuario', idUsuario)
          .eq('id_juego', idJuego)
          .order('puntaje', ascending: false)
          .limit(1);

      if (response.isEmpty) {
        print('📭 No se encontraron puntajes para este usuario en este juego');
        return null;
      }

      final mejorProgreso = ProgresoModel.fromJson(response.first);

      print('✅ Mejor puntaje encontrado:');
      print('   ⭐ Puntaje: ${mejorProgreso.puntaje}');
      print('   🎯 Nivel: ${mejorProgreso.nivel}');
      print('   🏆 Racha máxima: ${mejorProgreso.rachaMaxima}');

      return mejorProgreso;
    } catch (e) {
      print(
        '❌ Error al obtener mejor puntaje del usuario $idUsuario en juego $idJuego',
      );
      SupabaseService.instance.handleError('obtener mejor puntaje', e);
      return null;
    }
  }

  /// Obtiene el nivel más alto alcanzado por un usuario en un juego
  Future<int> obtenerNivelMaximo(int idUsuario, int idJuego) async {
    try {
      print(
        '🎯 Buscando nivel máximo del usuario $idUsuario en juego $idJuego',
      );

      final response = await SupabaseService.instance.client
          .from(tableName)
          .select('nivel')
          .eq('id_usuario', idUsuario)
          .eq('id_juego', idJuego)
          .order('nivel', ascending: false)
          .limit(1);

      if (response.isEmpty) {
        print('📭 No se encontraron niveles para este usuario en este juego');
        return 0;
      }

      final nivelMaximo = response.first['nivel'] as int;

      print('✅ Nivel máximo encontrado: $nivelMaximo');

      return nivelMaximo;
    } catch (e) {
      print(
        '❌ Error al obtener nivel máximo del usuario $idUsuario en juego $idJuego',
      );
      SupabaseService.instance.handleError('obtener nivel máximo', e);
      return 0;
    }
  }

  /// Obtiene estadísticas generales de progreso para un juego
  Future<Map<String, dynamic>> obtenerEstadisticasJuego(int idJuego) async {
    try {
      print('📈 Obteniendo estadísticas del juego $idJuego');

      final response = await SupabaseService.instance.client
          .from(tableName)
          .select('puntaje, nivel, racha_maxima')
          .eq('id_juego', idJuego);

      if (response.isEmpty) {
        print('📭 No se encontraron estadísticas para el juego $idJuego');
        return {
          'totalJugadores': 0,
          'puntajePromedio': 0.0,
          'nivelPromedio': 0.0,
          'mejorPuntaje': 0,
          'mejorRacha': 0,
        };
      }

      final registros = response as List;
      final totalJugadores = registros.length;
      final puntajes = registros.map((r) => r['puntaje'] as int).toList();
      final niveles = registros.map((r) => r['nivel'] as int).toList();
      final rachas = registros.map((r) => r['racha_maxima'] as int).toList();

      final estadisticas = {
        'totalJugadores': totalJugadores,
        'puntajePromedio': puntajes.reduce((a, b) => a + b) / totalJugadores,
        'nivelPromedio': niveles.reduce((a, b) => a + b) / totalJugadores,
        'mejorPuntaje': puntajes.reduce((a, b) => a > b ? a : b),
        'mejorRacha': rachas.reduce((a, b) => a > b ? a : b),
      };

      print('✅ Estadísticas del juego $idJuego:');
      print('   👥 Total jugadores: ${estadisticas['totalJugadores']}');
      print(
        '   ⭐ Puntaje promedio: ${estadisticas['puntajePromedio']?.toStringAsFixed(1)}',
      );
      print(
        '   🎯 Nivel promedio: ${estadisticas['nivelPromedio']?.toStringAsFixed(1)}',
      );
      print('   🏆 Mejor puntaje: ${estadisticas['mejorPuntaje']}');
      print('   🔥 Mejor racha: ${estadisticas['mejorRacha']}');

      return estadisticas;
    } catch (e) {
      print('❌ Error al obtener estadísticas del juego $idJuego');
      SupabaseService.instance.handleError('obtener estadísticas juego', e);
      return {
        'totalJugadores': 0,
        'puntajePromedio': 0.0,
        'nivelPromedio': 0.0,
        'mejorPuntaje': 0,
        'mejorRacha': 0,
      };
    }
  }

  /// Elimina un registro de progreso
  Future<bool> eliminarProgreso(int id) async {
    try {
      print('🗑️ Eliminando progreso con ID: $id');

      await SupabaseService.instance.client
          .from(tableName)
          .delete()
          .eq('id', id);

      print('✅ Progreso eliminado exitosamente (ID: $id)');
      return true;
    } catch (e) {
      print('❌ Error al eliminar progreso con ID: $id');
      SupabaseService.instance.handleError('eliminar progreso', e);
      return false;
    }
  }
}
