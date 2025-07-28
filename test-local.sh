#!/bin/bash

echo "🐳 Iniciando pruebas locales de RamosDCC"
echo "========================================="

# Crear directorio de datos si no existe
if [ ! -d "./data" ]; then
    echo "📁 Creando directorio de datos..."
    mkdir -p ./data
fi

# Construir la imagen
echo "🔨 Construyendo imagen Docker..."
docker-compose -f docker-compose.local.yml build

if [ $? -ne 0 ]; then
    echo "❌ Error al construir la imagen Docker"
    exit 1
fi

# Iniciar el contenedor
echo "🚀 Iniciando contenedor..."
docker-compose -f docker-compose.local.yml up -d

if [ $? -ne 0 ]; then
    echo "❌ Error al iniciar el contenedor"
    exit 1
fi

echo "✅ Contenedor iniciado correctamente"
echo ""
echo "📋 Información del servicio:"
echo "   - URL: http://localhost:80"
echo "   - Contenedor: ramos-django-local"
echo "   - Base de datos: ./data/db.sqlite3"
echo ""
echo "🔧 Comandos útiles:"
echo "   - Ver logs: docker-compose -f docker-compose.local.yml logs -f"
echo "   - Parar: docker-compose -f docker-compose.local.yml down"
echo "   - Crear superusuario: docker-compose -f docker-compose.local.yml exec ramos-django python manage.py createsuperuser"
echo ""
echo "⏳ Esperando que la aplicación esté lista..."

# Esperar a que la aplicación esté lista
sleep 5

# Verificar que la aplicación responda
echo "🔍 Verificando que la aplicación responda..."
curl -s -o /dev/null -w "%{http_code}" http://localhost:80 > /tmp/http_status

if [ -f /tmp/http_status ]; then
    status=$(cat /tmp/http_status)
    if [ "$status" = "200" ] || [ "$status" = "302" ] || [ "$status" = "301" ]; then
        echo "✅ ¡Aplicación funcionando correctamente!"
        echo "🌐 Abre tu navegador en: http://localhost:80"
    else
        echo "⚠️  La aplicación responde con código: $status"
        echo "📄 Revisa los logs con: docker-compose -f docker-compose.local.yml logs"
    fi
    rm /tmp/http_status
else
    echo "⚠️  No se pudo verificar el estado de la aplicación"
    echo "📄 Revisa los logs con: docker-compose -f docker-compose.local.yml logs"
fi
