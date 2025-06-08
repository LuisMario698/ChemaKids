import 'package:flutter/foundation.dart';
import '../models/usuario_model.dart';
import '../models/invitado_model.dart';
import 'progreso_service.dart';

class EstadoApp extends ChangeNotifier {
  UsuarioModel? _usuarioAutenticado;
  InvitadoModel? _usuarioInvitado;
  bool _esInvitado = false;
  
  // Cache del progreso actual
  Map<String, dynamic>? _progresoActual;

  EstadoApp();

  // Getters para determinar el tipo de usuario actual
  bool get esInvitado => _esInvitado;
  bool get tieneUsuario =>
      _usuarioAutenticado != null || _usuarioInvitado != null;

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
  }
  // Métodos para establecer el usuario
  void establecerUsuarioAutenticado(UsuarioModel usuario) async {
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
    
    notifyListeners();
    print('✅ [EstadoApp] Usuario autenticado establecido: ${usuario.nombre}');
  }

  void establecerUsuarioInvitado(InvitadoModel invitado) async {
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
    
    notifyListeners();
    print('✅ [EstadoApp] Usuario invitado establecido: ${invitado.nombre}');
  }
  // Método para cerrar sesión (limpiar usuario)
  void cerrarSesion() {
    _usuarioAutenticado = null;
    _usuarioInvitado = null;
    _esInvitado = false;
    _progresoActual = null;
    notifyListeners();
    print('🚪 [EstadoApp] Sesión cerrada - usuario limpiado');
  }
  // Método para actualizar nivel (actualiza el progreso correspondiente)
  void actualizarNivel(int nuevoNivel) {
    if (_progresoActual != null) {
      _progresoActual!['nivel'] = nuevoNivel;
      notifyListeners();
      print('📈 [EstadoApp] Nivel actualizado a: $nuevoNivel');
    }
  }

  // Método para establecer el progreso actual
  void establecerProgreso(Map<String, dynamic> progreso) {
    _progresoActual = progreso;
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
}
