#!/bin/bash
# Script de despliegue para qaramos.cadcc.cl
# Ejecutar en el servidor CaDCC

echo "🚀 Iniciando despliegue de ramosDCC staging..."

# Crear directorios necesarios
echo "📁 Creando directorios..."
mkdir -p data logs

# Parar contenedor anterior si existe
echo "🛑 Parando contenedor anterior..."
docker stop ramosdcc-staging 2>/dev/null || true
docker rm ramosdcc-staging 2>/dev/null || true

# Construir imagen
echo "🔨 Construyendo imagen Docker..."
docker build -t ramosdcc:staging .

# Ejecutar contenedor
echo "▶️ Iniciando contenedor de staging..."
docker run -d \
  -p 8000:8000 \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/logs:/app/logs \
  -e DJANGO_SETTINGS_MODULE=ramosDcc.settings_staging \
  --name ramosdcc-staging \
  --restart unless-stopped \
  ramosdcc:staging

# Verificar estado
echo "✅ Verificando estado del contenedor..."
sleep 5
docker ps | grep ramosdcc-staging

echo "🎉 Despliegue completado!"
echo "🌐 Aplicación disponible en: http://qaramos.cadcc.cl"
echo "📋 Ver logs: docker logs -f ramosdcc-staging"
echo "🔄 Reiniciar: docker restart ramosdcc-staging"
echo "🛑 Parar: docker stop ramosdcc-staging"

# Mostrar logs iniciales
echo "📝 Logs iniciales:"
docker logs --tail 20 ramosdcc-staging
