
import '../modelos/juego_model.dart';
import 'supabase_service.dart';

class JuegoService {
  static JuegoService? _instance;
  
  JuegoService._();
  
  static JuegoService get instance {
    _instance ??= JuegoService._();
    return _instance!;
  }

  static const String tableName = 'juegos';

  /// Crea un nuevo juego en la base de datos
  Future<JuegoModel?> crearJuego(JuegoModel juego) async {
    try {
      print('🎮 Creando nuevo juego: ${juego.nombre}');
      
      final response = await SupabaseService.instance.client
          .from(tableName)
          .insert(juego.toJson())
          .select()
          .single();

      final juegoCreado = JuegoModel.fromJson(response);
      
      print('✅ Juego creado exitosamente:');
      print('   🆔 ID: ${juegoCreado.id}');
      print('   📋 Nombre: ${juegoCreado.nombre}');
      print('   📝 Descripción: ${juegoCreado.descripcion}');
      
      return juegoCreado;
      
    } catch (e) {
      print('❌ Error al crear juego: ${juego.nombre}');
      SupabaseService.instance.handleError('crear juego', e);
      return null;
    }
  }

  /// Obtiene todos los juegos
  Future<List<JuegoModel>> obtenerJuegos() async {
    try {
      print('📖 Obteniendo lista de juegos...');
      
      final response = await SupabaseService.instance.client
          .from(tableName)
          .select()
          .order('nombre', ascending: true);

      final juegos = (response as List)
          .map((json) => JuegoModel.fromJson(json))
          .toList();

      print('✅ Juegos obtenidos exitosamente:');
      print('   📊 Total de juegos: ${juegos.length}');
      
      for (var juego in juegos) {
        print('   🎮 ${juego.nombre} (ID: ${juego.id})');
      }
      
      return juegos;
      
    } catch (e) {
      print('❌ Error al obtener juegos');
      SupabaseService.instance.handleError('obtener juegos', e);
      return [];
    }
  }

  /// Obtiene un juego por su ID
  Future<JuegoModel?> obtenerJuegoPorId(int id) async {
    try {
      print('🔍 Buscando juego con ID: $id');
      
      final response = await SupabaseService.instance.client
          .from(tableName)
          .select()
          .eq('id', id)
          .single();

      final juego = JuegoModel.fromJson(response);
      
      print('✅ Juego encontrado:');
      print('   🎮 Nombre: ${juego.nombre}');
      print('   📝 Descripción: ${juego.descripcion}');
      
      return juego;
      
    } catch (e) {
      print('❌ Error al obtener juego con ID: $id');
      SupabaseService.instance.handleError('obtener juego por ID', e);
      return null;
    }
  }

  /// Busca juegos por nombre
  Future<List<JuegoModel>> buscarJuegosPorNombre(String nombre) async {
    try {
      print('🔍 Buscando juegos que contengan: "$nombre"');
      
      final response = await SupabaseService.instance.client
          .from(tableName)
          .select()
          .ilike('nombre', '%$nombre%')
          .order('nombre', ascending: true);

      final juegos = (response as List)
          .map((json) => JuegoModel.fromJson(json))
          .toList();

      print('✅ Búsqueda completada:');
      print('   📊 Juegos encontrados: ${juegos.length}');
      
      for (var juego in juegos) {
        print('   🎮 ${juego.nombre} (ID: ${juego.id})');
      }
      
      return juegos;
      
    } catch (e) {
      print('❌ Error al buscar juegos por nombre: "$nombre"');
      SupabaseService.instance.handleError('buscar juegos por nombre', e);
      return [];
    }
  }

  /// Actualiza un juego existente
  Future<JuegoModel?> actualizarJuego(JuegoModel juego) async {
    try {
      print('📝 Actualizando juego: ${juego.nombre} (ID: ${juego.id})');
      
      final response = await SupabaseService.instance.client
          .from(tableName)
          .update(juego.toJson())
          .eq('id', juego.id)
          .select()
          .single();

      final juegoActualizado = JuegoModel.fromJson(response);
      
      print('✅ Juego actualizado exitosamente:');
      print('   🎮 Nombre: ${juegoActualizado.nombre}');
      print('   📝 Descripción: ${juegoActualizado.descripcion}');
      
      return juegoActualizado;
      
    } catch (e) {
      print('❌ Error al actualizar juego: ${juego.nombre} (ID: ${juego.id})');
      SupabaseService.instance.handleError('actualizar juego', e);
      return null;
    }
  }

  /// Elimina un juego por su ID
  Future<bool> eliminarJuego(int id) async {
    try {
      print('🗑️ Eliminando juego con ID: $id');
      
      await SupabaseService.instance.client
          .from(tableName)
          .delete()
          .eq('id', id);

      print('✅ Juego eliminado exitosamente (ID: $id)');
      return true;
      
    } catch (e) {
      print('❌ Error al eliminar juego con ID: $id');
      SupabaseService.instance.handleError('eliminar juego', e);
      return false;
    }
  }

  /// Verifica si existe un juego con el nombre dado
  Future<bool> existeJuegoConNombre(String nombre) async {
    try {
      print('🔍 Verificando si existe juego con nombre: "$nombre"');
      
      final response = await SupabaseService.instance.client
          .from(tableName)
          .select('id')
          .eq('nombre', nombre)
          .limit(1);

      final existe = response.isNotEmpty;
      
      print(existe 
          ? '✅ Juego "$nombre" ya existe en la base de datos'
          : '❌ Juego "$nombre" no existe en la base de datos');
      
      return existe;
      
    } catch (e) {
      print('❌ Error al verificar existencia del juego: "$nombre"');
      SupabaseService.instance.handleError('verificar existencia de juego', e);
      return false;
    }
  }

  /// Obtiene el conteo total de juegos
  Future<int> contarJuegos() async {
    try {
      print('📊 Contando total de juegos...');
      
      final response = await SupabaseService.instance.client
          .from(tableName)
          .select('id');

      final total = response.length;
      
      print('✅ Total de juegos: $total');
      
      return total;
      
    } catch (e) {
      print('❌ Error al contar juegos');
      SupabaseService.instance.handleError('contar juegos', e);
      return 0;
    }
  }
}
