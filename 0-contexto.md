# ChemaKids - Contexto del Proyecto

**Fecha de última actualización:** Junio 2025  
**Ubicación:** `/Users/mario/Development/Flutter/ChemaKids/`  
**Rama actual:** mario  
**Estado:** Base de datos Supabase implementada completamente, todos los servicios funcionales

## 📋 Descripción General

ChemaKids es una aplicación educativa desarrollada en Flutter para niños, que incluye múltiples juegos interactivos diseñados para enseñar conceptos básicos como letras, números, colores, formas, animales y más. La aplicación está estructurada con un sistema de navegación por menús, puntuación, animaciones y efectos visuales atractivos para mantener el interés de los niños.

**NUEVA FUNCIONALIDAD:** Sistema completo de base de datos Supabase para gestión de usuarios, progreso y estadísticas.

## 🏗️ Arquitectura del Proyecto

### Estructura de Carpetas

```text
ChemaKids/
├── lib/
│   ├── main.dart                 # Punto de entrada de la aplicación
│   ├── modelos/                  # Modelos de datos
│   ├── pantallas/                # Pantallas de los juegos
│   ├── servicios/                # Gestión de estado y servicios
│   └── widgets/                  # Componentes reutilizables
├── assets/                       # Recursos (audio, imágenes)
├── android/                      # Configuración Android
├── ios/                          # Configuración iOS
├── web/                          # Configuración Web
├── windows/                      # Configuración Windows
├── linux/                        # Configuración Linux
├── macos/                        # Configuración macOS
├── 0-contexto.md                 # Documentación del proyecto
├── 1-database_schemas.sql        # Esquemas de base de datos
└── pubspec.yaml                  # Dependencias y configuración
```

## 🔧 Dependencias Principales

### Framework y Librerías

- **flutter**: Framework principal
- **rive**: Animaciones vectoriales interactivas
- **lottie**: Animaciones Lottie
- **provider**: Gestión de estado
- **shared_preferences**: Almacenamiento local
- **flutter_tts**: Síntesis de voz

## 🎮 Juegos Implementados

### 1. **Juego ABC** (`juego_abc.dart`)

- Enseñanza del alfabeto
- Navegación por letras
- Interacción táctil

### 2. **¿Qué es esto?** (`juego_que_es.dart`)

- Juego de identificación de objetos
- Preguntas con opciones múltiples
- Sistema de validación de respuestas

### 3. **Sílabas** (`juego_silabas.dart`)

- Separación de palabras
- Ejercicios interactivos
- Desarrollo de habilidades fonéticas

### 4. **Rimas** (`juego_rimas.dart`)

- Desarrollo de habilidades fonéticas
- Ejercicios de asociación
- Reconocimiento de patrones sonoros

### 5. **Colores** (`juego_colores.dart`)

- Preguntas con 4 colores: Rojo, Verde, Azul, Amarillo
- Selección táctil con círculos de colores
- Reconocimiento visual

### 6. **Formas** (`juego_formas.dart`)

- Ejercicios de identificación
- Desarrollo de habilidades espaciales
- Reconocimiento geométrico

### 7. **Animales** (`juego_animales.dart`)

- Sonidos y características
- Conocimiento del mundo animal
- Interacción audiovisual

### 8. **Sílabas desde Cero** (`juego_silabasdesdecero.dart`)

- Nivel principiante
- Construcción gradual de conocimiento
- Metodología paso a paso

### 9. **Números** (`juego_numeros.dart`)

- Aprendizaje de números
- Conteo y reconocimiento
- Conceptos matemáticos básicos

### 10. **Formar Palabras** (`juego_formar_palabras.dart`)

- Construcción de palabras
- Ejercicios de deletreo
- Desarrollo de vocabulario

### 11. **Memorama** (`juego_memorama.dart`)

- Juego de memoria
- Emparejamiento de cartas
- Desarrollo de memoria visual

### 12. **Sumas y Restas** (`juego_sumas_y_restas.dart`)

- Operaciones matemáticas básicas
- Ejercicios de cálculo
- Introducción a las matemáticas
- Uso de emojis para visualización

## 🧩 Widgets Reutilizables

- **`boton_animado.dart`**: Botones con efectos de animación
- **`contador_puntos_racha.dart`**: Sistema de puntuación y rachas
- **`dialogo_racha_perdida.dart`**: Modal para racha perdida
- **`dialogo_victoria.dart`**: Modal de victoria y celebración
- **`libro_animado.dart`**: Animación del libro en pantalla de inicio
- **`nivel_card.dart`**: Tarjetas de navegación por niveles
- **`personaje_animado.dart`**: Personajes con animaciones Rive
- **`titulo_pagina.dart`**: Títulos estilizados para páginas

## 🎯 Pantallas Principales

- **`inicio.dart`**: Pantalla de bienvenida con animaciones
- **`menu.dart`**: Menú principal de navegación
- 12 pantallas de juegos individuales

## 📊 Gestión de Estado

- **`estado_app.dart`**: Estado global de la aplicación
- Progreso y puntuaciones
- Preferencias personales

## 📁 Modelos de Datos

- **`usuario.dart`**: Información del usuario
- Propiedades y métodos relacionados
- **`numero_letra.dart`**: Datos para números y letras
- Conversiones y validaciones
- **`question_que_es.dart`**: Preguntas del juego "¿Qué es?"
- Tipos de respuestas y validaciones
- **`question_rimas.dart`**: Preguntas del juego de rimas
- Opciones múltiples y validaciones

## 💾 Servicios

- **`shared_preferences`**: Persistencia de datos
- Configuraciones de la aplicación

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
