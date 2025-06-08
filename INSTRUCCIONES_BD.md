# 🚀 Configuración de Base de Datos - ChemaKids

## ⚠️ PASOS CRÍTICOS PARA RESOLVER LOS PROBLEMAS DE AUTENTICACIÓN

### 🔥 Problema Actual
Los logs muestran que faltan las tablas `usuario`, `juegos` y otras en la base de datos de Supabase, causando errores de autenticación.

### 📋 Solución: Aplicar Esquema Completo

#### Paso 1: Acceder a Supabase Dashboard
1. Ve a [https://supabase.com](https://supabase.com)
2. Inicia sesión en tu cuenta
3. Selecciona tu proyecto ChemaKids
4. Ve a **SQL Editor** en el menú lateral

#### Paso 2: Aplicar el Esquema Completo
1. En el SQL Editor, crea una nueva query
2. Copia TODO el contenido del archivo `esquema_completo.sql`
3. Pégalo en el editor
4. Haz clic en **RUN** para ejecutar el script completo

#### Paso 3: Verificar la Instalación
1. Crea otra nueva query en el SQL Editor
2. Copia TODO el contenido del archivo `verificacion_completa.sql`
3. Ejecútalo para verificar que todo esté correcto

### ✅ Resultados Esperados

Después de ejecutar `esquema_completo.sql`, deberías tener:

**Tablas creadas:**
- ✅ `usuario` - Para usuarios registrados con email
- ✅ `invitado` - Para usuarios invitados sin cuenta
- ✅ `juegos` - Catálogo de juegos disponibles
- ✅ `progreso` - Progreso detallado en juegos
- ✅ `progreso_usuario` - Progreso general de usuarios
- ✅ `progreso_invitado` - Progreso general de invitados

**Configuración de seguridad:**
- ✅ Row Level Security (RLS) habilitado en todas las tablas
- ✅ Políticas de seguridad configuradas
- ✅ Foreign keys establecidas correctamente

**Datos iniciales:**
- ✅ 5 juegos de ejemplo insertados (ABC Básico, Números 123, etc.)

### 🔍 Verificar desde la App

Después de aplicar el esquema, la app debería:

1. **✅ Permitir registro de usuarios** - Sin error "relation usuario does not exist"
2. **✅ Permitir login de usuarios** - Sin errores de autenticación
3. **✅ Cargar juegos correctamente** - Sin error "relation juegos does not exist"
4. **✅ Guardar progreso** - Sin errores de base de datos

### 🚨 Solución de Problemas

Si después de aplicar el esquema sigues teniendo problemas:

#### Error: "permission denied"
- Verifica que tengas permisos de administrador en el proyecto Supabase
- Asegúrate de estar ejecutando el script como propietario del proyecto

#### Error: "relation already exists"
- Esto es normal si algunas tablas ya existían
- El script usa `CREATE TABLE IF NOT EXISTS` para evitar errores

#### Error en foreign keys
- Asegúrate de que el módulo `auth` esté habilitado en Supabase
- Ve a **Authentication** en el dashboard y verifica que esté activo

### 📱 Probar la Aplicación

Una vez aplicado el esquema:

1. Ejecuta la app Flutter: `flutter run`
2. Intenta registrarte con un email
3. Intenta iniciar sesión
4. Verifica que los juegos se carguen
5. Juega un poco y verifica que el progreso se guarde

### 📧 Verificar Configuración de Auth

Si el registro/login sigue fallando, verifica en Supabase:

1. Ve a **Authentication > Settings**
2. Asegúrate de que:
   - Email confirmations esté configurado apropiadamente
   - Los dominios permitidos incluyan localhost (para desarrollo)

---

## 🏗️ Estructura Final de la Base de Datos

```
public.usuario (usuarios registrados)
├── id (PK)
├── nombre
├── email (unique)
├── edad
├── auth_user (FK → auth.users)
└── id_progreso (FK → progreso_usuario)

public.invitado (usuarios sin cuenta)
├── id (PK)
├── nombre
├── edad
└── id_progreso (FK → progreso_invitado)

public.juegos (catálogo de juegos)
├── id (PK)
├── nombre (unique)
├── descripcion
├── categoria
└── nivel_minimo

public.progreso (progreso detallado)
├── id (PK)
├── id_juego (FK → juegos)
├── nivel
├── puntaje
├── racha_maxima
├── id_usuario (FK → usuario, nullable)
└── id_invitado (FK → invitado, nullable)
```

---

🎮 **Ejecuta los archivos SQL y tu app debería funcionar perfectamente!**
