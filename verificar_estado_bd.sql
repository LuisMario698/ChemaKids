-- Verificar estado actual de las tablas en Supabase
-- Ejecutar este script en el SQL Editor de Supabase para verificar el estado

-- 1. Verificar que las tablas existen
SELECT 
    table_name,
    table_schema
FROM information_schema.tables 
WHERE table_schema = 'public' 
    AND table_name IN ('usuario', 'invitado', 'juegos', 'progreso')
ORDER BY table_name;

-- 2. Verificar estructura de la tabla usuario
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name = 'usuario'
ORDER BY ordinal_position;

-- 3. Verificar estructura de la tabla invitado
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name = 'invitado'
ORDER BY ordinal_position;

-- 4. Verificar foreign keys
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_schema = 'public'
    AND tc.table_name IN ('usuario', 'invitado', 'progreso');

-- 5. Contar registros en cada tabla (para verificar que están vacías/pobladas)
SELECT 'usuario' as tabla, COUNT(*) as registros FROM usuario
UNION ALL
SELECT 'invitado' as tabla, COUNT(*) as registros FROM invitado
UNION ALL
SELECT 'juegos' as tabla, COUNT(*) as registros FROM juegos
UNION ALL
SELECT 'progreso' as tabla, COUNT(*) as registros FROM progreso;
