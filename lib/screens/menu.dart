import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../services/estado_app.dart';
import '../widgets/fondo_menu_abc.dart';
import '../widgets/estilo_infantil.dart';
import '../widgets/tarjeta_juego.dart';
import '../widgets/encabezado_nivel.dart';
import '../screens/configuracion_voz.dart';

class PantallaMenu extends StatefulWidget {
  const PantallaMenu({super.key});

  @override
  State<PantallaMenu> createState() => _PantallaMenuState();
}

class _PantallaMenuState extends State<PantallaMenu>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _indiceColor = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estadoApp = context.watch<EstadoApp>();
    final size = MediaQuery.of(context).size;
    final esEscritorio = size.width > 600;

    return FondoMenuABC(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // Header ocupa 25% de la altura
              Container(
                height: size.height * 0.4,
                child: Column(
                  children: [
                    Expanded(
                      child: _construirEncabezado(estadoApp, esEscritorio),
                    ),
                    _construirNavegacion(esEscritorio),
                  ],
                ),
              ),
              // Contenido ocupa 75% de la altura
              Expanded(flex: 3, child: _construirContenido(esEscritorio)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirEncabezado(EstadoApp estadoApp, bool esEscritorio) {
    if (!esEscritorio) {
      // Vista móvil optimizada
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 32),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.record_voice_over,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () => _mostrarConfiguracionAudio(false),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                // Avatar simple sin animaciones
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: EstiloInfantil.temasColores[_indiceColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: EstiloInfantil.temasColores[_indiceColor][0]
                            .withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text('🦸‍♂️', style: TextStyle(fontSize: 40)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                              colors: EstiloInfantil.temasColores[_indiceColor],
                            ).createShader(bounds),
                        child: Text(
                          '¡Hola ${estadoApp.nombreUsuario.isNotEmpty ? estadoApp.nombreUsuario : "Pequeño Explorador"}! 🌟',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        '¡Vamos a jugar y aprender!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Vista desktop optimizada
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botones de navegación
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 28),
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              ),
              IconButton(
                icon: const Icon(
                  Icons.record_voice_over,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => _mostrarConfiguracionAudio(true),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Avatar simple sin animaciones
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: EstiloInfantil.temasColores[_indiceColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: EstiloInfantil.temasColores[_indiceColor][0]
                      .withOpacity(0.3),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(child: Text('🦸‍♂️', style: TextStyle(fontSize: 24))),
          ),
          SizedBox(height: 8),
          Column(
            children: [
              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      colors: EstiloInfantil.temasColores[_indiceColor],
                    ).createShader(bounds),
                child: Text(
                  '¡Hola ${estadoApp.nombreUsuario.isNotEmpty ? estadoApp.nombreUsuario : "Pequeño Explorador"}! 🌟',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2),
              Text(
                '¡Vamos a jugar y aprender!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarConfiguracionAudio(bool esEscritorio) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A0944),
            title: Text(
              'Configuración de Voz',
              style: TextStyle(
                color: Colors.white,
                fontSize: esEscritorio ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: ListTile(
              leading: Icon(
                Icons.record_voice_over,
                color: Colors.white,
                size: esEscritorio ? 28 : 24,
              ),
              title: Text(
                'Configurar voz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: esEscritorio ? 18 : 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Ajustar velocidad y tipo de voz',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: esEscritorio ? 14 : 12,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: esEscritorio ? 28 : 24,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConfiguracionVoz()),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cerrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: esEscritorio ? 16 : 14,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  Widget _construirNavegacion(bool esEscritorio) {
    return Center(
      child: Container(
        width:
            esEscritorio
                ? MediaQuery.of(context).size.width * 0.6
                : double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: esEscritorio ? 0 : 16,
          vertical: esEscritorio ? 16 : 8,
        ),
        height: esEscritorio ? 60 : 50,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              clipBehavior: Clip.antiAlias,
              child: TabBar(
                controller: _tabController,
                dividerHeight: 0,
                padding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                ),
                labelStyle: TextStyle(
                  fontSize: esEscritorio ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  _construirTab('ABC', '📚', esEscritorio),
                  _construirTab('123', '🔢', esEscritorio),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirTab(String texto, String emoji, bool esEscritorio) {
    return Tab(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            texto,
            style: TextStyle(
              fontSize: esEscritorio ? 18 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 6),
          Text(emoji, style: TextStyle(fontSize: esEscritorio ? 18 : 16)),
        ],
      ),
    );
  }

  Widget _construirContenido(bool esEscritorio) {
    final indiceColor = 0;
    return TabBarView(
      controller: _tabController,
      children: [
        // Vista Lenguaje
        ListView(
          children: [
            EncabezadoNivel(
              nivel: "1",
              titulo: "Primeros Pasos (Nivel 1)",
              emoji: "🌟",
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: esEscritorio ? 3 : 2,
              childAspectRatio: esEscritorio ? 1.1 : 0.85,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                TarjetaJuego(
                  titulo: "ABC",
                  emoji: "📚",
                  imageUrl: "assets/images/abc.png",
                  onTap: () => Navigator.pushNamed(context, '/abc'),
                  indiceColor: indiceColor,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Identificar Letras",
                  emoji: "🔤",
                  imageUrl: "assets/images/identificarabc.png",
                  onTap: () => Navigator.pushNamed(context, '/abc-audio'),
                  indiceColor: indiceColor,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
            EncabezadoNivel(
              nivel: "2",
              titulo: "Explorando Silabas (Nivel 2)",
              emoji: "🚀",
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: esEscritorio ? 3 : 2,
              childAspectRatio: esEscritorio ? 1.1 : 0.85,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                TarjetaJuego(
                  titulo: "Silabas desde Cero",
                  emoji: "📝",
                  imageUrl: "assets/images/silabas.png",
                  onTap:
                      () => Navigator.pushNamed(context, '/silabasdesdecero'),
                  indiceColor: indiceColor,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Identifiar Silabas",
                  emoji: "🔊",
                  imageUrl: "assets/images/escuchar.png",
                  onTap: () => Navigator.pushNamed(context, '/silabas-audio'),
                  indiceColor: indiceColor + 1,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
            EncabezadoNivel(
              nivel: "3",
              titulo: "Palabras (Nivel 3)",
              emoji: "🎯",
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: esEscritorio ? 3 : 2,
              childAspectRatio: esEscritorio ? 1.1 : 0.85,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                TarjetaJuego(
                  titulo: "Sílabas Mágicas",
                  emoji: "✨",
                  imageUrl: "assets/images/silabas.png",
                  onTap: () => Navigator.pushNamed(context, '/silabas'),
                  indiceColor: indiceColor,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Formar Palabras",
                  emoji: "📖",
                  imageUrl: "assets/images/palabras.png",
                  onTap: () => Navigator.pushNamed(context, '/formar-palabras'),
                  indiceColor: indiceColor + 1,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
            EncabezadoNivel(nivel: "3", titulo: "Extra", emoji: "🎯"),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: esEscritorio ? 3 : 2,
              childAspectRatio: esEscritorio ? 1.1 : 0.85,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                TarjetaJuego(
                  titulo: "Memorama",
                  emoji: "🧠",
                  imageUrl: "assets/images/memorama.png",
                  onTap: () => Navigator.pushNamed(context, '/memorama'),
                  indiceColor: indiceColor + 1,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
          ],
        ),
        // Vista Matemáticas
        //
        ListView(
          children: [
            EncabezadoNivel(
              nivel: "1",
              titulo: "Números Básicos (Nivel 1)",
              emoji: "🔢",
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: esEscritorio ? 3 : 2,
              childAspectRatio: 0.85,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                TarjetaJuego(
                  titulo: "123",
                  emoji: "🔢",
                  imageUrl: "assets/images/Juego123.jpg",
                  onTap: () => Navigator.pushNamed(context, '/123'),
                  indiceColor: indiceColor,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Contar Animalitos",
                  emoji: "🐾",
                  imageUrl: "assets/images/juego_contar_animalitos.jpg",
                  onTap:
                      () => Navigator.pushNamed(context, '/contar-animalitos'),
                  indiceColor: indiceColor + 1,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Objetos y Números",
                  emoji: "🎯",
                  imageUrl: "assets/images/Juegoobjetosynumeros.jpg",
                  onTap: () => Navigator.pushNamed(context, '/objetos-numero'),
                  indiceColor: indiceColor + 2,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
            EncabezadoNivel(
              nivel: "2",
              titulo: "Aprender a sumar (Nivel 2)",
              emoji: "➕",
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: esEscritorio ? 3 : 2,
              childAspectRatio: 0.85,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                TarjetaJuego(
                  titulo: "Comparar Números",
                  emoji: "⚖️",
                  imageUrl: "assets/images/compararnumeros.jpg",
                  onTap:
                      () => Navigator.pushNamed(context, '/comparar-numeros'),
                  indiceColor: indiceColor + 1,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Aprende a Sumar",
                  emoji: "🧮",
                  imageUrl: "assets/images/aprendeasumar.jpg",
                  onTap:
                      () => Navigator.pushNamed(context, '/presentacion-sumas'),
                  indiceColor: indiceColor + 2,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Sumas Básicas",
                  emoji: "✨",
                  imageUrl: "assets/images/sumas basicas.png",
                  onTap: () => Navigator.pushNamed(context, '/sumas-basicas'),
                  indiceColor: indiceColor + 3,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
            EncabezadoNivel(
              nivel: "3",
              titulo: "Operaciones (Nivel 3)",
              emoji: "🧮",
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: esEscritorio ? 3 : 2,
              childAspectRatio: 0.85,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                TarjetaJuego(
                  titulo: "Sumas y Restas",
                  emoji: "➕",
                  imageUrl:
                      "assets/images/aprendeasumar.jpg", // Usando la misma imagen de sumar
                  onTap: () => Navigator.pushNamed(context, '/sumas-restas'),
                  indiceColor: indiceColor,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
