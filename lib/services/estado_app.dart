import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/usuario_model.dart';
import '../models/invitado_model.dart';
import 'progreso_service.dart';
import 'auth_service.dart';
import 'usuario_service.dart';

class EstadoApp extends ChangeNotifier {
  UsuarioModel? _usuarioAutenticado;
  InvitadoModel? _usuarioInvitado;
  bool _esInvitado = false;
  bool _inicializado = false;
  
  // Cache del progreso actual
  Map<String, dynamic>? _progresoActual;
  // Claves para SharedPreferences
  static const String _keyEsInvitado = 'es_invitado';
  static const String _keyUsuarioInvitado = 'usuario_invitado';
  static const String _keyProgresoActual = 'progreso_actual';

  EstadoApp() {
    _inicializar();
  }
  // Getters para determinar el tipo de usuario actual
  bool get esInvitado => _esInvitado;
  bool get tieneUsuario =>
      _usuarioAutenticado != null || _usuarioInvitado != null;
  bool get inicializado => _inicializado;

  /// Inicializa el estado de la aplicación restaurando la sesión si existe
  Future<void> _inicializar() async {
    try {
      print('🔄 [EstadoApp] Inicializando estado de la aplicación...');
      
      // Primero verificar si hay una sesión de Supabase activa
      final authService = AuthService();
      if (authService.isAuthenticated) {
        print('✅ [EstadoApp] Sesión de Supabase detectada, restaurando usuario autenticado...');
        await _restaurarUsuarioAutenticado();
      } else {
        // Si no hay sesión de Supabase, verificar si hay un invitado guardado
        await _restaurarSesionGuardada();
      }
      
      _inicializado = true;
      notifyListeners();
      print('✅ [EstadoApp] Estado inicializado correctamente');
    } catch (e) {
      print('❌ [EstadoApp] Error al inicializar estado: $e');
      _inicializado = true;
      notifyListeners();
    }
  }

  /// Restaura un usuario autenticado desde Supabase
  Future<void> _restaurarUsuarioAutenticado() async {
    try {
      final authService = AuthService();
      final currentUser = authService.currentUser;
      
      if (currentUser != null) {
        // Buscar el usuario en la base de datos
        final usuarioService = UsuarioService.instance;
        final usuario = await usuarioService.obtenerPorAuthUser(currentUser.id);
        
        if (usuario != null) {
          await establecerUsuarioAutenticado(usuario);
          print('✅ [EstadoApp] Usuario autenticado restaurado: ${usuario.nombre}');
        } else {
          print('⚠️ [EstadoApp] Usuario de Supabase no encontrado en BD local');
        }
      }
    } catch (e) {
      print('❌ [EstadoApp] Error al restaurar usuario autenticado: $e');
    }
  }
  /// Restaura la sesión guardada localmente (principalmente para invitados)
  Future<void> _restaurarSesionGuardada() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final esInvitado = prefs.getBool(_keyEsInvitado) ?? false;
      
      print('🔍 [EstadoApp] Verificando sesión guardada - esInvitado: $esInvitado');
      
      if (esInvitado) {
        // Restaurar invitado
        final invitadoJson = prefs.getString(_keyUsuarioInvitado);
        print('🔍 [EstadoApp] JSON del invitado guardado: $invitadoJson');
          if (invitadoJson != null && invitadoJson.isNotEmpty) {
          try {
            final invitadoMap = json.decode(invitadoJson);
            print('🔍 [EstadoApp] Map del invitado: $invitadoMap');
              // Verificar y manejar campos faltantes
            final id = invitadoMap['id'] as int? ?? 0;
            final idProgreso = invitadoMap['id_progreso'] as int? ?? 0;
            final nombre = invitadoMap['nombre'] as String;
            final edad = invitadoMap['edad'] as int;
            
            print('🔍 [EstadoApp] Campos del invitado - ID: $id, ID_Progreso: $idProgreso');
            
            if (id == 0 || idProgreso == 0) {
              print('⚠️ [EstadoApp] Invitado tiene IDs en 0 (modo offline), pero restaurando sesión');
            }
            
            // Crear el mapa formateado con fallbacks
            final invitadoMapFormatted = {
              'id': id,
              'nombre': nombre,
              'edad': edad,
              'id_progreso': idProgreso,
            };
            
            final invitado = InvitadoModel.fromJson(invitadoMapFormatted);
            
            // Establecer el invitado sin volver a guardarlo
            _usuarioInvitado = invitado;
            _usuarioAutenticado = null;
            _esInvitado = true;
            
            print('✅ [EstadoApp] Usuario invitado restaurado: ${invitado.nombre} (ID: ${invitado.id})');
          } catch (e) {
            print('❌ [EstadoApp] Error al decodificar datos del invitado: $e');
            print('🧹 [EstadoApp] Limpiando sesión guardada corrupta');
            
            // Limpiar datos corruptos
            await prefs.remove(_keyUsuarioInvitado);
            await prefs.remove(_keyEsInvitado);
            await prefs.remove(_keyProgresoActual);
          }
        }
      }
      
      // Restaurar progreso si existe
      final progresoJson = prefs.getString(_keyProgresoActual);
      if (progresoJson != null && progresoJson.isNotEmpty) {
        try {
          _progresoActual = json.decode(progresoJson);
          print('✅ [EstadoApp] Progreso restaurado: nivel ${_progresoActual!['nivel']}');
        } catch (e) {
          print('❌ [EstadoApp] Error al decodificar progreso: $e');
        }
      }
    } catch (e) {
      print('❌ [EstadoApp] Error al restaurar sesión guardada: $e');
    }
  }
  /// Guarda el estado actual en SharedPreferences
  Future<void> _guardarEstado() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool(_keyEsInvitado, _esInvitado);      if (_esInvitado && _usuarioInvitado != null) {
        // Logs de debug para ver el estado del invitado
        print('🔍 [EstadoApp] Guardando invitado - Estado actual:');
        print('  - Nombre: ${_usuarioInvitado!.nombre}');
        print('  - ID: ${_usuarioInvitado!.id}');
        print('  - ID Progreso: ${_usuarioInvitado!.idProgreso}');
        print('  - Edad: ${_usuarioInvitado!.edad}');
        
        // Intentar usar toJsonWithId() y verificar el resultado
        final invitadoJson = _usuarioInvitado!.toJsonWithId();
        print('🔍 [EstadoApp] Resultado de toJsonWithId(): $invitadoJson');
        
        // Guardar siempre, incluso si los IDs son 0 (modo offline)
        await prefs.setString(_keyUsuarioInvitado, json.encode(invitadoJson));
        print('💾 [EstadoApp] JSON guardado en SharedPreferences: ${json.encode(invitadoJson)}');
      } else {
        await prefs.remove(_keyUsuarioInvitado);
      }
      
      if (_progresoActual != null) {
        await prefs.setString(_keyProgresoActual, json.encode(_progresoActual!));
        print('💾 [EstadoApp] Guardando progreso: nivel ${_progresoActual!['nivel']}');
      }
      
      print('✅ [EstadoApp] Estado guardado exitosamente');
    } catch (e) {
      print('❌ [EstadoApp] Error al guardar estado: $e');
    }
  }

  UsuarioModel? get usuarioAutenticado => _usuarioAutenticado;
  InvitadoModel? get usuarioInvitado => _usuarioInvitado;

  // Getter unificado para obtener datos básicos del usuario actual
  String get nombreUsuario {
    if (_esInvitado && _usuarioInvitado != null) {
      return _usuarioInvitado!.nombre;
    } else if (_usuarioAutenticado != null) {
      return _usuarioAutenticado!.nombre;
    }
    return 'Usuario';
  }

  int get nivelUsuario {
    if (_progresoActual != null) {
      return _progresoActual!['nivel'] as int? ?? 1;
    }
    return 1;
  }

  int get edadUsuario {
    if (_esInvitado && _usuarioInvitado != null) {
      return _usuarioInvitado!.edad;
    } else if (_usuarioAutenticado != null) {
      return _usuarioAutenticado!.edad;
    }
    return 0;
  }  // Métodos para establecer el usuario
  Future<void> establecerUsuarioAutenticado(UsuarioModel usuario) async {
    _usuarioAutenticado = usuario;
    _usuarioInvitado = null;
    _esInvitado = false;
    
    // Cargar progreso del usuario
    try {
      final progresoService = ProgresoService.instance;
      final progreso = await progresoService.obtenerProgresoUsuario(usuario.idProgreso);
      if (progreso != null) {
        _progresoActual = progreso;
      }
    } catch (e) {
      print('⚠️ [EstadoApp] Error al cargar progreso del usuario: $e');
      // Progreso por defecto
      _progresoActual = {'nivel': 1, 'racha_1': 0, 'racha_2': 0};
    }
    
    // Guardar estado para persistencia (solo el progreso, no el usuario autenticado)
    await _guardarEstado();
    
    notifyListeners();
    print('✅ [EstadoApp] Usuario autenticado establecido: ${usuario.nombre}');
  }

  Future<void> establecerUsuarioInvitado(InvitadoModel invitado) async {
    _usuarioInvitado = invitado;
    _usuarioAutenticado = null;
    _esInvitado = true;
    
    // Cargar progreso del invitado
    try {
      final progresoService = ProgresoService.instance;
      final progreso = await progresoService.obtenerProgresoInvitado(invitado.idProgreso);
      if (progreso != null) {
        _progresoActual = progreso;
      }
    } catch (e) {
      print('⚠️ [EstadoApp] Error al cargar progreso del invitado: $e');
      // Progreso por defecto
      _progresoActual = {'nivel': 1, 'racha_1': 0, 'racha_2': 0};
    }
    
    // Guardar estado para persistencia
    await _guardarEstado();
    
    notifyListeners();
    print('✅ [EstadoApp] Usuario invitado establecido: ${invitado.nombre}');
  }  // Método para cerrar sesión (limpiar usuario)
  Future<void> cerrarSesion() async {
    _usuarioAutenticado = null;
    _usuarioInvitado = null;
    _esInvitado = false;
    _progresoActual = null;
    
    // Limpiar estado guardado
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyEsInvitado);
      await prefs.remove(_keyUsuarioInvitado);
      await prefs.remove(_keyProgresoActual);
    } catch (e) {
      print('❌ [EstadoApp] Error al limpiar estado guardado: $e');
    }
    
    notifyListeners();
    print('🚪 [EstadoApp] Sesión cerrada - usuario y estado limpiados');
  }  // Método para actualizar nivel (actualiza el progreso correspondiente)
  Future<void> actualizarNivel(int nuevoNivel) async {
    if (_progresoActual != null) {
      _progresoActual!['nivel'] = nuevoNivel;
      await _guardarEstado();
      notifyListeners();
      print('📈 [EstadoApp] Nivel actualizado a: $nuevoNivel');
    }
  }
  // Método para establecer el progreso actual
  Future<void> establecerProgreso(Map<String, dynamic> progreso) async {
    _progresoActual = progreso;
    await _guardarEstado();
    notifyListeners();
    print('📊 [EstadoApp] Progreso establecido: nivel ${progreso['nivel']}');
  }
  // Compatibilidad con el modelo antiguo - mantener por ahora
  @Deprecated('Usar nombreUsuario, nivelUsuario, etc.')
  dynamic get usuario {
    if (_esInvitado && _usuarioInvitado != null) {
      return _usuarioInvitado;
    } else if (_usuarioAutenticado != null) {
      return _usuarioAutenticado;
    }
    return null;
  }
  
  /// Método de debug para verificar el estado guardado en SharedPreferences
  Future<void> debugEstadoGuardado() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('🔍 [DEBUG] Estado en SharedPreferences:');
      print('  - esInvitado: ${prefs.getBool(_keyEsInvitado)}');
      print('  - usuarioInvitado: ${prefs.getString(_keyUsuarioInvitado)}');
      print('  - progresoActual: ${prefs.getString(_keyProgresoActual)}');
      print('🔍 [DEBUG] Estado actual en memoria:');
      print('  - _esInvitado: $_esInvitado');
      print('  - _usuarioInvitado: $_usuarioInvitado');
      print('  - _progresoActual: $_progresoActual');
      print('  - tieneUsuario: $tieneUsuario');
    } catch (e) {
      print('❌ [DEBUG] Error al leer estado guardado: $e');
    }
  }
}
