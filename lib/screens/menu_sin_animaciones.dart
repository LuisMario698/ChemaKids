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
                height: size.height * 0.25,
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
                    Icons.volume_up,
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
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Botones de navegación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 32),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.volume_up,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () => _mostrarConfiguracionAudio(true),
                ),
              ],
            ),
            SizedBox(height: 12),
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
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text('🦸‍♂️', style: TextStyle(fontSize: 32)),
              ),
            ),
            SizedBox(height: 16),
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
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '¡Vamos a jugar y aprender!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
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
              'Configuración de Audio',
              style: TextStyle(
                color: Colors.white,
                fontSize: esEscritorio ? 20 : 18,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: esEscritorio ? 24 : 20,
                  ),
                  title: Text(
                    'Música de fondo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: esEscritorio ? 16 : 14,
                    ),
                  ),
                  trailing: Switch(value: true, onChanged: (value) {}),
                ),
                ListTile(
                  leading: Icon(
                    Icons.volume_up,
                    color: Colors.white,
                    size: esEscritorio ? 24 : 20,
                  ),
                  title: Text(
                    'Efectos de sonido',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: esEscritorio ? 16 : 14,
                    ),
                  ),
                  trailing: Switch(value: true, onChanged: (value) {}),
                ),
                ListTile(
                  leading: Icon(
                    Icons.record_voice_over,
                    color: Colors.white,
                    size: esEscritorio ? 24 : 20,
                  ),
                  title: Text(
                    'Configurar voz',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: esEscritorio ? 16 : 14,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfiguracionVoz(),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
              titulo: "Primeros Pasos (3 años)",
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
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3208/3208676.png",
                  onTap: () => Navigator.pushNamed(context, '/abc'),
                  indiceColor: indiceColor,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Colores",
                  emoji: "🎨",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3241/3241648.png",
                  onTap: () => Navigator.pushNamed(context, '/colores'),
                  indiceColor: indiceColor + 1,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Formas",
                  emoji: "⭐",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3208/3208704.png",
                  onTap: () => Navigator.pushNamed(context, '/formas'),
                  indiceColor: indiceColor + 2,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Animales",
                  emoji: "🦁",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3208/3208715.png",
                  onTap: () => Navigator.pushNamed(context, '/animales'),
                  indiceColor: indiceColor + 3,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
            EncabezadoNivel(
              nivel: "2",
              titulo: "Explorando Sonidos (4 años)",
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
                  titulo: "ABC Audio",
                  emoji: "🔊",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3208/3208693.png",
                  onTap: () => Navigator.pushNamed(context, '/abc-audio'),
                  indiceColor: indiceColor,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Sílabas Básicas",
                  emoji: "📝",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3176/3176351.png",
                  onTap:
                      () => Navigator.pushNamed(context, '/silabasdesdecero'),
                  indiceColor: indiceColor + 1,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Sílabas Audio",
                  emoji: "🎵",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3176/3176353.png",
                  onTap: () => Navigator.pushNamed(context, '/silabas-audio'),
                  indiceColor: indiceColor + 2,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Memorama",
                  emoji: "🎯",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3176/3176359.png",
                  onTap: () => Navigator.pushNamed(context, '/memorama'),
                  indiceColor: indiceColor + 3,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "¿Qué es?",
                  emoji: "🤔",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3176/3176363.png",
                  onTap: () => Navigator.pushNamed(context, '/que-es'),
                  indiceColor: indiceColor + 4,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
            EncabezadoNivel(
              nivel: "3",
              titulo: "Lectura y Palabras (5 años)",
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
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3176/3176366.png",
                  onTap: () => Navigator.pushNamed(context, '/silabas'),
                  indiceColor: indiceColor,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Formar Palabras",
                  emoji: "📖",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3176/3176368.png",
                  onTap: () => Navigator.pushNamed(context, '/formar-palabras'),
                  indiceColor: indiceColor + 1,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Rima Rima",
                  emoji: "🎭",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3176/3176370.png",
                  onTap: () => Navigator.pushNamed(context, '/rimas'),
                  indiceColor: indiceColor + 2,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
          ],
        ),
        // Vista Matemáticas
        ListView(
          children: [
            EncabezadoNivel(
              nivel: "1",
              titulo: "Números Básicos (3 años)",
              emoji: "🔢",
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
                  titulo: "123",
                  emoji: "🔢",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3176/3176372.png",
                  onTap: () => Navigator.pushNamed(context, '/123'),
                  indiceColor: indiceColor,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
            EncabezadoNivel(
              nivel: "2",
              titulo: "Números y Letras (4 años)",
              emoji: "📚",
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
                  titulo: "Números y Letras",
                  emoji: "🎲",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3176/3176374.png",
                  onTap: () => Navigator.pushNamed(context, '/numeros'),
                  indiceColor: indiceColor,
                  esEscritorio: esEscritorio,
                ),
                TarjetaJuego(
                  titulo: "Escuchando Números",
                  emoji: "🎧",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3176/3176376.png",
                  onTap:
                      () => Navigator.pushNamed(context, '/escuchando-numeros'),
                  indiceColor: indiceColor + 1,
                  esEscritorio: esEscritorio,
                ),
              ],
            ),
            EncabezadoNivel(
              nivel: "3",
              titulo: "Operaciones (5 años)",
              emoji: "🧮",
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
                  titulo: "Sumas y Restas",
                  emoji: "➕",
                  imageUrl:
                      "https://cdn-icons-png.flaticon.com/512/3176/3176378.png",
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
