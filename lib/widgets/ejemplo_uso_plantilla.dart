import 'package:flutter/material.dart';
import '../widgets/tema_juego_chemakids.dart';

/// EJEMPLO: Cómo usar la plantilla de fondo animado en un juego
/// Este es un ejemplo que muestra cómo convertir cualquier juego existente
/// para usar la nueva plantilla unificada de ChemaKids

class EjemploUsoPlantilla extends StatefulWidget {
  const EjemploUsoPlantilla({super.key});

  @override
  State<EjemploUsoPlantilla> createState() => _EjemploUsoPlantillaState();
}

class _EjemploUsoPlantillaState extends State<EjemploUsoPlantilla> {
  
  void _mostrarPista() {
    // Lógica de pista
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Aquí tienes una pista!'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // OPCIÓN 1: Usar PlantillaJuegoChemaKids (más simple)
    return PlantillaJuegoChemaKids(
      titulo: 'Mi Juego',
      icono: Icons.games,
      onAyuda: _mostrarPista,
      contenido: _buildContenidoJuego(),
    );
    
    // OPCIÓN 2: Usar componentes por separado (más control)
    /*
    return FondoAnimadoChemaKids(
      child: SafeArea(
        child: Column(
          children: [
            EncabezadoJuegoChemaKids(
              titulo: 'Mi Juego',
              icono: Icons.games,
              onAyuda: _mostrarPista,
            ),
            Expanded(
              child: _buildContenidoJuego(),
            ),
          ],
        ),
      ),
    );
    */
  }
  
  Widget _buildContenidoJuego() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ejemplo de contenedor usando los estilos estándar
          Container(
            width: 200,
            height: 100,
            decoration: EstilosChemaKids.contenedorJuego(
              color: Colors.white,
              borderColor: Colors.deepPurple,
            ),
            child: const Center(
              child: Text(
                'Contenido del Juego',
                style: EstilosChemaKids.textoJuego,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Ejemplo de botón con estilo estándar
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: EstilosChemaKids.colorPrimario,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text(
              'Botón de Ejemplo',
              style: EstilosChemaKids.textoBoton,
            ),
          ),
        ],
      ),
    );
  }
}

/// EJEMPLO: Cómo convertir un juego existente paso a paso
/// 
/// ANTES:
/// ```dart
/// class MiJuego extends StatefulWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text('Mi Juego')),
///       body: Container(
///         color: Colors.grey[200],
///         child: _buildContenido(),
///       ),
///     );
///   }
/// }
/// ```
/// 
/// DESPUÉS:
/// ```dart
/// class MiJuego extends StatefulWidget {
///   @override
///   Widget build(BuildContext context) {
///     return PlantillaJuegoChemaKids(
///       titulo: 'Mi Juego',
///       icono: Icons.games,
///       onAyuda: _mostrarPista,
///       contenido: _buildContenido(),
///     );
///   }
/// }
/// ```

/// MIGRACIÓN PASO A PASO:
/// 
/// 1. Importar la plantilla:
///    ```dart
///    import '../widgets/tema_juego_chemakids.dart';
///    ```
/// 
/// 2. Reemplazar Scaffold + AppBar con PlantillaJuegoChemaKids:
///    - Quitar: Scaffold, AppBar, backgroundColor
///    - Agregar: PlantillaJuegoChemaKids con título, icono, contenido
/// 
/// 3. Mover el contenido principal al parámetro 'contenido':
///    - Todo lo que estaba en body: va a contenido:
/// 
/// 4. Agregar función de ayuda (opcional):
///    - Crear método _mostrarPista() o similar
///    - Pasarlo al parámetro onAyuda:
/// 
/// 5. Usar estilos estándar (opcional pero recomendado):
///    - Reemplazar colores hardcodeados con EstilosChemaKids.colorPrimario
///    - Usar EstilosChemaKids.contenedorJuego() para contenedores
///    - Usar EstilosChemaKids.textoJuego para textos grandes
/// 
/// 6. Quitar animaciones de fondo personalizadas:
///    - Ya no necesitas AnimationController para el fondo
///    - Puedes mantener animaciones específicas del juego
