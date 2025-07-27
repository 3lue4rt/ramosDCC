# Script para probar configuración de producción localmente

Write-Host "Preparando entorno de producción local..." -ForegroundColor Green

# Parar contenedores anteriores
Write-Host "Parando contenedores anteriores..." -ForegroundColor Yellow
docker stop ramosdcc-staging ramosdcc-test ramosdcc-prod 2>$null
docker rm ramosdcc-staging ramosdcc-test ramosdcc-prod 2>$null

# Crear directorios para producción
Write-Host "Creando directorios de producción..." -ForegroundColor Blue
New-Item -ItemType Directory -Force -Path "prod-data"
New-Item -ItemType Directory -Force -Path "prod-logs"
New-Item -ItemType Directory -Force -Path "prod-media"

Write-Host "Construyendo imagen de producción..." -ForegroundColor Green
docker build -t ramosdcc:prod .

Write-Host "Ejecutando contenedor de producción local..." -ForegroundColor Green
docker run -d `
  -p 8000:8000 `
  -v "${PWD}/prod-data:/app/data" `
  -v "${PWD}/prod-logs:/app/logs" `
  -v "${PWD}/prod-media:/app/media" `
  -e DJANGO_SETTINGS_MODULE=ramosDcc.settings_production `
  --name ramosdcc-prod `
  ramosdcc:prod

Write-Host "Esperando que inicie el contenedor..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "Estado del contenedor:" -ForegroundColor Cyan
docker ps | Where-Object { $_ -match "ramosdcc-prod" }

Write-Host "Logs del contenedor:" -ForegroundColor Cyan
docker logs --tail 20 ramosdcc-prod

Write-Host "Prueba de producción lista!" -ForegroundColor Green
Write-Host "Aplicación: http://localhost:8000" -ForegroundColor Cyan
Write-Host "Ver logs: docker logs -f ramosdcc-prod" -ForegroundColor Yellow
Write-Host "Parar: docker stop ramosdcc-prod" -ForegroundColor Yellow
