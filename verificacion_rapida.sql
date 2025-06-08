-- Script de verificación rápida para Supabase
-- Copia y pega esto en el Editor SQL de Supabase

-- 1. Verificar si las tablas principales existen
SELECT 
    'Tabla: ' || table_name as verificacion,
    CASE 
        WHEN table_name IS NOT NULL THEN '✅ Existe'
        ELSE '❌ No existe'
    END as estado
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('usuario', 'invitado', 'juegos', 'progreso')
ORDER BY table_name;

-- 2. Verificar estructura de tabla usuario
SELECT 
    '🔍 Estructura de tabla usuario' as info;

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'usuario' 
ORDER BY ordinal_position;

-- 3. Verificar que existen juegos de ejemplo
SELECT 
    '🎮 Juegos disponibles' as info;

SELECT 
    COUNT(*) as total_juegos,
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ Hay juegos'
        ELSE '❌ No hay juegos'
    END as estado
FROM public.juegos;

-- 4. Ver los juegos disponibles
SELECT 
    id,
    nombre,
    categoria,
    nivel_minimo,
    nivel_maximo,
    activo
FROM public.juegos
ORDER BY categoria, nivel_minimo;

-- 5. Verificar políticas RLS
SELECT 
    '🛡️ Políticas de seguridad' as info;

SELECT 
    tablename,
    policyname,
    cmd as operacion
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- 6. Test de inserción de usuario (cambiar UUID por uno real)
SELECT 
    '🧪 Para probar inserción de usuario, ejecuta:' as info;

SELECT 
    'INSERT INTO public.usuario (auth_user, email, nombre, edad, nivel) VALUES (''REEMPLAZAR-CON-UUID-REAL'', ''test@example.com'', ''Usuario Prueba'', 8, 1);' as sql_prueba;
