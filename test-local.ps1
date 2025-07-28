# Script para probar la aplicacion localmente en Windows
Write-Host "Iniciando pruebas locales de RamosDCC" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Crear directorio de datos si no existe
if (!(Test-Path "./data")) {
    Write-Host "Creando directorio de datos..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "./data" -Force | Out-Null
}

# Construir la imagen
Write-Host "Construyendo imagen Docker..." -ForegroundColor Yellow
docker-compose -f docker-compose.local.yml build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al construir la imagen Docker" -ForegroundColor Red
    exit 1
}

# Iniciar el contenedor
Write-Host "Iniciando contenedor..." -ForegroundColor Yellow
docker-compose -f docker-compose.local.yml up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al iniciar el contenedor" -ForegroundColor Red
    exit 1
}

Write-Host "Contenedor iniciado correctamente" -ForegroundColor Green
Write-Host ""
Write-Host "Informacion del servicio:" -ForegroundColor Cyan
Write-Host "   - URL: http://localhost:80" -ForegroundColor White
Write-Host "   - Contenedor: ramos-django-local" -ForegroundColor White
Write-Host "   - Base de datos: ./data/db.sqlite3" -ForegroundColor White
Write-Host ""
Write-Host "Comandos utiles:" -ForegroundColor Cyan
Write-Host "   - Ver logs: docker-compose -f docker-compose.local.yml logs -f" -ForegroundColor White
Write-Host "   - Parar: docker-compose -f docker-compose.local.yml down" -ForegroundColor White
Write-Host "   - Crear superusuario: docker-compose -f docker-compose.local.yml exec ramos-django python manage.py createsuperuser" -ForegroundColor White
Write-Host ""
Write-Host "Esperando que la aplicacion este lista..." -ForegroundColor Yellow

# Esperar a que la aplicacion este lista
Start-Sleep -Seconds 5

# Verificar que la aplicacion responda
Write-Host "Verificando que la aplicacion responda..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri "http://localhost:80" -UseBasicParsing -TimeoutSec 10
    $status = $response.StatusCode
    
    if ($status -eq 200 -or $status -eq 302 -or $status -eq 301) {
        Write-Host "Aplicacion funcionando correctamente!" -ForegroundColor Green
        Write-Host "Abre tu navegador en: http://localhost:80" -ForegroundColor Cyan
    } else {
        Write-Host "La aplicacion responde con codigo: $status" -ForegroundColor Yellow
        Write-Host "Revisa los logs con: docker-compose -f docker-compose.local.yml logs" -ForegroundColor White
    }
} catch {
    Write-Host "No se pudo verificar el estado de la aplicacion: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "Revisa los logs con: docker-compose -f docker-compose.local.yml logs" -ForegroundColor White
}
