# Script para probar la aplicación localmente con Docker

# Construir la imagen
docker build -t ramosdcc:test .

# Ejecutar el contenedor de prueba
docker run -p 8000:8000 \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/logs:/app/logs \
  -e DJANGO_SETTINGS_MODULE=ramosDcc.settings_production \
  --name ramosdcc-test \
  ramosdcc:test

# Para parar y limpiar:
# docker stop ramosdcc-test
# docker rm ramosdcc-test
# docker rmi ramosdcc:test
