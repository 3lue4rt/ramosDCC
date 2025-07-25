# Script para probar la aplicación localmente con Docker en Windows

# Construir la imagen
docker build -t ramosdcc:test .

# Crear directorios de prueba
if (!(Test-Path "test-data")) { New-Item -ItemType Directory -Path "test-data" }
if (!(Test-Path "test-logs")) { New-Item -ItemType Directory -Path "test-logs" }

# Ejecutar el contenedor de prueba
docker run -p 8000:8000 `
  -v "${PWD}/test-data:/app/data" `
  -v "${PWD}/test-logs:/app/logs" `
  -e DJANGO_SETTINGS_MODULE=ramosDcc.settings_production `
  --name ramosdcc-test `
  ramosdcc:test

# Para parar y limpiar:
# docker stop ramosdcc-test
# docker rm ramosdcc-test
# docker rmi ramosdcc:test
