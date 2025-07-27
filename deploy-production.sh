#!/bin/bash
# Script de despliegue para PRODUCCIÓN - ramos.cadcc.cl
# USAR CON CUIDADO - Solo en servidor de producción

echo "🚀 INICIANDO DESPLIEGUE DE PRODUCCIÓN - ramos.cadcc.cl"
echo "⚠️  ADVERTENCIA: Este es el entorno de producción"
echo ""

# Confirmación de seguridad
read -p "¿Estás seguro de que quieres desplegar en PRODUCCIÓN? (y/N): " confirm
if [[ $confirm != [yY] ]]; then
    echo "❌ Despliegue cancelado"
    exit 1
fi

echo "📁 Creando directorios de producción..."
mkdir -p data logs media

# Backup de datos existentes
if [ -f "data/db.sqlite3" ]; then
    echo "💾 Creando backup de base de datos..."
    cp data/db.sqlite3 "data/db.sqlite3.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Parar contenedor anterior
echo "🛑 Parando contenedor de producción anterior..."
docker stop ramosdcc-prod 2>/dev/null || true
docker rm ramosdcc-prod 2>/dev/null || true

# Construir imagen
echo "🔨 Construyendo imagen de producción..."
docker build -t ramosdcc:prod .

if [ $? -ne 0 ]; then
    echo "❌ Error al construir imagen"
    exit 1
fi

# Ejecutar contenedor de producción
echo "🚀 Iniciando contenedor de producción..."
docker run -d \
  -p 8000:8000 \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/logs:/app/logs \
  -v $(pwd)/media:/app/media \
  -e DJANGO_SETTINGS_MODULE=ramosDcc.settings_production \
  --name ramosdcc-prod \
  --restart unless-stopped \
  ramosdcc:prod

if [ $? -ne 0 ]; then
    echo "❌ Error al iniciar contenedor"
    exit 1
fi

# Verificar estado
echo "✅ Verificando estado del contenedor..."
sleep 10
docker ps | grep ramosdcc-prod

echo ""
echo "🎉 DESPLIEGUE DE PRODUCCIÓN COMPLETADO!"
echo "🌐 Aplicación disponible en: https://ramos.cadcc.cl"
echo "📋 Ver logs: docker logs -f ramosdcc-prod"
echo "📊 Estado: docker ps | grep ramosdcc-prod"
echo "🔄 Reiniciar: docker restart ramosdcc-prod"
echo "🛑 Parar: docker stop ramosdcc-prod"
echo ""

# Mostrar logs iniciales
echo "📝 Logs iniciales de producción:"
docker logs --tail 30 ramosdcc-prod

echo ""
echo "🔍 Verificando configuración de seguridad..."
docker exec ramosdcc-prod python -c "
from django.conf import settings
print(f'DEBUG: {settings.DEBUG}')
print(f'ALLOWED_HOSTS: {settings.ALLOWED_HOSTS}')
print(f'SECURE_SSL_REDIRECT: {settings.SECURE_SSL_REDIRECT}')
"
