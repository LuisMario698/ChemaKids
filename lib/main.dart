import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'servicios/estado_app.dart';
import 'servicios/database_manager.dart';
import 'pantallas/inicio.dart';
import 'pantallas/menu.dart';
import 'pantallas/juego_abc.dart';
import 'pantallas/juego_que_es.dart';
import 'pantallas/juego_silabas.dart';
import 'pantallas/juego_rimas.dart';
import 'pantallas/juego_colores.dart';
import 'pantallas/juego_formas.dart';
import 'pantallas/juego_animales.dart';
import 'pantallas/juego_silabasdesdecero.dart';
import 'pantallas/juego_numeros.dart';
import 'pantallas/juego_formar_palabras.dart';
import 'pantallas/juego_memorama.dart';
import 'pantallas/juego_sumas_y_restas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🚀 Inicializar base de datos Supabase
  print('🎮 Iniciando ChemaKids...');
  
  try {
    final dbInitialized = await DatabaseManager.instance.inicializar();
    
    if (dbInitialized) {
      print('✅ Base de datos inicializada correctamente');
      
      // Verificar estado de servicios
      await DatabaseManager.instance.verificarEstadoServicios();
      
      // Obtener estadísticas generales
      await DatabaseManager.instance.obtenerEstadisticasGenerales();
      
    } else {
      print('⚠️ Base de datos no pudo inicializarse - funcionando en modo offline');
    }
    
  } catch (e) {
    print('❌ Error crítico al inicializar base de datos: $e');
    print('📱 La app continuará en modo offline');
  }
  
  runApp(const ChemakidsApp());
}

class ChemakidsApp extends StatelessWidget {
  const ChemakidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EstadoApp(),
      child: MaterialApp(
        title: 'Chemakids',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const PantallaInicio(),
          '/menu': (context) => const PantallaMenu(),
          '/abc': (context) => const JuegoABC(),
          '/silabasdesdecero': (context) => const JuegoSilabasDesdeCero(),
          '/silabas': (context) => const JuegoSilabas(),
          '/que-es': (context) => const JuegoQueEs(),
          '/rimas': (context) => const JuegoRimas(),
          '/colores': (context) => const JuegoColores(),
          '/formas': (context) => const JuegoFormas(),
          '/animales': (context) => const JuegoAnimales(),
          '/numeros': (context) => const JuegoNumeros(),          '/formar-palabras': (context) => const JuegoFormarPalabras(),
          '/memorama': (context) => const JuegoMemorama(),
          '/sumas-restas': (context) => const JuegoSumasYRestas(),
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
      ),
    );
  }
}
