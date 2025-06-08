
import '../models/usuario_model.dart';
import '../models/invitado_model.dart';
import '../models/juego_model.dart';
import '../models/progreso_model.dart';
import 'database_manager.dart';

/// Servicio de ejemplo que muestra cómo usar la base de datos Supabase
/// en ChemaKids. Este archivo incluye casos de uso comunes.
class EjemploUsoBD {
  static final DatabaseManager _db = DatabaseManager.instance;

  /// Ejemplo 1: Crear un perfil completo de usuario
  static Future<void> ejemploCrearPerfilUsuario() async {
    try {
      print('\n🎮 === EJEMPLO: Crear Perfil de Usuario ===');
      
      // Crear usuario principal
      final nuevoUsuario = UsuarioModel(
        id: 0, // Se auto-genera en la BD
        nombre: 'María González',
        email: 'maria@ejemplo.com',
        idProgreso: 0, // Se asigna automáticamente en el servicio
        edad: 8,
        authUser: null, // Se asignaría después de la autenticación
      );

      final usuarioCreado = await _db.usuarios.crear(nuevoUsuario);
      print('👤 Usuario creado: ${usuarioCreado.nombre}');

      // Crear invitado para el usuario
      final nuevoInvitado = InvitadoModel(
        id: 0,
        nombre: 'Pedro (Hermano)',
        edad: 6,
        idProgreso: 0, // Se asigna automáticamente en el servicio
      );

      final invitadoCreado = await _db.invitados.crear(nuevoInvitado);
      print('👥 Invitado creado: ${invitadoCreado.nombre}');

      print('✅ Perfil completo creado exitosamente\n');
      
    } catch (e) {
      print('❌ Error en ejemplo crear perfil: $e\n');
    }
  }

  /// Ejemplo 2: Configurar juegos iniciales
  static Future<void> ejemploConfigurarJuegos() async {
    try {
      print('🎮 === EJEMPLO: Configurar Juegos Iniciales ===');
      
      final juegosIniciales = [
        JuegoModel(
          id: 0,
          nombre: 'ABC Divertido',
          descripcion: 'Aprende el abecedario de forma interactiva',
        ),
        JuegoModel(
          id: 0,
          nombre: 'Números Mágicos',
          descripcion: 'Descubre los números del 1 al 10',
        ),
        JuegoModel(
          id: 0,
          nombre: 'Colores y Formas',
          descripcion: 'Identifica colores y formas geométricas',
        ),
        JuegoModel(
          id: 0,
          nombre: 'Animales Fantásticos',
          descripcion: 'Conoce los sonidos y nombres de animales',
        ),
      ];

      for (var juego in juegosIniciales) {
        // Verificar si ya existe
        final existe = await _db.juegos.existeJuegoConNombre(juego.nombre);
        
        if (!existe) {
          final juegoCreado = await _db.juegos.crearJuego(juego);
          print('🎯 Juego agregado: ${juegoCreado?.nombre}');
        } else {
          print('⏭️ Juego ya existe: ${juego.nombre}');
        }
      }

      print('✅ Configuración de juegos completada\n');
      
    } catch (e) {
      print('❌ Error en configurar juegos: $e\n');
    }
  }

  /// Ejemplo 3: Registrar progreso de juego
  static Future<void> ejemploRegistrarProgreso() async {
    try {
      print('📈 === EJEMPLO: Registrar Progreso de Juego ===');
      
      // Buscar un usuario y un juego para el ejemplo
      final usuarios = await _db.usuarios.obtenerTodos();
      final juegos = await _db.juegos.obtenerJuegos();
      
      if (usuarios.isEmpty || juegos.isEmpty) {
        print('⚠️ No hay usuarios o juegos disponibles para el ejemplo');
        return;
      }

      final usuario = usuarios.first;
      final juego = juegos.first;
      
      // Crear progreso inicial
      final nuevoProgreso = ProgresoModel(
        id: 0,
        idJuego: juego.id,
        nivel: 1,
        puntaje: 85,
        rachaMaxima: 5,
        idUsuario: usuario.id,
        idInvitado: 0, // Si es 0, indica que no hay invitado
      );

      final progresoCreado = await _db.progreso.crearProgreso(nuevoProgreso.toJson());
      print('📊 Progreso registrado: Nivel ${progresoCreado?['nivel']}, Puntaje ${progresoCreado?['puntaje']}');

      // Simular progreso en varios niveles
      for (int nivel = 2; nivel <= 5; nivel++) {
        final progresoNivel = ProgresoModel(
          id: 0,
          idJuego: juego.id,
          nivel: nivel,
          puntaje: 70 + (nivel * 5), // Puntaje creciente
          rachaMaxima: nivel + 2,
          idUsuario: usuario.id,
          idInvitado: 0,
        );

        await _db.progreso.crearProgreso(progresoNivel.toJson());
        print('🎯 Nivel $nivel completado: ${progresoNivel.puntaje} pts');
      }

      // Obtener estadísticas del juego
      final estadisticas = await _db.progreso.obtenerEstadisticasJuego(juego.id);
      print('📈 Estadísticas del juego "${juego.nombre}":');
      print('   Total jugadores: ${estadisticas['totalJugadores']}');
      print('   Mejor puntaje: ${estadisticas['mejorPuntaje']}');

      print('✅ Registro de progreso completado\n');
      
    } catch (e) {
      print('❌ Error en registrar progreso: $e\n');
    }
  }

  /// Ejemplo 4: Consultar progreso del usuario
  static Future<void> ejemploConsultarProgreso() async {
    try {
      print('📊 === EJEMPLO: Consultar Progreso del Usuario ===');
      
      final usuarios = await _db.usuarios.obtenerTodos();
      
      if (usuarios.isEmpty) {
        print('⚠️ No hay usuarios disponibles');
        return;
      }

      final usuario = usuarios.first;
      print('👤 Consultando progreso de: ${usuario.nombre}');

      // Obtener todo el progreso del usuario
      final progreso = await _db.progreso.obtenerProgresoUsuario(usuario.idProgreso);
      
      if (progreso == null || progreso.isEmpty) {
        print('📭 No hay progreso registrado para este usuario');
        return;
      }

      print('📊 Progreso del usuario ${usuario.nombre}:');
      print('   Nivel actual: ${progreso['nivel']}');
      print('   Racha 1: ${progreso['racha_1']}');
      print('   Racha 2: ${progreso['racha_2']}');

      print('✅ Consulta de progreso completada\n');
      
    } catch (e) {
      print('❌ Error al consultar progreso: $e\n');
    }
  }

  /// Ejemplo 5: Búsquedas y filtros
  static Future<void> ejemploBusquedasYFiltros() async {
    try {
      print('🔍 === EJEMPLO: Búsquedas y Filtros ===');
      
      // Buscar usuarios jóvenes (obtenemos todos y filtramos)
      print('👶 Usuarios menores de 10 años:');
      final todosLosUsuarios = await _db.usuarios.obtenerTodos();
      final usuariosJovenes = todosLosUsuarios.where((usuario) => usuario.edad < 10).toList();
      for (var usuario in usuariosJovenes) {
        print('   ${usuario.nombre} (${usuario.edad} años)');
      }

      // Buscar juegos por nombre
      print('\n🎮 Juegos que contengan "ABC":');
      final juegosABC = await _db.juegos.buscarJuegosPorNombre('ABC');
      for (var juego in juegosABC) {
        print('   ${juego.nombre}: ${juego.descripcion}');
      }

      // Obtener mejores puntajes
      final usuarios = await _db.usuarios.obtenerTodos();
      final juegos = await _db.juegos.obtenerJuegos();
      
      if (usuarios.isNotEmpty && juegos.isNotEmpty) {
        print('\n🏆 Mejores puntajes:');
        for (var juego in juegos.take(3)) {
          final mejorProgreso = await _db.progreso.obtenerMejorPuntaje(
            usuarios.first.id, 
            juego.nombre
          );
          
          if (mejorProgreso != null) {
            print('   ${juego.nombre}: ${mejorProgreso['puntaje']} pts');
          }
        }
      }

      print('✅ Búsquedas completadas\n');
      
    } catch (e) {
      print('❌ Error en búsquedas: $e\n');
    }
  }

  /// Ejecuta todos los ejemplos en secuencia
  static Future<void> ejecutarTodosLosEjemplos() async {
    print('🚀 === EJECUTANDO TODOS LOS EJEMPLOS DE USO DE BD ===\n');
    
    await ejemploCrearPerfilUsuario();
    await ejemploConfigurarJuegos();
    await ejemploRegistrarProgreso();
    await ejemploConsultarProgreso();
    await ejemploBusquedasYFiltros();
    
    print('🎉 === TODOS LOS EJEMPLOS COMPLETADOS ===');
  }
}
