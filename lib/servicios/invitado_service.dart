import '../modelos/invitado_model.dart';
import 'supabase_service.dart';

class InvitadoService {
  static InvitadoService? _instance;
  static InvitadoService get instance => _instance ??= InvitadoService._();
  
  InvitadoService._();
  
  final _supabase = SupabaseService.instance;
  static const String tableName = 'invitado';
  
  /// Crear un nuevo invitado
  Future<InvitadoModel> crear(InvitadoModel invitado) async {
    try {
      print('➕ [InvitadoService] Creando nuevo invitado: ${invitado.nombre}');
      
      final response = await _supabase.client
          .from(tableName)
          .insert(invitado.toJson())
          .select()
          .single();
      
      final invitadoCreado = InvitadoModel.fromJson(response);
      print('✅ [InvitadoService] Invitado creado exitosamente: $invitadoCreado');
      
      return invitadoCreado;
      
    } catch (e) {
      _supabase.handleError('crear invitado', e);
      rethrow;
    }
  }
  
  /// Obtener invitado por ID
  Future<InvitadoModel?> obtenerPorId(int id) async {
    try {
      print('🔍 [InvitadoService] Buscando invitado con ID: $id');
      
      final response = await _supabase.client
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
      
      final response = await _supabase.client
          .from(tableName)
          .select()
          .order('created_at', ascending: false);
      
      final invitados = (response as List)
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
      
      final response = await _supabase.client
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
      print('🎮 [InvitadoService] Actualizando nivel del invitado $id a $nuevoNivel');
      
      final response = await _supabase.client
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
      
      await _supabase.client
          .from(tableName)
          .delete()
          .eq('id', id);
      
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
      
      final invitados = (response as List)
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
  Future<List<InvitadoModel>> obtenerPorRangoEdad(int edadMinima, int edadMaxima) async {
    try {
      print('🔍 [InvitadoService] Buscando invitados entre $edadMinima y $edadMaxima años');
      
      final response = await _supabase.client
          .from(tableName)
          .select()
          .gte('edad', edadMinima)
          .lte('edad', edadMaxima)
          .order('edad');
      
      final invitados = (response as List)
          .map((json) => InvitadoModel.fromJson(json))
          .toList();
      
      print('✅ [InvitadoService] ${invitados.length} invitados encontrados en el rango de edad');
      
      return invitados;
      
    } catch (e) {
      _supabase.handleError('obtener invitados por rango de edad', e);
      rethrow;
    }
  }
}
