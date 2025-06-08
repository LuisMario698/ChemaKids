# Guía de Pruebas: Sistema de Usuarios y Progreso

## 🎯 Objetivo
Verificar que el sistema completo funcione correctamente desde el registro hasta el guardado de progreso.

## 📋 Lista de Verificación

### ✅ Paso 1: Aplicar Esquema de Base de Datos
**Antes de comenzar, DEBES aplicar el esquema:**

1. Ve a https://supabase.com/dashboard
2. Selecciona tu proyecto ChemaKids (ID: iohasepuybqedahdgtxv)
3. Ve a "SQL Editor"
4. Ejecuta el contenido de `database_schema.sql`
5. Ejecuta `verificar_estado_bd.sql` para confirmar que las tablas existen

### ✅ Paso 2: Compilar y Ejecutar la Aplicación

```bash
cd /Users/mario/Development/Flutter/ChemaKids
flutter clean
flutter pub get
flutter run -d macos
```

### ✅ Paso 3: Probar Registro de Usuario

1. **Abrir pantalla de autenticación**
   - Desde la pantalla de inicio, toca el botón "Autenticación"
   - Cambia a modo "Registrarse"

2. **Llenar formulario de registro**
   - Nombre: "Test ChemaKids"
   - Edad: 8
   - Email: `test-chemakids-$(date +%s)@example.com` (único)
   - Contraseña: "123456"

3. **Verificar registro exitoso**
   - ✅ Debe mostrar: "Usuario creado en Auth y BD"
   - ✅ Debe mostrar: "ID: [número] - Nivel: 1"
   - ✅ Debe mostrar: "Listo para jugar y guardar progreso!"

### ✅ Paso 4: Verificar en Supabase Dashboard

1. **Verificar tabla `auth.users`**
   - Ve a "Authentication" > "Users"
   - ✅ Debe aparecer el nuevo usuario

2. **Verificar tabla `usuario`**
   - Ve a "Table Editor" > "usuario"
   - ✅ Debe aparecer el usuario con:
     - `id`: número auto-generado
     - `nombre`: "Test ChemaKids"
     - `email`: el email usado
     - `edad`: 8
     - `nivel`: 1
     - `auth_user`: UUID del usuario de auth

### ✅ Paso 5: Probar Login y Verificación de Perfil

1. **Iniciar sesión**
   - Cambia a modo "Iniciar Sesión"
   - Usa las mismas credenciales
   - ✅ Debe mostrar: "Perfil completo y listo para jugar"

2. **Verificar perfil**
   - Toca "Verificar Perfil"
   - ✅ Debe mostrar: "Perfil encontrado: Test ChemaKids (Nivel 1)"

### ✅ Paso 6: Probar Guardado de Progreso

Para probar que el progreso se guarde correctamente, necesitamos integrar el `ProgresoService` en uno de los juegos.

#### Ejemplo de integración en un juego:

```dart
// En cualquier pantalla de juego (ej: lib/screens/juego_abc.dart)
import '../services/progreso_service.dart';

// Al completar un nivel exitosamente:
Future<void> _completarNivel() async {
  final guardado = await ProgresoService.instance.guardarProgresoUsuarioActual(
    idJuego: 1, // ID del juego ABC
    nivel: nivelActual,
    puntaje: puntajeObtenido,
    rachaMaxima: mejorRacha,
  );
  
  if (guardado) {
    print('✅ Progreso guardado exitosamente');
  } else {
    print('❌ Error al guardar progreso');
  }
}
```

### ✅ Paso 7: Verificar Progreso en Base de Datos

1. **Después de jugar y completar niveles**
   - Ve a "Table Editor" > "progreso"
   - ✅ Debe aparecer registros con:
     - `id_usuario`: ID del usuario registrado
     - `id_juego`: 1 (para ABC)
     - `nivel`: nivel completado
     - `puntaje`: puntaje obtenido
     - `racha_maxima`: mejor racha

### ✅ Paso 8: Probar Estadísticas de Usuario

En la pantalla de autenticación, después de autenticarse:

```dart
// Ejemplo de uso en PantallaAuth
Future<void> _mostrarEstadisticas() async {
  final stats = await ProgresoService.instance.obtenerEstadisticasUsuarioActual();
  print('📊 Estadísticas del usuario: $stats');
}
```

## 🚨 Problemas Comunes y Soluciones

### Error: "relation does not exist"
**Causa:** El esquema de BD no se ha aplicado
**Solución:** Ejecutar `database_schema.sql` en Supabase

### Error: "column does not exist"
**Causa:** Modelos no coinciden con esquema de BD
**Solución:** Los modelos ya están corregidos ✅

### Error: "Usuario registrado en Auth pero no en BD"
**Causa:** Problemas de permisos o esquema
**Solución:** Usar "Reparar Perfil" en la pantalla de auth

### Error de SocketException
**Causa:** Permisos de red en macOS
**Solución:** Ya configurado con entitlements ✅

## 🎉 Resultado Esperado Final

**Flujo completo funcionando:**
1. ✅ Usuario se registra → Se crea en `auth.users` Y `usuario`
2. ✅ Usuario inicia sesión → Se verifica vinculación completa
3. ✅ Usuario juega → Se guarda progreso en tabla `progreso`
4. ✅ Progreso se vincula → `id_usuario` apunta a registro correcto
5. ✅ Estadísticas funcionan → Se pueden consultar datos completos

**Beneficios:**
- 🎮 Progreso persistente entre sesiones
- 📊 Estadísticas detalladas por usuario
- 🏆 Sistema de niveles y puntajes
- 👥 Soporte para múltiples usuarios
- 🔄 Sincronización con Supabase

## 📱 Pantallas de Verificación

1. **PantallaAuth** → Registro, login, verificación de perfil
2. **Juegos** → Guardado automático de progreso
3. **Dashboard Supabase** → Verificación visual de datos
4. **Logs de consola** → Debugging detallado

¡El sistema está diseñado para ser robusto y proporcionar retroalimentación detallada en cada paso!
