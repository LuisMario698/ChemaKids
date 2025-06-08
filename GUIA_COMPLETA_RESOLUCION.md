# 📋 Guía Completa: Resolución de Problemas de Usuario

## 🎯 Problemas Identificados y Resueltos

### 1. ❌ Usuarios no se guardan en tabla `usuario`

**Problema**: Los usuarios se registran en Supabase Auth pero no se crean sus perfiles en la tabla `usuario`.

**Solución Implementada**:
- ✅ Creado esquema completo de base de datos (`database_schema.sql`)
- ✅ Mejorado logging en `AuthService._crearPerfilUsuario()`
- ✅ Agregado manejo de errores más robusto
- ✅ Implementado recuperación automática de perfil en login

### 2. ⚠️ Falta de diagnóstico y reparación

**Problema**: No había manera de diagnosticar si un usuario tenía perfil o reparar perfiles faltantes.

**Solución Implementada**:
- ✅ Agregado método `AuthService.repararPerfilUsuario()`
- ✅ Mejorado `AuthService.obtenerPerfilUsuario()` con mejor logging
- ✅ Agregada funcionalidad de verificación y reparación en pantalla Auth

## 🔧 Funcionalidades Agregadas

### AuthService Mejorado

```dart
// Nuevos métodos agregados:
Future<bool> repararPerfilUsuario()     // Repara perfil faltante
Future<UsuarioModel?> obtenerPerfilUsuario() // Con mejor logging
```

### Pantalla Auth Expandida

- **Verificar Perfil**: Consulta si existe perfil en BD
- **Reparar Perfil**: Crea perfil faltante usando datos de Auth  
- **Cerrar Sesión**: Logout completo
- **Estado Visual**: Muestra información del usuario autenticado

## 📚 Archivos Creados/Modificados

### Nuevos Archivos:
- `database_schema.sql` - Esquema completo de BD
- `verify_database.sh` - Script de verificación
- `RESOLUCION_USUARIOS.md` - Guía de resolución
- `GUIA_COMPLETA_RESOLUCION.md` - Este archivo

### Archivos Modificados:
- `lib/services/auth_service.dart` - Logging mejorado y nuevos métodos
- `lib/screens/auth.dart` - Funcionalidades de debugging

## 🚀 Pasos de Implementación

### Paso 1: Aplicar Esquema de Base de Datos

1. Abrir [Supabase Dashboard](https://supabase.com/dashboard)
2. Ir a **SQL Editor**
3. Copiar y ejecutar todo el contenido de `database_schema.sql`

### Paso 2: Verificar Estructura

Ejecutar en SQL Editor:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('usuario', 'invitado', 'juegos', 'progreso');
```

### Paso 3: Probar Registro de Usuario

1. Ejecutar la app: `flutter run -d macos`
2. Ir a pantalla de autenticación
3. Registrar un nuevo usuario
4. Verificar logs en consola Flutter

### Paso 4: Diagnosticar Perfiles Existentes

Para usuarios ya registrados en Auth pero sin perfil:

1. **Iniciar sesión** con usuario existente
2. Hacer clic en **"Verificar Perfil"**
3. Si no existe, hacer clic en **"Reparar Perfil"**

## 🧪 Testing y Verificación

### Logs Esperados (Registro Exitoso):

```
🔐 [AuthService] Registrando usuario: test@example.com
✅ [AuthService] Usuario registrado exitosamente en Auth
📋 [AuthService] ID del usuario: abc123...
👤 [AuthService] Creando perfil de usuario en BD
✅ [AuthService] Tabla usuario existe y es accesible
📝 [AuthService] Insertando datos: {auth_user: abc123..., email: test@example.com, ...}
✅ [AuthService] Perfil creado en BD exitosamente
```

### Verificación en Supabase:

```sql
-- Ver usuarios creados recientemente
SELECT id, auth_user, email, nombre, edad, nivel, created_at 
FROM public.usuario 
ORDER BY created_at DESC 
LIMIT 5;
```

## 🔍 Troubleshooting

### Si la tabla no existe:

```
❌ [AuthService] Error al acceder a la tabla: relation "usuario" does not exist
💡 [AuthService] La tabla usuario no existe en la base de datos
💡 [AuthService] Verifica que hayas ejecutado las migraciones de la base de datos
```

**Solución**: Ejecutar `database_schema.sql` completo.

### Si hay problemas de permisos:

```
❌ [AuthService] Error detallado al crear perfil: permission denied for table usuario
```

**Solución**: Verificar políticas RLS en el esquema.

### Si el UUID es inválido:

```
❌ [AuthService] Error detallado al crear perfil: invalid input syntax for type uuid
```

**Solución**: Verificar que `auth.users` tenga el usuario registrado.

## ✅ Estado Final Esperado

1. **Base de Datos**: Todas las tablas creadas con políticas RLS
2. **Registro**: Usuarios se crean tanto en Auth como en tabla `usuario`
3. **Login**: Verifica automáticamente existencia de perfil
4. **Reparación**: Función manual para crear perfiles faltantes
5. **Debugging**: Logs detallados para diagnóstico

## 🔄 Próximos Pasos

Una vez resuelto el problema de usuarios:

1. **Testing Deep Links**: Verificar funcionamiento de email verification
2. **UI/UX Improvements**: Mejorar mensajes de error y confirmación
3. **Sincronización**: Asegurar consistencia entre Auth y tabla usuario
4. **Migración**: Script para reparar usuarios existentes automáticamente

---

**Fecha**: 8 de junio de 2025  
**Estado**: Implementación completa - Pendiente de testing
