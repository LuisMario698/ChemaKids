#!/bin/bash

# Script para verificar el estado de la base de datos ChemaKids
# Ejecuta consultas SQL para verificar tablas, políticas y datos

echo "🔍 Verificando estado de la base de datos ChemaKids..."
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Verificando si las tablas existen...${NC}"
echo ""

# Verificar tablas
echo "-- Consulta para verificar tablas existentes"
echo "SELECT table_name, table_type "
echo "FROM information_schema.tables "
echo "WHERE table_schema = 'public' "
echo "AND table_name IN ('usuario', 'invitado', 'juegos', 'progreso');"
echo ""

# Verificar estructura de la tabla usuario
echo -e "${BLUE}📊 Estructura de la tabla usuario:${NC}"
echo ""
echo "-- Consulta para ver columnas de la tabla usuario"
echo "SELECT column_name, data_type, is_nullable, column_default "
echo "FROM information_schema.columns "
echo "WHERE table_schema = 'public' "
echo "AND table_name = 'usuario' "
echo "ORDER BY ordinal_position;"
echo ""

# Verificar restricciones
echo -e "${BLUE}🔒 Restricciones de la tabla usuario:${NC}"
echo ""
echo "-- Consulta para ver restricciones"
echo "SELECT constraint_name, constraint_type "
echo "FROM information_schema.table_constraints "
echo "WHERE table_schema = 'public' "
echo "AND table_name = 'usuario';"
echo ""

# Verificar políticas RLS
echo -e "${BLUE}🛡️ Políticas de seguridad RLS:${NC}"
echo ""
echo "-- Consulta para ver políticas RLS"
echo "SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual "
echo "FROM pg_policies "
echo "WHERE schemaname = 'public' "
echo "AND tablename IN ('usuario', 'progreso');"
echo ""

# Verificar datos de ejemplo
echo -e "${BLUE}🎮 Juegos disponibles:${NC}"
echo ""
echo "-- Consulta para ver juegos disponibles"
echo "SELECT id, nombre, categoria, nivel_minimo, nivel_maximo, activo "
echo "FROM public.juegos "
echo "ORDER BY categoria, nivel_minimo;"
echo ""

# Verificar usuarios registrados
echo -e "${BLUE}👥 Usuarios registrados:${NC}"
echo ""
echo "-- Consulta para ver usuarios registrados (sin datos sensibles)"
echo "SELECT id, nombre, edad, nivel, created_at "
echo "FROM public.usuario "
echo "ORDER BY created_at DESC;"
echo ""

# Test de inserción
echo -e "${YELLOW}🧪 Script de prueba para insertar usuario:${NC}"
echo ""
echo "-- NOTA: Este INSERT debería fallar si no tienes un auth_user válido"
echo "-- Reemplaza 'uuid-aqui' con un UUID real de auth.users"
echo ""
echo "INSERT INTO public.usuario (auth_user, email, nombre, edad, nivel) "
echo "VALUES ("
echo "    'uuid-aqui'::uuid, "
echo "    'test@example.com', "
echo "    'Usuario de Prueba', "
echo "    8, "
echo "    1"
echo ");"
echo ""

echo -e "${GREEN}✅ Script de verificación completado${NC}"
echo ""
echo -e "${YELLOW}📝 Instrucciones:${NC}"
echo "1. Copia y pega estas consultas en el Editor SQL de Supabase"
echo "2. Ejecuta cada sección por separado para diagnosticar problemas"
echo "3. Si la tabla 'usuario' no existe, ejecuta database_schema.sql primero"
echo "4. Verifica que las políticas RLS estén configuradas correctamente"
echo ""
