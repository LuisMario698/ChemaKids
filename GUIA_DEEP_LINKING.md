# Guía para Probar Deep Linking en ChemaKids macOS

## 🎯 Objetivo
Esta guía te ayudará a probar la funcionalidad de deep linking para resolver el problema de verificación de correo en macOS.

## 🔧 Configuración Realizada

### 1. Entitlements de macOS
- ✅ `com.apple.security.network.client` agregado para conexiones salientes
- ✅ `com.apple.security.network.server` mantenido para conexiones entrantes
- ✅ Configuración en `DebugProfile.entitlements` y `Release.entitlements`

### 2. URL Schemes
- ✅ Esquema registrado: `chemakids://`
- ✅ URL de redirección de auth: `chemakids://auth`
- ✅ Configurado en `macos/Runner/Info.plist`

### 3. Dependencias
- ✅ `app_links: ^6.3.2` agregado al `pubspec.yaml`
- ✅ `DeepLinkService` creado para manejar enlaces

### 4. Configuración de Supabase
- ✅ `emailRedirectTo` configurado en registro y reenvío de verificación
- ✅ URL personalizada: `chemakids://auth`

## 🧪 Cómo Probar

### Paso 1: Registrar un Usuario
1. Abre la aplicación ChemaKids
2. Haz clic en el botón "Autenticación" (verde) en la esquina superior derecha
3. Cambia a modo "Registrarse" si no está ya seleccionado
4. Llena el formulario:
   - **Nombre**: Tu nombre
   - **Edad**: Entre 3 y 12 años
   - **Email**: Un email válido al que tengas acceso
   - **Contraseña**: Al menos 6 caracteres
5. Haz clic en "Registrarse"

### Paso 2: Verificar el Email
1. Ve a tu bandeja de entrada de correo
2. Busca el email de verificación de Supabase
3. Haz clic en el enlace de verificación
4. El enlace debería abrir automáticamente la aplicación ChemaKids
5. Deberías ver una notificación de "✅ Email Verificado"

### Paso 3: Iniciar Sesión
1. Si el deep link funcionó, deberías estar automáticamente autenticado
2. Si no, regresa a la pantalla de autenticación
3. Cambia a modo "Iniciar Sesión"
4. Usa las mismas credenciales que registraste
5. Haz clic en "Iniciar Sesión"

## 🔍 Debugging

### Ver Logs en la Consola
Los servicios imprimen logs detallados:
- `🔗 [DeepLinkService]` - Eventos de deep linking
- `🔐 [AuthService]` - Eventos de autenticación
- `📧` - Eventos relacionados con email

### Probar Deep Link Manualmente
Puedes probar el deep link desde la terminal:
```bash
open "chemakids://auth#access_token=test&refresh_token=test"
```

### URLs de Ejemplo
- Navegación: `chemakids://menu`
- Autenticación: `chemakids://auth`
- Con parámetros: `chemakids://auth#access_token=xxx&refresh_token=yyy`

## ⚠️ Problemas Comunes

### 1. El enlace abre el navegador pero no la app
- Verificar que el esquema URL esté registrado correctamente
- Comprobar que la app esté instalada y registrada en el sistema
- Revisar los entitlements de red

### 2. Error "Operation not permitted"
- Verificar que `com.apple.security.network.client` esté en los entitlements
- Confirmar que la configuración de red de macOS permita la conexión
- Revisar la configuración del firewall

### 3. El deep link no maneja la autenticación
- Verificar que el `DeepLinkService` esté inicializado
- Comprobar que la URL contenga los parámetros correctos
- Revisar los logs de la consola

### 4. Email no llega
- Verificar las credenciales de Supabase
- Comprobar la configuración de SMTP en Supabase
- Revisar la bandeja de spam

## 📱 Estados de Autenticación

La aplicación maneja tres estados:
1. **No autenticado**: Muestra botones de registro/login
2. **Autenticado pero email no verificado**: Muestra opción de reenviar verificación
3. **Completamente autenticado**: Muestra información del usuario y opción de cerrar sesión

## 🛠 Configuración de Supabase Dashboard

Para configurar la URL de redirección en Supabase Dashboard:
1. Ve a tu proyecto en https://supabase.com/dashboard
2. Navega a Authentication > URL Configuration
3. Agrega `chemakids://auth` a las "Redirect URLs"
4. Guarda los cambios

## 📋 Checklist de Verificación

- [ ] La app se compila sin errores
- [ ] El botón "Autenticación" aparece en la pantalla principal
- [ ] La pantalla de autenticación se abre correctamente
- [ ] El registro envía email de verificación
- [ ] El enlace de verificación abre la aplicación
- [ ] Se muestra notificación de verificación exitosa
- [ ] El inicio de sesión funciona después de la verificación
- [ ] Los logs muestran eventos de deep linking

## 📞 Soporte

Si encuentras problemas:
1. Revisa los logs en la consola de Flutter
2. Verifica la configuración de red de macOS
3. Confirma que las credenciales de Supabase sean correctas
4. Comprueba que el email de verificación llegue a tu bandeja
