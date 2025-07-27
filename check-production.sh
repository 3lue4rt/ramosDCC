#!/bin/bash
# Script de verificación de seguridad para producción

echo "🔍 VERIFICACIÓN DE SEGURIDAD - PRODUCCIÓN"
echo "========================================"

if [ ! -f ".env" ]; then
    echo "⚠️  Advertencia: No se encuentra archivo .env"
fi

# Verificar si Django está en modo DEBUG
echo "🔧 Verificando configuración de Django..."
docker exec ramosdcc-prod python -c "
from django.conf import settings
import os

print('📊 CONFIGURACIÓN DE SEGURIDAD:')
print('=' * 40)
print(f'✅ DEBUG: {settings.DEBUG}')
print(f'✅ ALLOWED_HOSTS: {settings.ALLOWED_HOSTS}')
print(f'✅ SECRET_KEY: {'[CONFIGURADO]' if settings.SECRET_KEY else '[NO CONFIGURADO]'}')
print(f'✅ SECURE_SSL_REDIRECT: {getattr(settings, 'SECURE_SSL_REDIRECT', 'No configurado')}')
print(f'✅ SESSION_COOKIE_SECURE: {getattr(settings, 'SESSION_COOKIE_SECURE', 'No configurado')}')
print(f'✅ CSRF_COOKIE_SECURE: {getattr(settings, 'CSRF_COOKIE_SECURE', 'No configurado')}')
print(f'✅ X_FRAME_OPTIONS: {getattr(settings, 'X_FRAME_OPTIONS', 'No configurado')}')
print(f'✅ SECURE_CONTENT_TYPE_NOSNIFF: {getattr(settings, 'SECURE_CONTENT_TYPE_NOSNIFF', 'No configurado')}')
"

echo ""
echo "🚨 VERIFICACIONES DE SEGURIDAD:"
echo "================================"

# Verificar que DEBUG esté en False
DEBUG_STATUS=$(docker exec ramosdcc-prod python -c "from django.conf import settings; print(settings.DEBUG)")
if [ "$DEBUG_STATUS" = "False" ]; then
    echo "✅ DEBUG está correctamente desactivado"
else
    echo "❌ PELIGRO: DEBUG está activado en producción!"
fi

# Verificar logs de errores
echo ""
echo "📝 ÚLTIMOS LOGS DE ERROR:"
echo "========================="
if [ -f "prod-logs/django-errors.log" ]; then
    tail -n 10 prod-logs/django-errors.log
else
    echo "✅ No hay errores recientes registrados"
fi

# Verificar espacio en disco
echo ""
echo "💾 ESPACIO EN DISCO:"
echo "==================="
df -h | grep -E "(Filesystem|/dev/)"

# Verificar estado del contenedor
echo ""
echo "🐳 ESTADO DEL CONTENEDOR:"
echo "========================="
docker stats ramosdcc-prod --no-stream

echo ""
echo "🔍 VERIFICACIÓN COMPLETADA"
