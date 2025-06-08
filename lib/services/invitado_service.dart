import '../models/invitado_model.dart';
import 'supabase_service.dart';

class InvitadoService {
  static InvitadoService? _instance;
  static InvitadoService get instance => _instance ??= InvitadoService._();

  InvitadoService._();

  final _supabase = SupabaseService.instance;
  static const String tableName = 'invitado';

  /// Crear un nuevo invitado con progreso automático
  Future<InvitadoModel> crear(InvitadoModel invitado) async {
    try {
      print('➕ [InvitadoService] Creando nuevo invitado: ${invitado.nombre}');

      // Verificar que Supabase esté inicializado
      if (!_supabase.isInitialized) {
        print('⚠️ [InvitadoService] SupabaseService no está inicializado. Creando usuario en modo offline...');
        
        // Crear invitado con ID temporal para modo offline
        final invitadoOffline = invitado.copyWith(
          id: DateTime.now().millisecondsSinceEpoch, // ID temporal basado en timestamp
          idProgreso: DateTime.now().millisecondsSinceEpoch + 1, // ID temporal de progreso
        );
        
        print('✅ [InvitadoService] Invitado creado en modo offline: ${invitadoOffline.nombre}');
        return invitadoOffline;
      }

      // Intentar crear en Supabase
      try {
        // Paso 1: Crear registro de progreso para invitado
        print('📊 [InvitadoService] Creando registro de progreso para invitado...');
        final progresoResponse = await _supabase.client
            .from('progreso_invitado')
            .insert({
              'nivel': 1,
              'racha_1': 0,
              'racha_2': 0,
            })
            .select()
            .single();
        
        final idProgreso = progresoResponse['id'] as int;
        print('✅ [InvitadoService] Progreso creado con ID: $idProgreso');

        // Paso 2: Crear invitado con referencia al progreso
        print('👤 [InvitadoService] Creando invitado con progreso vinculado...');
        final invitadoData = invitado.toJson();
        invitadoData['id_progreso'] = idProgreso;

        final response = await _supabase.client
            .from(tableName)
            .insert(invitadoData)
            .select()
            .single();

        final invitadoCreado = InvitadoModel.fromJson(response);
        print('✅ [InvitadoService] Invitado creado exitosamente en Supabase: $invitadoCreado');

        return invitadoCreado;
      } catch (e) {
        print('⚠️ [InvitadoService] Error al crear en Supabase, creando en modo offline: $e');
        
        // Fallback a modo offline si falla Supabase
        final invitadoOffline = invitado.copyWith(
          id: DateTime.now().millisecondsSinceEpoch, // ID temporal basado en timestamp
          idProgreso: DateTime.now().millisecondsSinceEpoch + 1, // ID temporal de progreso
        );
        
        print('✅ [InvitadoService] Invitado creado en modo offline (fallback): ${invitadoOffline.nombre}');
        return invitadoOffline;
      }
    } catch (e) {
      print('❌ [InvitadoService] Error crítico al crear invitado: $e');
      rethrow;
    }
  }

  /// Obtener invitado por ID
  Future<InvitadoModel?> obtenerPorId(int id) async {
    try {
      print('🔍 [InvitadoService] Buscando invitado con ID: $id');

      final response =
          await _supabase.client
              .from(tableName)
              .select()
              .eq('id', id)
              .maybeSingle();

      if (response == null) {
        print('❌ [InvitadoService] Invitado no encontrado con ID: $id');
        return null;
      }

      final invitado = InvitadoModel.fromJson(response);
      print('✅ [InvitadoService] Invitado encontrado: $invitado');

      return invitado;
    } catch (e) {
      _supabase.handleError('obtener invitado por ID', e);
      rethrow;
    }
  }

  /// Obtener todos los invitados
  Future<List<InvitadoModel>> obtenerTodos() async {
    try {
      print('📋 [InvitadoService] Obteniendo todos los invitados...');

      // Primero verificar si la tabla existe y tiene la estructura correcta
      await _verificarEstructuraTabla();

      final response = await _supabase.client
          .from(tableName)
          .select()
          .order('id', ascending: false); // Usar 'id' en lugar de 'created_at'

      final invitados =
          (response as List)
              .map((json) => InvitadoModel.fromJson(json))
              .toList();

      print('✅ [InvitadoService] ${invitados.length} invitados obtenidos');

      return invitados;
    } catch (e) {
      _supabase.handleError('obtener todos los invitados', e);
      rethrow;
    }
  }

  /// Actualizar invitado
  Future<InvitadoModel> actualizar(InvitadoModel invitado) async {
    try {
      print('🔄 [InvitadoService] Actualizando invitado: ${invitado.id}');

      final response =
          await _supabase.client
              .from(tableName)
              .update(invitado.toJson())
              .eq('id', invitado.id)
              .select()
              .single();

      final invitadoActualizado = InvitadoModel.fromJson(response);
      print('✅ [InvitadoService] Invitado actualizado: $invitadoActualizado');

      return invitadoActualizado;
    } catch (e) {
      _supabase.handleError('actualizar invitado', e);
      rethrow;
    }
  }

  /// Actualizar nivel del invitado
  Future<InvitadoModel> actualizarNivel(int id, int nuevoNivel) async {
    try {
      print(
        '🎮 [InvitadoService] Actualizando nivel del invitado $id a $nuevoNivel',
      );

      final response =
          await _supabase.client
              .from(tableName)
              .update({'nivel': nuevoNivel})
              .eq('id', id)
              .select()
              .single();

      final invitado = InvitadoModel.fromJson(response);
      print('✅ [InvitadoService] Nivel actualizado: $invitado');

      return invitado;
    } catch (e) {
      _supabase.handleError('actualizar nivel de invitado', e);
      rethrow;
    }
  }

  /// Eliminar invitado
  Future<void> eliminar(int id) async {
    try {
      print('🗑️ [InvitadoService] Eliminando invitado: $id');

      await _supabase.client.from(tableName).delete().eq('id', id);

      print('✅ [InvitadoService] Invitado eliminado exitosamente');
    } catch (e) {
      _supabase.handleError('eliminar invitado', e);
      rethrow;
    }
  }

  /// Buscar invitados por nombre
  Future<List<InvitadoModel>> buscarPorNombre(String nombre) async {
    try {
      print('🔍 [InvitadoService] Buscando invitados con nombre: $nombre');

      final response = await _supabase.client
          .from(tableName)
          .select()
          .ilike('nombre', '%$nombre%')
          .order('nombre');

      final invitados =
          (response as List)
              .map((json) => InvitadoModel.fromJson(json))
              .toList();

      print('✅ [InvitadoService] ${invitados.length} invitados encontrados');

      return invitados;
    } catch (e) {
      _supabase.handleError('buscar invitados por nombre', e);
      rethrow;
    }
  }

  /// Obtener invitados por rango de edad
  Future<List<InvitadoModel>> obtenerPorRangoEdad(
    int edadMinima,
    int edadMaxima,
  ) async {
    try {
      print(
        '🔍 [InvitadoService] Buscando invitados entre $edadMinima y $edadMaxima años',
      );

      final response = await _supabase.client
          .from(tableName)
          .select()
          .gte('edad', edadMinima)
          .lte('edad', edadMaxima)
          .order('edad');

      final invitados =
          (response as List)
              .map((json) => InvitadoModel.fromJson(json))
              .toList();

      print(
        '✅ [InvitadoService] ${invitados.length} invitados encontrados en el rango de edad',
      );

      return invitados;
    } catch (e) {
      _supabase.handleError('obtener invitados por rango de edad', e);
      rethrow;
    }
  }

  /// Verifica que la tabla invitado tenga la estructura correcta
  Future<void> _verificarEstructuraTabla() async {
    try {
      // Tabla invitado tiene: id, nombre, edad, id_progreso (4 columnas principales)
      await _supabase.client
          .from(tableName)
          .select('id, nombre, edad, id_progreso')
          .limit(1);

      print('✅ [InvitadoService] Estructura de tabla verificada correctamente');
    } catch (e) {
      print('❌ [InvitadoService] Error en estructura de tabla: $e');

      if (e.toString().contains('does not exist')) {
        print(
          '💡 [InvitadoService] La tabla $tableName no existe en la base de datos',
        );
        print(
          '💡 [InvitadoService] Ejecuta el archivo database_schema.sql en Supabase',
        );
        throw Exception(
          'Tabla $tableName no existe. Aplica el esquema de la base de datos.',
        );
      }

      if (e.toString().contains('column') &&
          e.toString().contains('does not exist')) {
        print(
          '💡 [InvitadoService] La tabla $tableName existe pero le faltan columnas',
        );
        print(
          '💡 [InvitadoService] Ejecuta el archivo database_schema.sql para actualizar la estructura',
        );
        throw Exception(
          'Estructura de tabla $tableName incorrecta. Actualiza el esquema de la base de datos.',
        );
      }

      rethrow;
    }
  }
}
