import '../modelos/usuario_model.dart';
import 'supabase_service.dart';

class UsuarioService {
  static UsuarioService? _instance;
  static UsuarioService get instance => _instance ??= UsuarioService._();
  
  UsuarioService._();
  
  final _supabase = SupabaseService.instance;
  static const String tableName = 'usuario';
  
  /// Crear un nuevo usuario
  Future<UsuarioModel> crear(UsuarioModel usuario) async {
    try {
      print('➕ [UsuarioService] Creando nuevo usuario: ${usuario.nombre}');
      
      final response = await _supabase.client
          .from(tableName)
          .insert(usuario.toJson())
          .select()
          .single();
      
      final usuarioCreado = UsuarioModel.fromJson(response);
      print('✅ [UsuarioService] Usuario creado exitosamente: $usuarioCreado');
      
      return usuarioCreado;
      
    } catch (e) {
      _supabase.handleError('crear usuario', e);
      rethrow;
    }
  }
  
  /// Obtener usuario por ID
  Future<UsuarioModel?> obtenerPorId(int id) async {
    try {
      print('🔍 [UsuarioService] Buscando usuario con ID: $id');
      
      final response = await _supabase.client
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
      
      final response = await _supabase.client
          .from(tableName)
          .select()
          .eq('auth_user', authUserId)
          .maybeSingle();
      
      if (response == null) {
        print('❌ [UsuarioService] Usuario no encontrado con auth_user: $authUserId');
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
      
      final response = await _supabase.client
          .from(tableName)
          .select()
          .order('created_at', ascending: false);
      
      final usuarios = (response as List)
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
      
      final response = await _supabase.client
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
      print('🎮 [UsuarioService] Actualizando nivel del usuario $id a $nuevoNivel');
      
      final response = await _supabase.client
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
      
      await _supabase.client
          .from(tableName)
          .delete()
          .eq('id', id);
      
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
      
      final usuarios = (response as List)
          .map((json) => UsuarioModel.fromJson(json))
          .toList();
      
      print('✅ [UsuarioService] ${usuarios.length} usuarios encontrados');
      
      return usuarios;
      
    } catch (e) {
      _supabase.handleError('buscar usuarios por nombre', e);
      rethrow;
    }
  }
}
