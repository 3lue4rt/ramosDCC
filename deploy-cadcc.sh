#!/bin/bash
# Script de despliegue para servidor CaDCC
# Siguiendo las instrucciones del servidor

echo "🚀 Desplegando ramosDCC en servidor CaDCC"
echo "==========================================="

# Verificar que estamos en la carpeta correcta
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: Debes ejecutar este script desde la carpeta Docker del servidor"
    echo "   Normalmente: /home/usuario/Docker/"
    exit 1
fi

# Crear estructura de directorios
echo "📁 Creando estructura de directorios..."
mkdir -p ramosdcc/data
mkdir -p ramosdcc/logs
mkdir -p ramosdcc/media

echo "📋 Copiando archivos de la aplicación..."
# Aquí asumimos que los archivos están en una carpeta temporal
# En el servidor real, esto se haría desde git o transferencia de archivos

echo "🛑 Parando servicio anterior si existe..."
docker-compose stop ramosdcc 2>/dev/null || true
docker-compose rm -f ramosdcc 2>/dev/null || true

echo "🔨 Construyendo imagen..."
docker-compose build ramosdcc

if [ $? -ne 0 ]; then
    echo "❌ Error al construir imagen"
    exit 1
fi

echo "🚀 Iniciando servicio..."
docker-compose up -d ramosdcc

if [ $? -ne 0 ]; then
    echo "❌ Error al iniciar servicio"
    exit 1
fi

echo "⏳ Esperando que inicie el servicio..."
sleep 15

echo "✅ Verificando estado..."
docker-compose ps ramosdcc

echo "📝 Logs iniciales:"
docker-compose logs --tail 20 ramosdcc

echo ""
echo "🎉 ¡Despliegue completado!"
echo "📊 Ver estado: docker-compose ps ramosdcc"
echo "📋 Ver logs: docker-compose logs -f ramosdcc"
echo "🛑 Parar: docker-compose stop ramosdcc"
echo "🔄 Reiniciar: docker-compose restart ramosdcc"
echo ""
echo "🌐 La aplicación estará disponible según la configuración de Caddy"
echo "   Probablemente en: https://qaramos.cadcc.cl"
