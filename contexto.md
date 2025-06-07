# ChemaKids - Contexto del Proyecto

**Fecha de última actualización:** 7 de junio de 2025  
**Ubicación:** `/Users/mario/Development/Flutter/ChemaKids/`

## 📋 Descripción General

ChemaKids es una aplicación educativa desarrollada en Flutter para niños, que incluye múltiples juegos interactivos diseñados para enseñar conceptos básicos como letras, números, colores, formas, animales y más. La aplicación está estructurada con un sistema de navegación por menús, puntuación, animaciones y efectos visuales atractivos para mantener el interés de los niños.

## 🏗️ Arquitectura del Proyecto

### Estructura de Carpetas
```
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
- Aprendizaje de sílabas
- Separación de palabras
- Ejercicios interactivos

### 4. **Rimas** (`juego_rimas.dart`)
- Identificación de palabras que riman
- Desarrollo de habilidades fonéticas
- Ejercicios de asociación

### 5. **Colores** (`juego_colores.dart`)
- Identificación de colores básicos
- Preguntas con 4 colores: Rojo, Verde, Azul, Amarillo
- Selección táctil con círculos de colores
- Sistema de retroalimentación inmediata

### 6. **Formas** (`juego_formas.dart`)
- Reconocimiento de formas geométricas
- Ejercicios de identificación
- Desarrollo de habilidades espaciales

### 7. **Animales** (`juego_animales.dart`)
- Identificación de animales
- Sonidos y características
- Conocimiento del mundo animal

### 8. **Sílabas desde Cero** (`juego_silabasdesdecero.dart`)
- Introducción básica a las sílabas
- Nivel principiante
- Construcción gradual de conocimiento

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

## 🎨 Componentes de UI

### Widgets Reutilizables
- **`boton_animado.dart`**: Botones con animaciones
- **`contador_puntos_racha.dart`**: Sistema de puntuación y rachas
- **`dialogo_racha_perdida.dart`**: Modal para racha perdida
- **`dialogo_victoria.dart`**: Modal de celebración de victoria
- **`libro_animado.dart`**: Componente de libro interactivo
- **`nivel_card.dart`**: Tarjeta de nivel de juego
- **`personaje_animado.dart`**: Personajes con animaciones
- **`tarjeta_nivel.dart`**: Tarjetas de selección de nivel
- **`titulo_pagina.dart`**: Títulos consistentes

### Pantallas Principales
- **`inicio.dart`**: Pantalla de bienvenida
- **`menu.dart`**: Menú principal de navegación

## 📊 Modelos de Datos

### `usuario.dart`
- Gestión de datos del usuario
- Progreso y puntuaciones
- Preferencias personales

### `letra.dart`
- Modelo para letras del alfabeto
- Propiedades y métodos relacionados

### `numero_letra.dart`
- Relación entre números y letras
- Conversiones y validaciones

### `question.dart`
- Estructura base para preguntas
- Tipos de respuestas y validaciones

### `question_que_es.dart`
- Preguntas específicas del juego "¿Qué es esto?"
- Opciones múltiples y validaciones

## ⚙️ Servicios

### `estado_app.dart`
- Gestión de estado global con Provider
- Persistencia de datos
- Configuraciones de la aplicación

## 🎯 Características Destacadas

### Sistema de Puntuación
- Puntos por respuestas correctas
- Sistema de rachas
- Almacenamiento local de progreso

### Animaciones
- Integración con Rive para animaciones vectoriales
- Animaciones Lottie para efectos especiales
- Transiciones suaves entre pantallas

### Accesibilidad
- Síntesis de voz con flutter_tts
- Interfaz intuitiva para niños
- Retroalimentación visual y auditiva

### Diseño Responsive
- Soporte multiplataforma (Android, iOS, Web, Desktop)
- Adaptación a diferentes tamaños de pantalla
- UI optimizada para interacción táctil

## 🔄 Estado Actual del Desarrollo

### ✅ Completado
- [x] Estructura base del proyecto
- [x] 12 juegos educativos implementados
- [x] Sistema de navegación completo
- [x] Gestión de estado con Provider
- [x] Componentes UI reutilizables
- [x] Sistema de puntuación y rachas
- [x] Animaciones e interacciones
- [x] Soporte multiplataforma

### 🚀 Funcionalidades Principales
- **Educación Integral**: Cubre letras, números, colores, formas, animales
- **Interactividad**: Juegos táctiles y visuales
- **Progreso**: Sistema de seguimiento y motivación
- **Multimedia**: Audio, animaciones y efectos visuales
- **Accesibilidad**: TTS y diseño intuitivo

## 📝 Notas Técnicas

### Configuración de Desarrollo
- **SDK Flutter**: Configurado para desarrollo multiplataforma
- **IDE**: Compatible con VS Code/Android Studio
- **Hot Reload**: Desarrollo ágil habilitado
- **Debugging**: Herramientas de depuración disponibles

### Performance
- **Widgets StatefulWidget**: Para manejo de estado local
- **Provider**: Para estado global eficiente
- **Lazy Loading**: Carga optimizada de recursos
- **Memory Management**: Gestión eficiente de memoria

## 🎨 Ejemplo de Implementación: Juego de Colores

El juego de colores (`juego_colores.dart`) es un ejemplo representativo de la arquitectura:

```dart
class JuegoColores extends StatefulWidget {
  // Implementación con:
  // - Lista de preguntas predefinidas
  // - Sistema de validación de respuestas
  // - Retroalimentación visual inmediata
  // - Navegación automática entre preguntas
  // - UI intuitiva con círculos de colores
}
```

**Características del Juego de Colores:**
- 4 colores básicos: Rojo, Verde, Azul, Amarillo
- Interfaz visual con círculos de colores
- Validación instantánea de respuestas
- Progresión automática entre preguntas
- Retroalimentación "¡Correcto!" / "Intenta de nuevo"

---

## 🔄 Historial de Cambios

### 7 de junio de 2025
- **✅ Eliminación de Google Fonts**: Se removió completamente la dependencia `google_fonts` del proyecto
  - Eliminada del `pubspec.yaml`
  - Reemplazadas todas las referencias `GoogleFonts.fredoka()` por `TextStyle()` nativo
  - Archivos modificados:
    - `lib/widgets/dialogo_victoria.dart`
    - `lib/widgets/contador_puntos_racha.dart`
    - `lib/widgets/dialogo_racha_perdida.dart`
    - `lib/pantallas/juego_silabas.dart`
    - `lib/pantallas/juego_abc.dart`
    - `lib/pantallas/juego_que_es.dart`
    - `lib/pantallas/juego_rimas.dart`
    - `lib/pantallas/juego_numeros.dart`
  - **Beneficios**: Reducción del tamaño de la aplicación y eliminación de dependencias externas
  - **Impacto**: Las fuentes ahora utilizan el TextStyle nativo de Flutter

---

*Este documento se actualiza automáticamente con cada cambio significativo en el proyecto.*
