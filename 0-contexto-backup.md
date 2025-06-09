# ChemaKids - Contexto del Proyecto

**Fecha de última actualización:** Enero 2025  
**Ubicación:** `/Users/mario/Development/Flutter/ChemaKids/`  
**Rama actual:** mario  
**Estado:** ✅ Sistema completo con autenticación, gestión de usuarios e invitados, y persistencia de sesiones

## 📋 Descripción General

ChemaKids es una aplicación educativa desarrollada en Flutter para niños, que incluye múltiples juegos interactivos diseñados para enseñar conceptos básicos como letras, números, colores, formas, animales y más. La aplicación cuenta con un sistema completo de autenticación, gestión de usuarios e invitados, persistencia de sesiones y seguimiento de progreso.

### 🎯 Características Principales

- **Sistema de Autenticación Completo:** Registro/login con Supabase Auth y deep linking para verificación de email
- **Gestión de Usuarios e Invitados:** Soporte para usuarios registrados y modo invitado con persistencia local
- **Persistencia de Sesiones:** Los usuarios pueden continuar donde dejaron la aplicación
- **Base de Datos Robusta:** Integración completa con Supabase para almacenamiento de datos
- **12 Juegos Educativos:** Cada uno diseñado pedagógicamente para diferentes habilidades
- **Seguimiento de Progreso:** Sistema avanzado de progreso y estadísticas

## 🏗️ Arquitectura del Proyecto

### Estructura de Carpetas Actualizada

```text
ChemaKids/
├── lib/
│   ├── main.dart                    # Punto de entrada con routing dinámico
│   ├── config/
│   │   └── supabase_config.dart     # Configuración de Supabase
│   ├── models/                      # Modelos de datos
│   │   ├── usuario_model.dart       # Modelo para usuarios registrados
│   │   ├── invitado_model.dart      # Modelo para usuarios invitados
│   │   ├── juego_model.dart         # Modelo del catálogo de juegos
│   │   ├── progreso_model.dart      # Modelo de seguimiento de progreso
│   │   └── [otros modelos legacy]   # Modelos anteriores mantenidos
│   ├── services/                    # Servicios de la aplicación
│   │   ├── estado_app.dart          # Estado global con persistencia
│   │   ├── auth_service.dart        # Autenticación con Supabase
│   │   ├── database_manager.dart    # Gestor centralizado de BD
│   │   ├── usuario_service.dart     # CRUD de usuarios
│   │   ├── invitado_service.dart    # CRUD de invitados
│   │   ├── progreso_service.dart    # Seguimiento de progreso
│   │   ├── juego_service.dart       # Gestión de juegos
│   │   ├── supabase_service.dart    # Conexión base con Supabase
│   │   ├── deep_link_service.dart   # Manejo de deep links
│   │   └── ejemplo_uso_bd.dart      # Ejemplos y testing
│   ├── pantallas/                   # Pantallas principales (legacy)
│   │   ├── inicio.dart              # Pantalla de inicio
│   │   ├── menu.dart                # Menú principal (legacy)
│   │   ├── nombre_edad.dart         # Registro/login de usuarios
│   │   ├── registro_invitado.dart   # Registro de invitados
│   │   └── [12 juegos].dart         # Juegos educativos
│   ├── screens/                     # Pantallas nuevas (duplicación)
│   │   ├── inicio.dart              # Pantalla inicio actualizada
│   │   ├── menu.dart                # Menú principal actualizado
│   │   ├── auth.dart                # Pantalla de autenticación
│   │   └── [pantallas de juegos]    # Versiones actualizadas
│   └── widgets/                     # Componentes reutilizables
│       ├── demo_base_datos.dart     # Widget para testing de BD
│       ├── test_connectivity.dart   # Testing de conectividad
│       └── [widgets existentes]     # Componentes UI
├── assets/                          # Recursos multimedia
├── android/, ios/, web/, etc.       # Configuraciones de plataforma
├── 0-contexto.md                    # Este archivo de documentación
├── database_schema.sql              # Esquema completo de BD
├── README_BASE_DATOS.md             # Documentación de BD
├── [múltiples archivos .md]         # Guías y documentación
└── pubspec.yaml                     # Dependencias del proyecto
```

## 🔧 Dependencias Principales

### Framework y Librerías Core

- **flutter**: Framework principal de desarrollo
- **cupertino_icons**: Iconos para iOS

### Animaciones y UI

- **rive**: Animaciones vectoriales interactivas avanzadas
- **lottie**: Animaciones Lottie para efectos especiales

### Gestión de Estado y Datos

- **provider**: Gestión de estado reactivo global
- **shared_preferences**: Almacenamiento local persistente para sesiones
- **flutter_tts**: Síntesis de voz para retroalimentación auditiva

### Base de Datos y Autenticación

- **supabase_flutter**: Cliente oficial de Supabase para Flutter
- **uuid**: Generación de identificadores únicos
- **app_links**: Manejo de deep links para verificación de email

### Arquitectura Actual

El proyecto utiliza una arquitectura basada en servicios con los siguientes patrones:

- **Singleton Pattern**: Para servicios de base de datos y autenticación
- **Provider Pattern**: Para gestión de estado global (EstadoApp)
- **Repository Pattern**: Servicios especializados para cada entidad
- **Factory Pattern**: Para la creación de modelos desde JSON

## 🎮 Sistema de Juegos Educativos

### Catálogo Completo (12 Juegos)

1. **Juego ABC** (`juego_abc.dart`)
   - Enseñanza interactiva del alfabeto
   - Navegación secuencial por letras
   - Interacción táctil con retroalimentación

2. **¿Qué es esto?** (`juego_que_es.dart`)
   - Identificación de objetos cotidianos
   - Preguntas con opciones múltiples
   - Sistema de validación inmediata

3. **Sílabas** (`juego_silabas.dart`)
   - Separación silábica de palabras
   - Ejercicios progresivos de dificultad
   - Desarrollo de conciencia fonológica

4. **Rimas** (`juego_rimas.dart`)
   - Reconocimiento de patrones sonoros
   - Ejercicios de asociación auditiva
   - Desarrollo de habilidades pre-lectoras

5. **Colores** (`juego_colores.dart`)
   - Identificación de colores básicos (Rojo, Verde, Azul, Amarillo)
   - Selección táctil con círculos interactivos
   - Reconocimiento visual cromático

6. **Formas** (`juego_formas.dart`)
   - Identificación de formas geométricas básicas
   - Ejercicios de reconocimiento espacial
   - Desarrollo de habilidades visuales

7. **Animales** (`juego_animales.dart`)
   - Sonidos y características de animales
   - Conocimiento del mundo natural
   - Interacción audiovisual inmersiva

8. **Sílabas desde Cero** (`juego_silabasdesdecero.dart`)
   - Nivel principiante para pre-lectores
   - Construcción gradual del conocimiento
   - Metodología pedagógica estructurada

9. **Números** (`juego_numeros.dart`)
   - Aprendizaje de números del 1 al 10
   - Ejercicios de conteo y reconocimiento
   - Conceptos matemáticos fundamentales

10. **Formar Palabras** (`juego_formar_palabras.dart`)
    - Construcción interactiva de palabras
    - Ejercicios de deletreo guiado
    - Desarrollo de vocabulario activo

11. **Memorama** (`juego_memorama.dart`)
    - Juego de memoria visual
    - Emparejamiento de cartas temáticas
    - Desarrollo de memoria de trabajo

12. **Sumas y Restas** (`juego_sumas_y_restas.dart`)
    - Operaciones matemáticas básicas
    - Ejercicios con visualización emoji
    - Introducción al cálculo mental

## 🏗️ Arquitectura de Servicios

### Core Services

#### EstadoApp (`estado_app.dart`)
- **Propósito**: Gestión del estado global de la aplicación
- **Características**:
  - Soporte para usuarios autenticados e invitados
  - Persistencia automática de sesiones con SharedPreferences
  - Restauración de sesión al iniciar la aplicación
  - Gestión unificada de progreso y datos de usuario
  - Métodos de debug para desarrollo

#### AuthService (`auth_service.dart`)
- **Propósito**: Manejo completo de autenticación
- **Funcionalidades**:
  - Registro con verificación de email
  - Login sin verificación para testing
  - Integración con deep links para confirmación
  - Gestión de sesiones persistentes
  - Creación automática de perfiles en BD

#### DatabaseManager (`database_manager.dart`)
- **Propósito**: Gestor centralizado de todos los servicios de BD
- **Características**:
  - Patrón Singleton para optimización
  - Inicialización automática de servicios
  - Verificación de estado de conectividad
  - Acceso unificado a todos los servicios CRUD

### CRUD Services

#### UsuarioService (`usuario_service.dart`)
- Operaciones completas para usuarios registrados
- Búsquedas por email, nombre y edad
- Integración con sistema de autenticación

#### InvitadoService (`invitado_service.dart`)
- Gestión de usuarios temporales (modo invitado)
- Fallback para funcionamiento offline
- Persistencia local con identificadores únicos

#### ProgresoService (`progreso_service.dart`)
- Seguimiento detallado del progreso por juego
- Estadísticas de nivel, puntaje y rachas
- Análisis de rendimiento por usuario

#### JuegoService (`juego_service.dart`)
- Administración del catálogo de juegos
- Búsquedas y filtros de contenido
- Estadísticas de uso

### Utility Services

#### SupabaseService (`supabase_service.dart`)
- Conexión base con Supabase
- Configuración centralizada
- Logging detallado de operaciones

#### DeepLinkService (`deep_link_service.dart`)
- Manejo de deep links para verificación de email
- Navegación automática después de confirmación
- Soporte para múltiples esquemas de URL

## 🎨 Características Principales

- Sistema de rachas
- Almacenamiento local de progreso
- Animaciones Rive para personajes interactivos
- Animaciones Lottie para efectos especiales
- Transiciones suaves entre pantallas
- Interfaz intuitiva para niños
- Retroalimentación visual y auditiva
- Adaptación a diferentes tamaños de pantalla
- UI optimizada para interacción táctil

## ✅ Estado del Proyecto

- [x] 12 juegos educativos implementados
- [x] Sistema de navegación completo
- [x] Widgets reutilizables funcionales
- [x] Gestión de estado con Provider
- [x] Animaciones interactivas
- [x] Soporte multiplataforma
- [x] Google Fonts removidos completamente
- [x] Esquemas de base de datos implementados
- [x] Ruta de sumas y restas corregida

## 🔮 Características Técnicas

- **Multiplataforma**: iOS, Android, Web, Windows, Linux, macOS
- **Arquitectura**: Basada en widgets con estado reactivo
- **Navegación**: Sistema de rutas nombradas
- **Animaciones**: Rive y Lottie integradas
- **Interactividad**: Juegos táctiles y visuales
- **Progreso**: Sistema de seguimiento y motivación

## 🛠️ Herramientas de Desarrollo

- **Flutter SDK**: Versión 3.7.2+
- **Dart**: Lenguaje de programación
- **IDE**: Compatible con VS Code/Android Studio
- **Hot Reload**: Desarrollo ágil habilitado

## ⚡ Optimizaciones

- **Provider**: Para estado global eficiente
- **Lazy Loading**: Carga optimizada de recursos
- **Responsive Design**: Adaptación automática a dispositivos

## 🎯 Funcionalidades Especiales

- Sistema de puntuación en tiempo real
- Validación instantánea de respuestas
- Efectos de sonido y retroalimentación
- Manejo de rachas y logros
- Progreso persistente entre sesiones

## 📅 Historial de Cambios Recientes

### Cambio a Rama Mario (Enero 2025)
- Sincronizada la rama local con `origin/mario`
- Archivo de contexto renombrado de `contexto.md` a `0-contexto.md`
- Nuevo archivo `1-database_schemas.sql` agregado con esquemas de BD

### Eliminación de Google Fonts
#### Archivos modificados:
- `lib/widgets/dialogo_victoria.dart`
- `lib/widgets/contador_puntos_racha.dart`
- `lib/widgets/dialogo_racha_perdida.dart`
- `lib/pantallas/juego_silabas.dart`
- `lib/pantallas/juego_abc.dart`
- `lib/pantallas/juego_que_es.dart`
- `lib/pantallas/juego_rimas.dart`
- `lib/pantallas/juego_numeros.dart`

#### Cambios realizados:
- Eliminada del `pubspec.yaml`
- Reemplazadas todas las referencias `GoogleFonts.fredoka()` por `TextStyle()` nativo
- Ejecutado `flutter pub get` para actualizar dependencias

### Corrección de Ruta de Sumas y Restas (Enero 2025)
- Agregada la ruta faltante `/sumas-restas` en `main.dart`
- Conectado correctamente el juego `JuegoSumasYRestas`

## 🗄️ Base de Datos

### Esquemas implementados (`1-database_schemas.sql`):

- **Tabla `invitado`**: Información de usuarios invitados
- **Tabla `juegos`**: Catálogo de juegos disponibles  
- **Tabla `progreso`**: Seguimiento del progreso por usuario y juego
- **Tabla `usuario`**: Información de usuarios registrados con integración a auth.users

### Relaciones:
- Foreign Keys establecidas entre tablas
- Integración con sistema de autenticación de Supabase

## 🗃️ Base de Datos Supabase (Junio 2025)

### Implementación Completa

Se ha implementado un sistema completo de base de datos usando Supabase para ChemaKids:

#### 📊 Modelos de Datos Implementados

- **`UsuarioModel`** (`lib/modelos/usuario_model.dart`)
  - Gestión completa de usuarios con métodos JSON y copyWith
  - Integración con sistema de autenticación

- **`InvitadoModel`** (`lib/modelos/invitado_model.dart`)
  - Perfiles temporales para invitados
  - Funcionalidades completas de conversión

- **`JuegoModel`** (`lib/modelos/juego_model.dart`)
  - Catálogo de juegos disponibles
  - Métodos de serialización completos

- **`ProgresoModel`** (`lib/modelos/progreso_model.dart`)
  - Seguimiento detallado de progreso
  - Estadísticas de nivel, puntaje y rachas

#### 🔧 Servicios Implementados

- **`SupabaseService`** (`lib/servicios/supabase_service.dart`)
  - Servicio singleton de conexión principal
  - Manejo centralizado de errores
  - Logging detallado con emojis

- **`UsuarioService`** (`lib/servicios/usuario_service.dart`)
  - CRUD completo para usuarios
  - Búsquedas por edad, email y nombre
  - Operaciones de autenticación

- **`InvitadoService`** (`lib/servicios/invitado_service.dart`)
  - Gestión completa de invitados
  - Filtros por edad y nivel

- **`JuegoService`** (`lib/servicios/juego_service.dart`)
  - Administración del catálogo de juegos
  - Búsquedas y estadísticas

- **`ProgresoService`** (`lib/servicios/progreso_service.dart`)
  - Seguimiento detallado de progreso
  - Estadísticas por usuario y juego
  - Análisis de rendimiento

- **`DatabaseManager`** (`lib/servicios/database_manager.dart`)
  - Gestor centralizado de todos los servicios
  - Inicialización automática
  - Verificación de estado de servicios

#### ⚙️ Configuración

- **`SupabaseConfig`** (`lib/config/supabase_config.dart`)
  - Configuración centralizada de credenciales
  - Soporte para entornos de desarrollo y producción
  - Variables de configuración detalladas

#### 🧪 Herramientas de Desarrollo

- **`EjemploUsoBD`** (`lib/servicios/ejemplo_uso_bd.dart`)
  - Ejemplos completos de uso de la base de datos
  - Casos de uso reales implementados
  - Pruebas de funcionalidad

- **`DemoBaseDatos`** (`lib/widgets/demo_base_datos.dart`)
  - Widget de interfaz para probar la base de datos
  - Botones de prueba interactivos
  - Visualización de resultados en tiempo real

#### 📚 Documentación

- **`README_BASE_DATOS.md`** - Guía completa de configuración y uso
- Instrucciones detalladas de setup de Supabase
- Ejemplos de código y casos de uso
- Solución de problemas comunes

#### 🚀 Inicialización Automática

El sistema se inicializa automáticamente en `main.dart`:
- Conexión con Supabase al iniciar la app
- Verificación de servicios
- Logging detallado de estado
- Manejo graceful de errores

#### ✨ Características Destacadas

- **Logging Completo**: Todas las operaciones incluyen confirmaciones con emojis
- **Manejo de Errores**: Sistema robusto de manejo y reporte de errores
- **Singleton Pattern**: Instancias únicas para optimización de memoria
- **Operaciones Asíncronas**: Todas las operaciones son no-bloqueantes
- **Búsquedas Avanzadas**: Filtros múltiples y búsquedas complejas
- **Estadísticas Detalladas**: Análisis completo de progreso y rendimiento

---

**Nota**: Este archivo se mantiene actualizado con cada cambio significativo en el proyecto para preservar el contexto completo del desarrollo.
