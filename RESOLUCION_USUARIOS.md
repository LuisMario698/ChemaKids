# 🔧 Resolución: Usuarios no se guardan en la tabla usuario

## 📋 Problema Identificado

Los usuarios se registran exitosamente en Supabase Auth pero no se crean sus perfiles en la tabla `usuario` de la base de datos. Esto causa que:

1. ❌ `AuthService._crearPerfilUsuario()` falla silenciosamente
2. ❌ Los usuarios no tienen perfil en la aplicación
3. ❌ No se puede acceder a funcionalidades que requieren perfil

## 🔍 Diagnóstico Paso a Paso

### Paso 1: Verificar si las tablas existen

1. Ve a tu proyecto en [Supabase Dashboard](https://supabase.com/dashboard)
2. Navega a **Table Editor**
3. Verifica si existe la tabla `usuario`

### Paso 2: Ejecutar el esquema de base de datos

Si la tabla no existe o está incompleta:

1. Ve a **SQL Editor** en Supabase Dashboard
2. Copia todo el contenido del archivo `database_schema.sql`
3. Pégalo en el editor SQL
4. Ejecuta el script completo

### Paso 3: Verificar estructura de la tabla

Ejecuta esta consulta en el SQL Editor para verificar la estructura:

```sql
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'usuario' 
ORDER BY ordinal_position;
```

### Paso 4: Verificar políticas RLS

Ejecuta esta consulta para ver las políticas de seguridad:

```sql
SELECT schemaname, tablename, policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'usuario';
```

## 🚀 Soluciones

### Solución 1: Aplicar el esquema completo

```sql
-- Ejecutar en SQL Editor de Supabase
-- (Contenido completo de database_schema.sql)
```

### Solución 2: Crear solo la tabla usuario (mínimo)

Si solo necesitas la tabla usuario:

```sql
CREATE TABLE IF NOT EXISTS public.usuario (
    id SERIAL PRIMARY KEY,
    auth_user UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    edad INTEGER NOT NULL CHECK (edad > 0 AND edad < 100),
    nivel INTEGER DEFAULT 1 CHECK (nivel > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(auth_user),
    UNIQUE(email)
);

-- Políticas de seguridad
ALTER TABLE public.usuario ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Los usuarios pueden insertar su propio perfil"
ON public.usuario FOR INSERT
WITH CHECK (auth.uid() = auth_user);

CREATE POLICY "Los usuarios pueden ver su propio perfil" 
ON public.usuario FOR SELECT 
USING (auth.uid() = auth_user);

CREATE POLICY "Los usuarios pueden actualizar su propio perfil" 
ON public.usuario FOR UPDATE 
USING (auth.uid() = auth_user);
```

### Solución 3: Probar inserción manual

Para verificar que la tabla funciona:

```sql
-- NOTA: Reemplaza 'tu-uuid-aqui' con un UUID real de un usuario registrado
INSERT INTO public.usuario (auth_user, email, nombre, edad, nivel) 
VALUES (
    'tu-uuid-aqui'::uuid, 
    'test@example.com', 
    'Usuario de Prueba', 
    8, 
    1
);
```

## 🧪 Pruebas de Funcionamiento

### Después de aplicar el esquema:

1. **Registra un nuevo usuario** desde la app
2. **Verifica los logs** en la consola de Flutter
3. **Consulta la tabla** en Supabase:

```sql
SELECT id, auth_user, email, nombre, edad, nivel, created_at 
FROM public.usuario 
ORDER BY created_at DESC;
```

### Logs esperados en Flutter:

```
✅ [AuthService] Usuario registrado exitosamente
👤 [AuthService] Creando perfil de usuario en BD
✅ [AuthService] Tabla usuario existe y es accesible
📝 [AuthService] Insertando datos: {...}
✅ [AuthService] Perfil creado en BD exitosamente
```

## 🐛 Debugging Adicional

Si el problema persiste, verifica:

1. **Permisos de API**: Usuario tiene permisos para insertar
2. **Políticas RLS**: Las políticas no bloquean la inserción
3. **Referencia FK**: El `auth_user` UUID es válido
4. **Conexión**: La app se conecta correctamente a Supabase

### Query para debug:

```sql
-- Ver usuarios en auth.users
SELECT id, email, email_confirmed_at, created_at 
FROM auth.users 
ORDER BY created_at DESC 
LIMIT 5;

-- Ver intentos de inserción (si hay logs de error)
SELECT * FROM public.usuario WHERE email = 'tu-email@ejemplo.com';
```

## ✅ Verificación Final

Una vez resuelto, deberías ver:

1. ✅ Tabla `usuario` existe y tiene la estructura correcta
2. ✅ Políticas RLS configuradas adecuadamente
3. ✅ Usuarios se registran en Auth Y en la tabla usuario
4. ✅ Los logs muestran inserción exitosa
5. ✅ Consultas SQL muestran los perfiles creados

---

**📞 Siguiente paso**: Ejecutar el esquema en Supabase y probar el registro de un nuevo usuario.
