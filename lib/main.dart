import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/estado_app.dart';
import 'services/database_manager.dart';
import 'services/deep_link_service.dart';
import 'pantallas/inicio.dart';
import 'screens/menu.dart';
import 'screens/nombre_edad.dart';
import 'screens/auth.dart';
import 'screens/juego_abc.dart';
import 'screens/juego_abc_audio.dart';
import 'screens/juego_que_es.dart';
import 'screens/juego_silabas.dart';
import 'screens/juego_rimas.dart';
import 'screens/juego_colores.dart';
import 'screens/juego_formas.dart';
import 'screens/juego_animales.dart';
import 'screens/juego_silabasdesdecero.dart';
import 'screens/juego_silabas_audio.dart';
import 'screens/juego_numeros.dart';
import 'screens/juego_formar_palabras.dart';
import 'screens/juego_memorama.dart';
import 'screens/juego_sumas_y_restas.dart';
import 'pantallas/registro_invitado.dart';

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚀 Inicializar base de datos Supabase
  print('🎮 Iniciando ChemaKids...');
  try {
    final dbInitialized = await DatabaseManager.instance.inicializar();

    if (dbInitialized) {
      print('✅ Base de datos inicializada correctamente');
    } else {
      print(
        '⚠️ Base de datos no pudo inicializarse - funcionando en modo offline',
      );
    }
  } catch (e) {
    print('❌ Error al inicializar base de datos: $e');
    print('📱 La app continuará funcionando normalmente');
  }

  // 🔗 Inicializar servicio de deep links
  try {
    await DeepLinkService().inicializar();
    print('✅ Servicio de deep links inicializado');
  } catch (e) {
    print('⚠️ Error al inicializar deep links: $e');
  }

  runApp(const ChemakidsApp());
}

class ChemakidsApp extends StatelessWidget {
  const ChemakidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EstadoApp(),
      child: Consumer<EstadoApp>(
        builder: (context, estadoApp, child) {
          // Mostrar splash screen mientras se inicializa
          if (!estadoApp.inicializado) {
            return MaterialApp(
              home: Scaffold(
                backgroundColor: const Color(0xFF2A0944),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Cargando ChemaKids...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          // App principal una vez inicializada
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Chemakids',
            debugShowCheckedModeBanner: false,
            // Determinar ruta inicial basándose en si hay sesión activa
            initialRoute: estadoApp.tieneUsuario ? '/menu' : '/',            routes: {
              '/': (context) => const PantallaInicio(),
              '/menu': (context) => const PantallaMenu(),
              '/nombre-edad': (context) => const PantallaNombreEdad(),
              '/auth': (context) => const PantallaAuth(),
              '/abc': (context) => const JuegoABC(),
              '/abc-audio': (context) => const JuegoAbcAudio(),              '/silabasdesdecero': (context) => const JuegoSilabasDesdeCero(),
              '/silabas-audio': (context) => const JuegoSilabasAudio(),
              '/silabas': (context) => const JuegoSilabas(),
              '/que-es': (context) => const JuegoQueEs(),
              '/rimas': (context) => const JuegoRimas(),
              '/colores': (context) => const JuegoColores(),
              '/formas': (context) => const JuegoFormas(),
              '/animales': (context) => const JuegoAnimales(),
              '/numeros': (context) => const JuegoNumeros(),
              '/formar-palabras': (context) => const JuegoFormarPalabras(),
              '/memorama': (context) => const JuegoMemorama(),
              '/sumas-restas': (context) => const JuegoSumasYRestas(),
              '/registro-invitado':
                  (context) => const PantallaRegistroInvitado(),
            },
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              scaffoldBackgroundColor: const Color(0xFF2A0944),
              iconTheme: const IconThemeData(size: 32, fill: 1),
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
