#!/bin/bash

# Script para probar Deep Linking en ChemaKids macOS
# Este script simula diferentes tipos de deep links

echo "🧪 Probando Deep Linking en ChemaKids"
echo "======================================"

# Función para mostrar ayuda
show_help() {
    echo "Uso: ./test_deep_linking.sh [OPCION]"
    echo ""
    echo "Opciones:"
    echo "  nav       - Probar navegación básica"
    echo "  auth      - Probar autenticación básica"
    echo "  verify    - Simular verificación de email"
    echo "  all       - Ejecutar todas las pruebas"
    echo "  help      - Mostrar esta ayuda"
    echo ""
}

# Función para probar navegación
test_navigation() {
    echo "🧭 Probando navegación básica..."
    echo "Abriendo: chemakids://menu"
    open "chemakids://menu"
    sleep 2
    echo "✅ Navegación enviada"
}

# Función para probar autenticación básica
test_auth_basic() {
    echo "🔐 Probando autenticación básica..."
    echo "Abriendo: chemakids://auth"
    open "chemakids://auth"
    sleep 2
    echo "✅ Autenticación básica enviada"
}

# Función para simular verificación de email
test_email_verification() {
    echo "📧 Simulando verificación de email..."
    
    # URL simulada con tokens de ejemplo (no reales)
    local test_url="chemakids://auth#access_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test&refresh_token=test_refresh_token&expires_in=3600&token_type=bearer&type=signup"
    
    echo "Abriendo: $test_url"
    open "$test_url"
    sleep 2
    echo "✅ Verificación de email simulada enviada"
    echo "⚠️  Nota: Los tokens son de prueba, no funcionarán realmente"
}

# Función para ejecutar todas las pruebas
test_all() {
    echo "🚀 Ejecutando todas las pruebas..."
    echo ""
    
    test_navigation
    echo ""
    sleep 3
    
    test_auth_basic
    echo ""
    sleep 3
    
    test_email_verification
    echo ""
    
    echo "✅ Todas las pruebas completadas"
    echo ""
    echo "📋 Para verificar que funcionaron:"
    echo "1. Revisa la consola de Flutter para logs de DeepLinkService"
    echo "2. Observa si la aplicación cambió de pantalla"
    echo "3. Verifica que se muestren notificaciones en la app"
}

# Función para mostrar estado de la aplicación
show_app_status() {
    echo "📱 Estado de la aplicación:"
    
    # Verificar si la app está ejecutándose
    if pgrep -x "chemakids" > /dev/null; then
        echo "✅ ChemaKids está ejecutándose"
    else
        echo "❌ ChemaKids no está ejecutándose"
        echo "💡 Ejecuta: flutter run -d macos"
    fi
}

# Main script
case "${1:-help}" in
    "nav")
        show_app_status
        echo ""
        test_navigation
        ;;
    "auth")
        show_app_status
        echo ""
        test_auth_basic
        ;;
    "verify")
        show_app_status
        echo ""
        test_email_verification
        ;;
    "all")
        show_app_status
        echo ""
        test_all
        ;;
    "help"|*)
        show_help
        ;;
esac

echo ""
echo "🔍 Consejos para debugging:"
echo "- Observa la consola de Flutter para logs de '[DeepLinkService]'"
echo "- Verifica que la app responda a los enlaces"
echo "- Si no funciona, revisa los entitlements en macos/Runner/"
echo ""
