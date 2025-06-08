# Guía para Aplicar el Esquema de Base de Datos

## Problema Identificado

La aplicación está mostrando errores que indican que el esquema de la base de datos no se ha aplicado correctamente:

```
PostgrestException(message: column usuario.created_at does not exist, code: 42703)
```

Esto significa que las tablas no existen o no tienen la estructura correcta.

## Solución: Aplicar el Esquema SQL

### Paso 1: Acceder al Dashboard de Supabase

1. Ve a https://supabase.com/dashboard
2. Inicia sesión en tu cuenta
3. Selecciona tu proyecto ChemaKids (con ID: iohasepuybqedahdgtxv)

### Paso 2: Abrir el Editor SQL

1. En el menú lateral izquierdo, busca la sección "Database"
2. Haz clic en "SQL Editor"
3. Se abrirá una nueva ventana con un editor de SQL

### Paso 3: Ejecutar el Esquema

1. Abre el archivo `database_schema.sql` que se encuentra en la raíz del proyecto
2. Copia TODO el contenido del archivo
3. Pégalo en el editor SQL de Supabase
4. Haz clic en el botón "Run" (ejecutar) en la esquina superior derecha

### Paso 4: Verificar la Creación

Después de ejecutar el script, deberías ver mensajes como:
- "CREATE TABLE"
- "CREATE INDEX" 
- "CREATE POLICY"
- Y al final: "Esquema de base de datos ChemaKids creado exitosamente"

### Paso 5: Verificar las Tablas

Ejecuta esta consulta para verificar que las tablas se crearon:

```sql
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('usuario', 'invitado', 'juegos', 'progreso');
```

Deberías ver 4 tablas listadas.

### Paso 6: Verificar la Estructura de la Tabla Usuario

```sql
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'usuario' 
ORDER BY ordinal_position;
```

Deberías ver columnas como: id, auth_user, email, nombre, edad, nivel, created_at, updated_at

### Paso 7: Verificar que hay Juegos de Ejemplo

```sql
SELECT COUNT(*) as total_juegos FROM public.juegos;
```

Debería mostrar 8 juegos.

## Problemas Comunes y Soluciones

### Error: "permission denied for schema public"
**Solución**: Asegúrate de tener permisos de administrador en el proyecto de Supabase.

### Error: "relation already exists"
**Solución**: Las tablas ya existen pero pueden tener estructura incorrecta. Puedes:
1. Eliminar las tablas existentes: `DROP TABLE IF EXISTS usuario, invitado, juegos, progreso CASCADE;`
2. Volver a ejecutar el esquema completo

### Error: "uuid-ossp extension not available"
**Solución**: El script incluye `CREATE EXTENSION IF NOT EXISTS "uuid-ossp";` que debería resolver esto automáticamente.

## Verificación Final

Una vez aplicado el esquema, reinicia la aplicación Flutter. Los logs deberían mostrar:
- ✅ UsuarioService: Funcionando
- ✅ InvitadoService: Funcionando  
- ✅ JuegoService: Funcionando (con 8 juegos)
- ✅ ProgresoService: Funcionando

## Próximos Pasos

Después de aplicar el esquema:
1. Prueba el registro de usuarios
2. Verifica que los perfiles se guarden correctamente
3. Prueba el sistema de deep linking para verificación de email

## Archivos Relacionados

- `database_schema.sql` - Esquema completo de la base de datos
- `verify_database.sh` - Script para verificar el estado de la BD
- `lib/services/auth_service.dart` - Servicio de autenticación mejorado
