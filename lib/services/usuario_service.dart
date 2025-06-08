import '../models/usuario_model.dart';
import 'supabase_service.dart';

class UsuarioService {
  static UsuarioService? _instance;
  static UsuarioService get instance => _instance ??= UsuarioService._();

  UsuarioService._();

  final _supabase = SupabaseService.instance;
  static const String tableName = 'usuario';

  /// Crear un nuevo usuario con progreso automático
  Future<UsuarioModel> crear(UsuarioModel usuario) async {
    try {
      print('➕ [UsuarioService] Creando nuevo usuario: ${usuario.nombre}');

      // Paso 1: Crear registro de progreso
      print('📊 [UsuarioService] Creando registro de progreso...');
      final progresoResponse = await _supabase.client
          .from('progreso_usuario')
          .insert({
            'nivel': 1,
            'racha_1': 0,
            'racha_2': 0,
          })
          .select()
          .single();
      
      final idProgreso = progresoResponse['id'] as int;
      print('✅ [UsuarioService] Progreso creado con ID: $idProgreso');

      // Paso 2: Crear usuario con referencia al progreso
      print('👤 [UsuarioService] Creando usuario con progreso vinculado...');
      final usuarioData = usuario.toJson();
      usuarioData['id_progreso'] = idProgreso;

      final usuarioResponse = await _supabase.client
          .from(tableName)
          .insert(usuarioData)
          .select()
          .single();

      final usuarioCreado = UsuarioModel.fromJson(usuarioResponse);
      print('✅ [UsuarioService] Usuario creado exitosamente: $usuarioCreado');

      return usuarioCreado;
    } catch (e) {
      print('❌ [UsuarioService] Error al crear usuario: $e');
      _supabase.handleError('crear usuario', e);
      rethrow;
    }
  }

  /// Obtener usuario por ID
  Future<UsuarioModel?> obtenerPorId(int id) async {
    try {
      print('🔍 [UsuarioService] Buscando usuario con ID: $id');

      final response =
          await _supabase.client
              .from(tableName)
              .select()
              .eq('id', id)
              .maybeSingle();

      if (response == null) {
        print('❌ [UsuarioService] Usuario no encontrado con ID: $id');
        return null;
      }

      final usuario = UsuarioModel.fromJson(response);
      print('✅ [UsuarioService] Usuario encontrado: $usuario');

      return usuario;
    } catch (e) {
      _supabase.handleError('obtener usuario por ID', e);
      rethrow;
    }
  }

  /// Obtener usuario por auth_user UUID
  Future<UsuarioModel?> obtenerPorAuthUser(String authUserId) async {
    try {
      print('🔍 [UsuarioService] Buscando usuario con auth_user: $authUserId');

      final response =
          await _supabase.client
              .from(tableName)
              .select()
              .eq('auth_user', authUserId)
              .maybeSingle();

      if (response == null) {
        print(
          '❌ [UsuarioService] Usuario no encontrado con auth_user: $authUserId',
        );
        return null;
      }

      final usuario = UsuarioModel.fromJson(response);
      print('✅ [UsuarioService] Usuario encontrado: $usuario');

      return usuario;
    } catch (e) {
      _supabase.handleError('obtener usuario por auth_user', e);
      rethrow;
    }
  }

  /// Obtener todos los usuarios
  Future<List<UsuarioModel>> obtenerTodos() async {
    try {
      print('📋 [UsuarioService] Obteniendo todos los usuarios...');

      // Primero verificar si la tabla existe y tiene la estructura correcta
      await _verificarEstructuraTabla();

      final response = await _supabase.client
          .from(tableName)
          .select()
          .order('id', ascending: false); // Usar 'id' en lugar de 'created_at'

      final usuarios =
          (response as List)
              .map((json) => UsuarioModel.fromJson(json))
              .toList();

      print('✅ [UsuarioService] ${usuarios.length} usuarios obtenidos');

      return usuarios;
    } catch (e) {
      _supabase.handleError('obtener todos los usuarios', e);
      rethrow;
    }
  }

  /// Actualizar usuario
  Future<UsuarioModel> actualizar(UsuarioModel usuario) async {
    try {
      print('🔄 [UsuarioService] Actualizando usuario: ${usuario.id}');

      final response =
          await _supabase.client
              .from(tableName)
              .update(usuario.toJson())
              .eq('id', usuario.id)
              .select()
              .single();

      final usuarioActualizado = UsuarioModel.fromJson(response);
      print('✅ [UsuarioService] Usuario actualizado: $usuarioActualizado');

      return usuarioActualizado;
    } catch (e) {
      _supabase.handleError('actualizar usuario', e);
      rethrow;
    }
  }

  /// Actualizar nivel del usuario
  Future<UsuarioModel> actualizarNivel(int id, int nuevoNivel) async {
    try {
      print(
        '🎮 [UsuarioService] Actualizando nivel del usuario $id a $nuevoNivel',
      );

      final response =
          await _supabase.client
              .from(tableName)
              .update({'nivel': nuevoNivel})
              .eq('id', id)
              .select()
              .single();

      final usuario = UsuarioModel.fromJson(response);
      print('✅ [UsuarioService] Nivel actualizado: $usuario');

      return usuario;
    } catch (e) {
      _supabase.handleError('actualizar nivel de usuario', e);
      rethrow;
    }
  }

  /// Eliminar usuario
  Future<void> eliminar(int id) async {
    try {
      print('🗑️ [UsuarioService] Eliminando usuario: $id');

      await _supabase.client.from(tableName).delete().eq('id', id);

      print('✅ [UsuarioService] Usuario eliminado exitosamente');
    } catch (e) {
      _supabase.handleError('eliminar usuario', e);
      rethrow;
    }
  }

  /// Buscar usuarios por nombre
  Future<List<UsuarioModel>> buscarPorNombre(String nombre) async {
    try {
      print('🔍 [UsuarioService] Buscando usuarios con nombre: $nombre');

      final response = await _supabase.client
          .from(tableName)
          .select()
          .ilike('nombre', '%$nombre%')
          .order('nombre');

      final usuarios =
          (response as List)
              .map((json) => UsuarioModel.fromJson(json))
              .toList();

      print('✅ [UsuarioService] ${usuarios.length} usuarios encontrados');

      return usuarios;
    } catch (e) {
      _supabase.handleError('buscar usuarios por nombre', e);
      rethrow;
    }
  }

  /// Obtener usuario por email
  Future<UsuarioModel?> obtenerPorEmail(String email) async {
    try {
      print('🔍 [UsuarioService] Buscando usuario por email: $email');
      
      final response = await _supabase.client
          .from(tableName)
          .select()
          .eq('email', email)
          .maybeSingle();

      if (response != null) {
        final usuario = UsuarioModel.fromJson(response);
        print('✅ [UsuarioService] Usuario encontrado: ${usuario.nombre}');
        return usuario;
      }

      print('⚠️ [UsuarioService] No se encontró usuario con email: $email');
      return null;
    } catch (e) {
      print('❌ [UsuarioService] Error al buscar usuario por email: $e');
      _supabase.handleError('obtener usuario por email', e);
      return null;
    }
  }

  /// Verifica que la tabla usuario tenga la estructura correcta
  Future<void> _verificarEstructuraTabla() async {
    try {
      // Tabla usuario tiene: id, nombre, email, nivel, edad, auth_user (6 columnas)
      await _supabase.client
          .from(tableName)
          .select('id, nombre, email, nivel, edad, auth_user')
          .limit(1);

      print('✅ [UsuarioService] Estructura de tabla verificada correctamente');
    } catch (e) {
      print('❌ [UsuarioService] Error en estructura de tabla: $e');

      if (e.toString().contains('does not exist')) {
        print(
          '💡 [UsuarioService] La tabla $tableName no existe en la base de datos',
        );
        print(
          '💡 [UsuarioService] Ejecuta el archivo database_schema.sql en Supabase',
        );
        throw Exception(
          'Tabla $tableName no existe. Aplica el esquema de la base de datos.',
        );
      }

      if (e.toString().contains('column') &&
          e.toString().contains('does not exist')) {
        print(
          '💡 [UsuarioService] La tabla $tableName existe pero le faltan columnas',
        );
        print(
          '💡 [UsuarioService] Ejecuta el archivo database_schema.sql para actualizar la estructura',
        );
        throw Exception(
          'Estructura de tabla $tableName incorrecta. Actualiza el esquema de la base de datos.',
        );
      }

      rethrow;
    }
  }
}
