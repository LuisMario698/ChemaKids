import 'package:flutter/material.dart';

/// Plantilla de fondo animado reutilizable para todos los juegos de ChemaKids
/// Basado en el diseño del juego "formar palabras" con burbujas coloridas animadas
class FondoAnimadoChemaKids extends StatefulWidget {
  /// Color de fondo base (por defecto gris claro)
  final Color backgroundColor;
  
  /// Número de burbujas animadas (por defecto 10)
  final int numeroBurbujas;
  
  /// Duración de la animación en segundos (por defecto 10)
  final int duracionSegundos;
  
  /// Widget hijo que se renderiza sobre el fondo
  final Widget child;

  const FondoAnimadoChemaKids({
    super.key,
    this.backgroundColor = const Color(0xFFF6F6F6),
    this.numeroBurbujas = 10,
    this.duracionSegundos = 10,
    required this.child,
  });

  @override
  State<FondoAnimadoChemaKids> createState() => _FondoAnimadoChemaKidsState();
}

class _FondoAnimadoChemaKidsState extends State<FondoAnimadoChemaKids>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _bgController;
  late Animation<double> _bgAnimation;

  // Paleta de colores llamativos y suaves para las burbujas
  static const List<Color> _bubbleColors = [
    Color(0xFFFFB74D), // Naranja claro
    Color(0xFF64B5F6), // Azul claro
    Color(0xFF81C784), // Verde claro
    Color(0xFFE57373), // Rojo claro
    Color(0xFFBA68C8), // Púrpura claro
    Color(0xFFFFF176), // Amarillo claro
    Color(0xFFFF8A65), // Naranja coral
    Color(0xFF4DD0E1), // Cian claro
    Color(0xFFAED581), // Verde lima
    Color(0xFFFFD54F), // Amarillo dorado
  ];

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      duration: Duration(seconds: widget.duracionSegundos),
      vsync: this,
    )..repeat(reverse: true);
    
    _bgAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _bgController, 
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Stack(
        children: [
          // Fondo animado con burbujas coloridas
          AnimatedBuilder(
            animation: _bgAnimation,
            builder: (context, child) {
              final width = MediaQuery.of(context).size.width;
              final height = MediaQuery.of(context).size.height;
              
              return Stack(
                children: List.generate(widget.numeroBurbujas, (i) {
                  // Tamaño variable de las burbujas con animación
                  final double size = 70 + 40 * 
                      (i % 2 == 0 
                          ? _bgAnimation.value 
                          : 1 - _bgAnimation.value);
                  
                  // Posición vertical animada
                  final double top = (height * 
                      (0.1 + 0.7 * 
                          ((i * 0.13 + _bgAnimation.value * 
                              (i.isEven ? 0.5 : -0.5)) % 1)))
                      .clamp(0, height - size);
                  
                  // Posición horizontal animada
                  final double left = (width * 
                      (0.05 + 0.8 * 
                          ((i * 0.19 + (1 - _bgAnimation.value) * 
                              (i.isOdd ? 0.4 : -0.4)) % 1)))
                      .clamp(0, width - size);
                  
                  // Color con opacidad variable
                  final color = _bubbleColors[i % _bubbleColors.length]
                      .withOpacity(0.18 + 0.07 * (i % 3));
                  
                  return Positioned(
                    top: top,
                    left: left,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.25),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          // Widget hijo renderizado sobre el fondo
          widget.child,
        ],
      ),
    );
  }
}

/// Widget de encabezado estandarizado para todos los juegos
class EncabezadoJuegoChemaKids extends StatelessWidget {
  /// Título del juego que aparece en el centro
  final String titulo;
  
  /// Icono que aparece junto al título (opcional)
  final IconData? icono;
  
  /// Color del icono (por defecto amber)
  final Color colorIcono;
  
  /// Función callback para el botón de regreso
  final VoidCallback? onBack;
  
  /// Función callback para el botón de ayuda/pista (opcional)
  final VoidCallback? onAyuda;
  
  /// Si mostrar o no el botón de ayuda
  final bool mostrarAyuda;

  const EncabezadoJuegoChemaKids({
    super.key,
    required this.titulo,
    this.icono,
    this.colorIcono = Colors.amber,
    this.onBack,
    this.onAyuda,
    this.mostrarAyuda = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 8,
      ),
      child: Row(
        children: [
          // Botón de regreso
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.deepPurple,
              size: 32,
            ),
            onPressed: onBack ?? () => Navigator.of(context).pop(),
            tooltip: 'Volver',
          ),
          const Spacer(),
          
          // Contenedor del título
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icono != null) ...[
                  Icon(
                    icono,
                    color: colorIcono,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          
          // Botón de ayuda (opcional)
          if (mostrarAyuda)
            IconButton(
              icon: const Icon(
                Icons.lightbulb,
                color: Colors.amber,
                size: 32,
              ),
              tooltip: 'Pista',
              onPressed: onAyuda,
            )
          else
            const SizedBox(width: 48), // Espaciador para mantener centrado el título
        ],
      ),
    );
  }
}

/// Widget completo que combina fondo animado + encabezado + contenido
/// Plantilla completa para pantallas de juegos
class PlantillaJuegoChemaKids extends StatelessWidget {
  /// Título que aparece en el encabezado
  final String titulo;
  
  /// Icono del juego (opcional)
  final IconData? icono;
  
  /// Color de fondo (por defecto gris claro)
  final Color backgroundColor;
  
  /// Contenido principal del juego
  final Widget contenido;
  
  /// Función callback para el botón de ayuda (opcional)
  final VoidCallback? onAyuda;
  
  /// Si mostrar o no el botón de ayuda
  final bool mostrarAyuda;
  
  /// Número de burbujas en el fondo
  final int numeroBurbujas;

  const PlantillaJuegoChemaKids({
    super.key,
    required this.titulo,
    required this.contenido,
    this.icono,
    this.backgroundColor = const Color(0xFFF6F6F6),
    this.onAyuda,
    this.mostrarAyuda = true,
    this.numeroBurbujas = 10,
  });

  @override
  Widget build(BuildContext context) {
    return FondoAnimadoChemaKids(
      backgroundColor: backgroundColor,
      numeroBurbujas: numeroBurbujas,
      child: SafeArea(
        child: Column(
          children: [
            // Encabezado estandarizado
            EncabezadoJuegoChemaKids(
              titulo: titulo,
              icono: icono,
              onAyuda: onAyuda,
              mostrarAyuda: mostrarAyuda,
            ),
            
            // Contenido principal expandido
            Expanded(
              child: contenido,
            ),
          ],
        ),
      ),
    );
  }
}

/// Utilidades de estilo para mantener consistencia visual
class EstilosChemaKids {
  // Colores principales
  static const Color colorPrimario = Colors.deepPurple;
  static const Color colorSecundario = Colors.amber;
  static const Color colorFondo = Color(0xFFF6F6F6);
  static const Color colorTexto = Colors.deepPurple;
  
  // Contenedor estándar para elementos de juego
  static BoxDecoration contenedorJuego({
    Color? color,
    Color? borderColor,
    double borderWidth = 2,
    double borderRadius = 16,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? Colors.grey[400]!,
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 6,
          offset: const Offset(2, 2),
        ),
      ],
    );
  }
  
  // Estilo de texto para botones
  static const TextStyle textoBoton = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  // Estilo de texto para títulos
  static const TextStyle textoTitulo = TextStyle(
    fontSize: 32,
    color: colorPrimario,
    fontWeight: FontWeight.bold,
  );
  
  // Estilo de texto para elementos de juego
  static const TextStyle textoJuego = TextStyle(
    fontSize: 38,
    color: colorPrimario,
    fontWeight: FontWeight.bold,
  );
}