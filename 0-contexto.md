# ChemaKids - Contexto del Proyecto

**Fecha de última actualización:** 8 de enero de 2025  
**Ubicación:** `/Users/mario/Development/Flutter/ChemaKids/`  
**Rama actual:** mario  
**Estado:** ✅ Sistema completo con autenticación Supabase, gestión de usuarios/invitados y persistencia de sesiones

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

### Estructura de Carpetas

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
│   ├── screens/                     # Pantallas nuevas (versiones actualizadas)
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

### Framework y Core
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

## 🎮 Sistema de Juegos Educativos

### Catálogo Completo (12 Juegos)

1. **Juego ABC** - Enseñanza interactiva del alfabeto
2. **¿Qué es esto?** - Identificación de objetos cotidianos
3. **Sílabas** - Separación silábica de palabras
4. **Rimas** - Reconocimiento de patrones sonoros
5. **Colores** - Identificación de colores básicos
6. **Formas** - Identificación de formas geométricas
7. **Animales** - Sonidos y características de animales
8. **Sílabas desde Cero** - Nivel principiante para pre-lectores
9. **Números** - Aprendizaje de números del 1 al 10
10. **Formar Palabras** - Construcción interactiva de palabras
11. **Memorama** - Juego de memoria visual
12. **Sumas y Restas** - Operaciones matemáticas básicas

## 🏗️ Arquitectura de Servicios

### Core Services

#### EstadoApp (`estado_app.dart`)
**Gestión del estado global de la aplicación**
- Soporte para usuarios autenticados e invitados
- Persistencia automática de sesiones con SharedPreferences
- Restauración de sesión al iniciar la aplicación
- Gestión unificada de progreso y datos de usuario
- Métodos de debug para desarrollo

#### AuthService (`auth_service.dart`)
**Manejo completo de autenticación**
- Registro con verificación de email
- Login sin verificación para testing
- Integración con deep links para confirmación
- Gestión de sesiones persistentes
- Creación automática de perfiles en BD

#### DatabaseManager (`database_manager.dart`)
**Gestor centralizado de todos los servicios de BD**
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

## 📊 Modelos de Datos

### Modelos Principales (Supabase)

#### UsuarioModel
```dart
class UsuarioModel {
  final int id;
  final String nombre;
  final String email;
  final int edad;
  final int idProgreso;
  final String? authUser;
}
```

#### InvitadoModel
```dart
class InvitadoModel {
  final int id;
  final String nombre;
  final int edad;
  final int idProgreso;
}
```

#### JuegoModel
```dart
class JuegoModel {
  final int id;
  final String nombre;
  final String descripcion;
}
```

#### ProgresoModel
```dart
class ProgresoModel {
  final int id;
  final int nivel;
  final int puntaje;
  final int racha;
  final DateTime fechaUltimaActividad;
}
```

### Modelos Legacy (Mantenidos para compatibilidad)
- `usuario.dart` - Modelo simple original
- `numero_letra.dart` - Datos para juegos de números y letras
- `question_que_es.dart` - Estructura de preguntas
- `question.dart` - Modelo base para preguntas
- `letra.dart` - Modelo para el juego de letras

## 🧩 Widgets Reutilizables

### UI Components
- **`boton_animado.dart`** - Botones con efectos de animación
- **`contador_puntos_racha.dart`** - Sistema de puntuación y rachas
- **`dialogo_racha_perdida.dart`** - Modal para racha perdida
- **`dialogo_victoria.dart`** - Modal de victoria y celebración
- **`libro_animado.dart`** - Animación del libro en pantalla de inicio
- **`nivel_card.dart`** - Tarjetas de navegación por niveles
- **`personaje_animado.dart`** - Personajes con animaciones Rive
- **`titulo_pagina.dart`** - Títulos estilizados para páginas

### Testing Components
- **`demo_base_datos.dart`** - Widget para testing de BD
- **`test_connectivity.dart`** - Testing de conectividad

## 🎯 Pantallas Principales

### Pantallas Core
- **`inicio.dart`** - Pantalla de bienvenida con animaciones
- **`menu.dart`** - Menú principal de navegación
- **`auth.dart`** - Pantalla de autenticación completa
- **`nombre_edad.dart`** - Registro/login de usuarios
- **`registro_invitado.dart`** - Registro de invitados

### Pantallas de Juegos
12 pantallas individuales para cada juego educativo

## 🗄️ Base de Datos Supabase

### Esquemas Implementados

#### Tabla `usuario`
- Información de usuarios registrados
- Integración con auth.users de Supabase
- Campos: id, nombre, email, edad, id_progreso, auth_user

#### Tabla `invitado`  
- Información de usuarios invitados
- Soporte para modo offline
- Campos: id, nombre, edad, id_progreso

#### Tabla `juegos`
- Catálogo de juegos disponibles
- Campos: id, nombre, descripcion

#### Tabla `progreso`
- Seguimiento del progreso por usuario y juego
- Campos: id, nivel, puntaje, racha, fecha_ultima_actividad

### Relaciones
- Foreign Keys establecidas entre tablas
- Integración con sistema de autenticación de Supabase

## 🎨 Características Técnicas

### Funcionalidades Especiales
- Sistema de puntuación en tiempo real
- Validación instantánea de respuestas
- Efectos de sonido y retroalimentación
- Manejo de rachas y logros
- Progreso persistente entre sesiones

### Optimizaciones
- **Provider** para estado global eficiente
- **Lazy Loading** para carga optimizada de recursos
- **Responsive Design** para adaptación automática

### Arquitectura
- **Multiplataforma**: iOS, Android, Web, Windows, Linux, macOS
- **Patrón Singleton**: Para servicios de base de datos
- **Patrón Repository**: Servicios especializados por entidad
- **Factory Pattern**: Creación de modelos desde JSON

## ✅ Estado Actual del Proyecto

### Implementado
- [x] 12 juegos educativos completos
- [x] Sistema de autenticación con Supabase
- [x] Gestión de usuarios e invitados
- [x] Persistencia de sesiones
- [x] Base de datos completa
- [x] Deep linking para verificación de email
- [x] Widgets reutilizables funcionales
- [x] Gestión de estado con Provider
- [x] Animaciones interactivas (Rive/Lottie)
- [x] Soporte multiplataforma

### Características Destacadas
- **Logging Completo**: Todas las operaciones incluyen confirmaciones con emojis
- **Manejo de Errores**: Sistema robusto de manejo y reporte de errores
- **Operaciones Asíncronas**: Todas las operaciones son no-bloqueantes
- **Búsquedas Avanzadas**: Filtros múltiples y búsquedas complejas
- **Modo Offline**: Funcionamiento sin conexión para invitados

## 🛠️ Herramientas de Desarrollo

### Entorno
- **Flutter SDK**: Versión 3.7.2+
- **Dart**: Lenguaje de programación
- **IDE**: Compatible con VS Code/Android Studio
- **Hot Reload**: Desarrollo ágil habilitado

### Testing y Debug
- **`EjemploUsoBD`** - Ejemplos completos de uso de la base de datos
- **`DemoBaseDatos`** - Widget de interfaz para probar la BD
- Múltiples archivos de documentación y guías
- Scripts de verificación de base de datos

## 📅 Historial de Cambios Recientes

### Implementación Sistema Completo (Enero 2025)
- **Autenticación Supabase**: Sistema completo con registro, login y verificación
- **Gestión de Estados**: EstadoApp mejorado con persistencia de sesiones
- **Modo Invitado**: Soporte completo para usuarios temporales
- **Deep Linking**: Verificación de email mediante enlaces
- **Base de Datos**: Esquema completo con todos los servicios CRUD

### Cambios Anteriores
- Eliminación de Google Fonts (reemplazado por TextStyle nativo)
- Corrección de ruta de sumas y restas
- Sincronización con rama mario
- Archivo de contexto renombrado a `0-contexto.md`

## 📚 Documentación Adicional

### Archivos de Guía
- `README_BASE_DATOS.md` - Guía completa de configuración de BD
- `GUIA_DEEP_LINKING.md` - Configuración de deep links
- `APLICAR_ESQUEMA_BD.md` - Instrucciones para aplicar esquemas
- `GUIA_PRUEBAS_COMPLETAS.md` - Testing completo del sistema

### Scripts Utilitarios
- `verify_database.sh` - Verificación del estado de la BD
- `test_deep_linking.sh` - Pruebas de deep linking
- Múltiples archivos SQL para esquemas y verificaciones

---

**Nota**: Este archivo se mantiene actualizado con cada cambio significativo en el proyecto para preservar el contexto completo del desarrollo.
