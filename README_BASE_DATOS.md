# 🗃️ Base de Datos Supabase - ChemaKids

## 📋 Resumen

ChemaKids utiliza **Supabase** como base de datos para almacenar información de usuarios, invitados, juegos y progreso. Este documento explica cómo configurar y usar la base de datos.

## 🏗️ Estructura de la Base de Datos

### Tablas Principales

1. **`usuario`** - Información de usuarios registrados
   - `id` (bigint, PK) - Identificador único
   - `nombre` (varchar) - Nombre del usuario
   - `email` (varchar, nullable) - Correo electrónico
   - `nivel` (bigint) - Nivel actual del usuario
   - `edad` (bigint) - Edad del usuario
   - `auth_user` (uuid, FK) - Referencia a auth.users

2. **`invitado`** - Perfiles de invitados temporales
   - `id` (bigint, PK) - Identificador único
   - `nombre` (varchar) - Nombre del invitado
   - `edad` (bigint) - Edad del invitado
   - `nivel` (bigint) - Nivel actual del invitado

3. **`juegos`** - Catálogo de juegos disponibles
   - `id` (bigint, PK) - Identificador único
   - `nombre` (varchar) - Nombre del juego
   - `descripcion` (varchar) - Descripción del juego

4. **`progreso`** - Registros de progreso en juegos
   - `id` (bigint, PK) - Identificador único
   - `id_juego` (bigint, FK) - Referencia al juego
   - `nivel` (bigint) - Nivel alcanzado
   - `puntaje` (bigint) - Puntaje obtenido
   - `racha_maxima` (bigint) - Mejor racha consecutiva
   - `id_usuario` (bigint, FK) - Referencia al usuario
   - `id_invitado` (bigint, FK) - Referencia al invitado

## 🚀 Configuración Inicial

### 1. Crear Proyecto Supabase

1. Ve a [https://supabase.com](https://supabase.com)
2. Crea una cuenta o inicia sesión
3. Crea un nuevo proyecto llamado "ChemaKids"
4. Espera a que el proyecto se configure

### 2. Configurar Base de Datos

1. Ve a **SQL Editor** en tu proyecto Supabase
2. Ejecuta el script `1-database_schemas.sql` que se encuentra en la raíz del proyecto
3. Verifica que las tablas se hayan creado correctamente

### 3. Obtener Credenciales

1. Ve a **Settings > API** en tu proyecto Supabase
2. Copia los siguientes valores:
   - **Project URL**
   - **anon public key**

### 4. Configurar la Aplicación

1. Abre el archivo `lib/config/supabase_config.dart`
2. Reemplaza las credenciales de ejemplo:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'TU_PROJECT_URL_AQUI';
  static const String supabaseAnonKey = 'TU_ANON_KEY_AQUI';
  // ...
}
```

## 📱 Uso en la Aplicación

### Inicialización

La base de datos se inicializa automáticamente en `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar base de datos
  final dbInitialized = await DatabaseManager.instance.inicializar();
  
  runApp(const ChemakidsApp());
}
```

### Servicios Disponibles

- **`DatabaseManager.instance.usuarios`** - Gestión de usuarios
- **`DatabaseManager.instance.invitados`** - Gestión de invitados
- **`DatabaseManager.instance.juegos`** - Gestión de juegos
- **`DatabaseManager.instance.progreso`** - Gestión de progreso

### Ejemplos de Uso

```dart
// Crear un usuario
final usuario = UsuarioModel(
  id: 0,
  nombre: 'María',
  email: 'maria@ejemplo.com',
  nivel: 1,
  edad: 8,
);

final usuarioCreado = await DatabaseManager.instance.usuarios.crear(usuario);

// Obtener progreso de un usuario
final progreso = await DatabaseManager.instance.progreso
    .obtenerProgresoUsuario(usuarioCreado.id);

// Buscar juegos
final juegos = await DatabaseManager.instance.juegos
    .buscarJuegosPorNombre('ABC');
```

## 🧪 Pruebas y Desarrollo

### Widget de Demostración

Incluye el widget `DemoBaseDatos` en cualquier pantalla para probar la funcionalidad:

```dart
// En cualquier pantalla
Column(
  children: [
    // ... otros widgets
    DemoBaseDatos(),
  ],
)
```

### Ejemplos de Uso

Ejecuta ejemplos completos de uso:

```dart
// Ejecutar todos los ejemplos
await EjemploUsoBD.ejecutarTodosLosEjemplos();

// O ejemplos individuales
await EjemploUsoBD.ejemploCrearPerfilUsuario();
await EjemploUsoBD.ejemploRegistrarProgreso();
```

## 📊 Logging y Monitoreo

Todas las operaciones de base de datos incluyen logging detallado con emojis para fácil identificación:

- 🚀 Inicialización
- ✅ Operaciones exitosas
- ❌ Errores
- 🔍 Búsquedas
- 📊 Estadísticas
- 🎮 Operaciones de juegos
- 👤 Operaciones de usuarios

## 🔧 Configuración Avanzada

### Variables de Entorno

Para producción, considera usar variables de entorno:

```dart
static String get supabaseUrl => 
  const String.fromEnvironment('SUPABASE_URL', 
    defaultValue: 'https://tu-proyecto.supabase.co');
```

### Configuración de Realtime

Para habilitar actualizaciones en tiempo real:

```dart
// En SupabaseConfig
static const bool enableRealtime = true;
```

### Modo Desarrollo

Para alternar entre desarrollo y producción:

```dart
// En SupabaseConfig
static const bool isDevelopment = false; // true para desarrollo
```

## 🚨 Solución de Problemas

### Error de Conexión

1. Verifica que las credenciales sean correctas
2. Asegúrate de tener conexión a internet
3. Verifica que el proyecto Supabase esté activo

### Errores de Esquema

1. Ejecuta nuevamente el script `1-database_schemas.sql`
2. Verifica que todas las tablas existan
3. Revisa los logs de Supabase en el dashboard

### Errores de Autenticación

1. Verifica la configuración RLS (Row Level Security)
2. Asegúrate de usar la anon key correcta
3. Revisa las políticas de seguridad en Supabase

## 📚 Recursos Adicionales

- [Documentación de Supabase](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Guía de Migración](https://supabase.com/docs/guides/getting-started/migrating-to-supabase)

---

🎮 **ChemaKids** - Aprendiendo con tecnología moderna
