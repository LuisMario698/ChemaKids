# Guía Final: Aplicar y Verificar Esquema de Base de Datos

## 🎯 Objetivo
Aplicar el esquema corregido de la base de datos en Supabase y verificar que todo funcione correctamente.

## 📋 Pasos a Seguir

### Paso 1: Verificar Estado Actual
1. Ve a https://supabase.com/dashboard
2. Selecciona tu proyecto ChemaKids (ID: iohasepuybqedahdgtxv)
3. Ve a "SQL Editor"
4. Ejecuta el script `verificar_estado_bd.sql` para ver el estado actual

### Paso 2: Aplicar Esquema (Si es Necesario)
Si las tablas no existen o tienen estructura incorrecta:

1. Abre el archivo `database_schema.sql`
2. Copia TODO el contenido
3. Pégalo en el SQL Editor de Supabase
4. Haz clic en "Run" (Ejecutar)

### Paso 3: Verificar Esquema Aplicado
Ejecuta nuevamente `verificar_estado_bd.sql` para confirmar:
- ✅ Tablas: usuario, invitado, juegos, progreso existen
- ✅ Tabla `usuario` tiene: id, nombre, email, nivel, edad, auth_user
- ✅ Tabla `invitado` tiene: id, nombre, edad, nivel
- ✅ Foreign keys están configuradas correctamente

### Paso 4: Probar Aplicación
1. Ejecuta la aplicación Flutter
2. Ve a la pantalla de autenticación
3. Registra un nuevo usuario
4. Verifica que no haya errores de "column does not exist"

### Paso 5: Verificar en Dashboard
1. Ve a "Table Editor" en Supabase
2. Revisa la tabla `usuario`
3. Confirma que el nuevo usuario aparece con todos los campos

## 🚨 Qué Buscar

### Errores Típicos a Resolver:
- `column "created_at" does not exist` → ✅ Ya resuelto en modelos
- `column "updated_at" does not exist` → ✅ Ya resuelto en modelos
- `relation "usuario" does not exist` → Aplicar esquema
- `relation "invitado" does not exist` → Aplicar esquema

### Señales de Éxito:
- ✅ Aplicación conecta sin SocketException
- ✅ Registro de usuario funciona
- ✅ Datos se guardan en tabla `usuario`
- ✅ Verificación de email inicia (deep link)
- ✅ Sin errores de PostgreSQL

## 🔧 Solución de Problemas

### Si las Tablas Ya Existen pero Tienen Estructura Incorrecta:
```sql
-- Primero respaldar datos existentes
-- Luego ejecutar DROP y recrear con esquema correcto
DROP TABLE IF EXISTS progreso CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS invitado CASCADE;
DROP TABLE IF EXISTS juegos CASCADE;

-- Luego ejecutar database_schema.sql completo
```

### Si Hay Conflictos de Foreign Keys:
Las foreign keys del esquema están diseñadas para referenciar:
- `auth.users(id)` - tabla de autenticación de Supabase
- Referencias cruzadas entre tablas custom

## 📱 Prueba Completa de Funcionalidad

1. **Conexión**: App conecta a Supabase sin errores
2. **Registro**: Usuario se registra exitosamente
3. **Base de Datos**: Profile se guarda en tabla `usuario`
4. **Email**: Se envía email de verificación
5. **Deep Link**: Click en email abre la app (chemakids://)
6. **Autenticación**: Usuario queda autenticado

## 🎉 Estado Final Esperado
- ✅ Esquema aplicado correctamente
- ✅ Modelos y servicios alineados con BD
- ✅ Conexión de red funcionando
- ✅ Deep linking configurado
- ✅ Registro de usuarios completo
- ✅ Sin errores de compilación o runtime
