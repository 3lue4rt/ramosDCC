# Script para despliegue en staging (qaramos.cadcc.cl) - PowerShell

Write-Host "Construyendo imagen de staging..." -ForegroundColor Green
docker build -t ramosdcc:staging .

Write-Host "Parando contenedor anterior si existe..." -ForegroundColor Yellow
docker stop ramosdcc-staging 2>$null
docker rm ramosdcc-staging 2>$null

Write-Host "Creando directorios para staging..." -ForegroundColor Blue
New-Item -ItemType Directory -Force -Path "staging-data"
New-Item -ItemType Directory -Force -Path "staging-logs"

Write-Host "Ejecutando contenedor de staging..." -ForegroundColor Green
docker run -d `
  -p 8000:8000 `
  -v "${PWD}/staging-data:/app/data" `
  -v "${PWD}/staging-logs:/app/logs" `
  -e DJANGO_SETTINGS_MODULE=ramosDcc.settings_staging `
  --name ramosdcc-staging `
  --restart unless-stopped `
  ramosdcc:staging

Write-Host "Staging desplegado exitosamente!" -ForegroundColor Green
Write-Host "URL: http://qaramos.cadcc.cl" -ForegroundColor Cyan
Write-Host "Logs: docker logs ramosdcc-staging" -ForegroundColor Yellow
Write-Host "Parar: docker stop ramosdcc-staging" -ForegroundColor Yellow
Write-Host "Reiniciar: docker restart ramosdcc-staging" -ForegroundColor Yellow
