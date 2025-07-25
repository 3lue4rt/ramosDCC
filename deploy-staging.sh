#!/bin/bash
# Script para despliegue en staging (qaramos.cadcc.cl)

# Construir la imagen
docker build -t ramosdcc:staging .

# Ejecutar el contenedor de staging
docker run -d \
  -p 8000:8000 \
  -v $(pwd)/staging-data:/app/data \
  -v $(pwd)/staging-logs:/app/logs \
  -e DJANGO_SETTINGS_MODULE=ramosDcc.settings_staging \
  --name ramosdcc-staging \
  --restart unless-stopped \
  ramosdcc:staging

echo "Staging desplegado en qaramos.cadcc.cl"
echo "Logs disponibles en: docker logs ramosdcc-staging"
echo "Para parar: docker stop ramosdcc-staging"
echo "Para reiniciar: docker restart ramosdcc-staging"
