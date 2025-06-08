import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio para manejar deep links y redirecciones de autenticación
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  /// Cliente de Supabase
  SupabaseClient get _supabase => Supabase.instance.client;

  /// Inicializa el servicio de deep links
  Future<void> inicializar() async {
    try {
      print('🔗 [DeepLinkService] Inicializando servicio de deep links');

      _appLinks = AppLinks();

      // Verificar si la app fue abierta desde un link
      try {
        final initialLink = await _appLinks.getInitialLink();
        if (initialLink != null) {
          print(
            '🔗 [DeepLinkService] App abierta desde deep link: $initialLink',
          );
          _manejarLink(initialLink);
        } else {
          print('🔗 [DeepLinkService] No hay link inicial');
        }
      } catch (e) {
        print('⚠️ [DeepLinkService] Error al obtener link inicial: $e');
      }

      // Escuchar links cuando la app ya está abierta
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (uri) {
          print('🔗 [DeepLinkService] Link recibido via stream: $uri');
          _manejarLink(uri);
        },
        onError: (err) {
          print('❌ [DeepLinkService] Error en deep link stream: $err');
        },
      );

      print('✅ [DeepLinkService] Servicio inicializado correctamente');
      print('🔗 [DeepLinkService] Escuchando esquema: chemakids://');
    } catch (e) {
      print('❌ [DeepLinkService] Error al inicializar: $e');
    }
  }

  /// Maneja los deep links recibidos
  void _manejarLink(Uri uri) {
    print('🔗 [DeepLinkService] Procesando deep link: $uri');

    try {
      // Verificar si es un link de autenticación de Supabase
      if (uri.scheme == 'chemakids' && uri.host == 'auth') {
        _manejarAutenticacion(uri);
      } else if (uri.scheme == 'chemakids') {
        _manejarNavegacion(uri);
      } else {
        print(
          '⚠️ [DeepLinkService] Esquema de URL no reconocido: ${uri.scheme}',
        );
      }
    } catch (e) {
      print('❌ [DeepLinkService] Error al procesar deep link: $e');
    }
  }

  /// Maneja links de autenticación (verificación de email, reset password)
  void _manejarAutenticacion(Uri uri) async {
    print('🔐 [DeepLinkService] Procesando autenticación: $uri');

    try {
      // Extraer parámetros del fragment (#) de la URL
      final fragment = uri.fragment;
      if (fragment.isNotEmpty) {
        final params = Uri.splitQueryString(fragment);

        // Verificar si es una verificación de email
        if (params.containsKey('access_token') &&
            params.containsKey('refresh_token')) {
          print('📧 [DeepLinkService] Procesando verificación de email');

          // Usar la sesión desde la URL
          await _supabase.auth.getSessionFromUrl(uri);

          print('✅ [DeepLinkService] Email verificado exitosamente');

          // Mostrar notificación de éxito
          _mostrarNotificacion(
            '✅ Email Verificado',
            'Tu cuenta ha sido verificada exitosamente. ¡Ya puedes usar todas las funciones de ChemaKids!',
            Colors.green,
          );
        } else if (params.containsKey('error')) {
          print(
            '❌ [DeepLinkService] Error en autenticación: ${params['error']}',
          );

          _mostrarNotificacion(
            '❌ Error de Verificación',
            'Hubo un problema al verificar tu email: ${params['error_description'] ?? params['error']}',
            Colors.red,
          );
        }
      }
    } catch (e) {
      print('❌ [DeepLinkService] Error al procesar autenticación: $e');

      _mostrarNotificacion(
        '❌ Error',
        'Hubo un problema al procesar la verificación. Intenta nuevamente.',
        Colors.red,
      );
    }
  }

  /// Maneja navegación dentro de la app
  void _manejarNavegacion(Uri uri) {
    print('🧭 [DeepLinkService] Procesando navegación: $uri');

    try {
      final path = uri.path;
      final context = navigatorKey.currentContext;

      if (context != null) {
        // Navegar según el path
        switch (path) {
          case '/menu':
            Navigator.of(context).pushReplacementNamed('/menu');
            break;
          case '/perfil':
            Navigator.of(context).pushNamed('/perfil');
            break;
          default:
            print('⚠️ [DeepLinkService] Ruta no reconocida: $path');
        }
      }
    } catch (e) {
      print('❌ [DeepLinkService] Error en navegación: $e');
    }
  }

  /// Muestra una notificación al usuario
  void _mostrarNotificacion(String titulo, String mensaje, Color color) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(mensaje),
            ],
          ),
          backgroundColor: color,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  /// Dispone del servicio
  void dispose() {
    _linkSubscription?.cancel();
  }

  /// Obtiene la URL de redirección para autenticación
  static String get redirectUrl => 'chemakids://auth';

  /// Obtiene la URL base para deep links
  static String get baseUrl => 'chemakids://';
}

/// Navigator key global para navegación desde servicios
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
