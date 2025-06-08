-- Verificación completa del estado de la base de datos ChemaKids
-- Ejecutar después de aplicar esquema_completo.sql

-- 1. Verificar que todas las tablas existan
SELECT 
    schemaname,
    tablename,
    tableowner,
    hasindexes,
    hasrules,
    hastriggers
FROM pg_tables 
WHERE schemaname = 'public' 
    AND tablename IN ('usuario', 'invitado', 'juegos', 'progreso', 'progreso_usuario', 'progreso_invitado')
ORDER BY tablename;

-- 2. Verificar estructura de tabla usuario
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name = 'usuario'
ORDER BY ordinal_position;

-- 3. Verificar estructura de tabla juegos
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name = 'juegos'
ORDER BY ordinal_position;

-- 4. Verificar foreign keys
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    tc.constraint_name
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_schema = 'public'
    AND tc.table_name IN ('usuario', 'invitado', 'progreso', 'progreso_usuario', 'progreso_invitado')
ORDER BY tc.table_name, kcu.column_name;

-- 5. Verificar que RLS esté habilitado
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE schemaname = 'public' 
    AND tablename IN ('usuario', 'invitado', 'juegos', 'progreso', 'progreso_usuario', 'progreso_invitado')
ORDER BY tablename;

-- 6. Verificar políticas RLS
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- 7. Verificar índices creados
SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes 
WHERE schemaname = 'public' 
    AND tablename IN ('usuario', 'invitado', 'juegos', 'progreso', 'progreso_usuario', 'progreso_invitado')
ORDER BY tablename, indexname;

-- 8. Verificar juegos de ejemplo insertados
SELECT 
    id,
    nombre,
    descripcion,
    categoria,
    nivel_minimo,
    activo,
    fecha_creacion
FROM public.juegos 
ORDER BY id;

-- 9. Contar registros en cada tabla
SELECT 'usuario' as tabla, COUNT(*) as total FROM public.usuario
UNION ALL
SELECT 'invitado' as tabla, COUNT(*) as total FROM public.invitado
UNION ALL
SELECT 'juegos' as tabla, COUNT(*) as total FROM public.juegos
UNION ALL
SELECT 'progreso' as tabla, COUNT(*) as total FROM public.progreso
UNION ALL
SELECT 'progreso_usuario' as tabla, COUNT(*) as total FROM public.progreso_usuario
UNION ALL
SELECT 'progreso_invitado' as tabla, COUNT(*) as total FROM public.progreso_invitado
ORDER BY tabla;

-- 10. Verificar permisos en auth.users (debe existir para foreign keys)
SELECT EXISTS (
    SELECT 1 
    FROM information_schema.tables 
    WHERE table_schema = 'auth' 
        AND table_name = 'users'
) as auth_users_exists;
