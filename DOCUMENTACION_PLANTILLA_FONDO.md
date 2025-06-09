# 🎨 Plantilla de Fondo Animado ChemaKids

## 📋 Descripción

Este archivo contiene una plantilla reutilizable para crear fondos animados con burbujas coloridas para todos los juegos de ChemaKids. La plantilla está basada en el diseño del juego "formar palabras" y proporciona una experiencia visual uniforme y atractiva.

## 🎯 Componentes Principales

### 1. `FondoAnimadoChemaKids`
**Widget principal que crea el fondo animado con burbujas coloridas**

#### Características:
- ✨ 10 burbujas animadas por defecto (configurable)
- 🎨 10 colores diferentes en la paleta
- ⏱️ Animación de 10 segundos con reversa automática
- 🔄 Movimiento circular suave con opacidad variable
- 📱 Responsive a diferentes tamaños de pantalla

#### Parámetros:
```dart
FondoAnimadoChemaKids({
  Color backgroundColor = const Color(0xFFF6F6F6), // Gris claro
  int numeroBurbujas = 10,                          // Cantidad de burbujas
  int duracionSegundos = 10,                        // Duración animación
  required Widget child,                            // Contenido sobre el fondo
})
```

### 2. `EncabezadoJuegoChemaKids`
**Widget estandarizado para el encabezado de todos los juegos**

#### Características:
- ⬅️ Botón de regreso automático
- 🏷️ Título centrado con fondo redondeado
- 🎯 Icono opcional junto al título
- 💡 Botón de ayuda/pista opcional
- 🎨 Colores consistentes (deepPurple/amber)

#### Parámetros:
```dart
EncabezadoJuegoChemaKids({
  required String titulo,          // Título del juego
  IconData? icono,                // Icono opcional
  Color colorIcono = Colors.amber, // Color del icono
  VoidCallback? onBack,           // Callback botón regreso
  VoidCallback? onAyuda,          // Callback botón ayuda
  bool mostrarAyuda = true,       // Mostrar botón ayuda
})
```

### 3. `PlantillaJuegoChemaKids`
**Widget completo que combina fondo + encabezado + contenido**

#### Características:
- 🔗 Combina automáticamente fondo animado y encabezado
- 📏 Maneja SafeArea automáticamente
- 📱 Layout responsivo con Expanded para el contenido
- ⚙️ Configuración simple con pocos parámetros

#### Parámetros:
```dart
PlantillaJuegoChemaKids({
  required String titulo,           // Título del juego
  required Widget contenido,        // Contenido principal del juego
  IconData? icono,                 // Icono opcional
  Color backgroundColor = const Color(0xFFF6F6F6),
  VoidCallback? onAyuda,           // Función de ayuda
  bool mostrarAyuda = true,        // Mostrar botón ayuda
  int numeroBurbujas = 10,         // Cantidad de burbujas
})
```

### 4. `EstilosChemaKids`
**Clase de utilidades con estilos consistentes**

#### Colores estándar:
```dart
static const Color colorPrimario = Colors.deepPurple;
static const Color colorSecundario = Colors.amber;
static const Color colorFondo = Color(0xFFF6F6F6);
static const Color colorTexto = Colors.deepPurple;
```

#### Estilos de texto:
```dart
static const TextStyle textoBoton;    // Para botones (20px, bold, white)
static const TextStyle textoTitulo;   // Para títulos (32px, bold, deepPurple)
static const TextStyle textoJuego;    // Para elementos de juego (38px, bold, deepPurple)
```

#### Decoración de contenedor:
```dart
static BoxDecoration contenedorJuego({
  Color? color,                    // Color de fondo (default: white)
  Color? borderColor,             // Color del borde (default: grey)
  double borderWidth = 2,         // Grosor del borde
  double borderRadius = 16,       // Radio de las esquinas
})
```

## 🚀 Cómo Usar la Plantilla

### Opción 1: Plantilla Completa (Recomendado)
```dart
import '../widgets/tema_juego_chemakids.dart';

class MiJuego extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return PlantillaJuegoChemaKids(
      titulo: 'Mi Juego Increíble',
      icono: Icons.games,
      onAyuda: _mostrarPista,
      contenido: _buildContenidoDelJuego(),
    );
  }
  
  Widget _buildContenidoDelJuego() {
    return Center(
      child: Container(
        decoration: EstilosChemaKids.contenedorJuego(),
        child: Text(
          'Contenido del juego aquí',
          style: EstilosChemaKids.textoJuego,
        ),
      ),
    );
  }
  
  void _mostrarPista() {
    // Lógica de pista aquí
  }
}
```

### Opción 2: Componentes Separados (Más Control)
```dart
@override
Widget build(BuildContext context) {
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
            child: _buildContenidoDelJuego(),
          ),
        ],
      ),
    ),
  );
}
```

## 🔄 Migración de Juegos Existentes

### ANTES (Juego tradicional):
```dart
class MiJuego extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Juego'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            // Contenido del juego
          ],
        ),
      ),
    );
  }
}
```

### DESPUÉS (Con plantilla ChemaKids):
```dart
import '../widgets/tema_juego_chemakids.dart';

class MiJuego extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return PlantillaJuegoChemaKids(
      titulo: 'Mi Juego',
      icono: Icons.games,
      onAyuda: _mostrarPista,
      contenido: Column(
        children: [
          // El mismo contenido del juego, pero usando EstilosChemaKids
        ],
      ),
    );
  }
}
```

## 🎨 Paleta de Colores de las Burbujas

La plantilla incluye 10 colores cuidadosamente seleccionados:

1. 🧡 **Naranja claro** - `Color(0xFFFFB74D)`
2. 🔵 **Azul claro** - `Color(0xFF64B5F6)`
3. 🟢 **Verde claro** - `Color(0xFF81C784)`
4. 🔴 **Rojo claro** - `Color(0xFFE57373)`
5. 🟣 **Púrpura claro** - `Color(0xFFBA68C8)`
6. 🟡 **Amarillo claro** - `Color(0xFFFFF176)`
7. 🟠 **Naranja coral** - `Color(0xFFFF8A65)`
8. 🔷 **Cian claro** - `Color(0xFF4DD0E1)`
9. 🟢 **Verde lima** - `Color(0xFFAED581)`
10. 🌟 **Amarillo dorado** - `Color(0xFFFFD54F)`

## ⚡ Ventajas de Usar la Plantilla

1. **🎨 Consistencia Visual**: Todos los juegos tienen el mismo look and feel
2. **⏰ Ahorro de Tiempo**: No necesitas crear animaciones de fondo desde cero
3. **🔧 Fácil Mantenimiento**: Cambios en la plantilla se reflejan en todos los juegos
4. **📱 Responsivo**: Se adapta automáticamente a diferentes pantallas
5. **♿ Accesibilidad**: Incluye tooltips y navegación estándar
6. **🚀 Performance**: Animaciones optimizadas con single ticker
7. **🧹 Código Limpio**: Separación clara entre presentación y lógica

## 🔧 Personalización Avanzada

### Cambiar cantidad de burbujas:
```dart
PlantillaJuegoChemaKids(
  numeroBurbujas: 15, // Más burbujas para pantallas grandes
  // ... otros parámetros
)
```

### Usar solo el fondo sin encabezado:
```dart
FondoAnimadoChemaKids(
  numeroBurbujas: 8,
  duracionSegundos: 15,
  child: // Tu contenido personalizado
)
```

### Personalizar colores del contenedor:
```dart
Container(
  decoration: EstilosChemaKids.contenedorJuego(
    color: Colors.blue[50],
    borderColor: Colors.blue,
    borderWidth: 3,
    borderRadius: 20,
  ),
)
```

## 📁 Estructura de Archivos

```
lib/
  widgets/
    tema_juego_chemakids.dart          # 🎨 Plantilla principal
    ejemplo_uso_plantilla.dart         # 📖 Ejemplo de uso
  screens/
    juego_formar_palabras_nuevo.dart   # ✨ Ejemplo migrado
```

## 🎯 Próximos Pasos

1. Aplicar la plantilla a todos los juegos restantes
2. Probar en diferentes dispositivos
3. Ajustar animaciones si es necesario
4. Documentar patrones específicos por tipo de juego
