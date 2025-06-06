import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'servicios/estado_app.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          '/numeros': (context) => const JuegoNumeros(),
          '/formar-palabras': (context) => const JuegoFormarPalabras(),
          '/memorama': (context) => const JuegoMemorama(),
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
