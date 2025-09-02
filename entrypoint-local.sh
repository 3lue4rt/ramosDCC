#!/bin/bash

# Script de entrada para desarrollo local
echo "🐳 Iniciando aplicación Django en modo local..."

# Esperar a que la base de datos esté lista (si fuera necesario)
echo "📦 Configurando aplicación..."

# Ejecutar migraciones
echo "🔄 Ejecutando migraciones..."
python manage.py migrate --noinput

# Recopilar archivos estáticos
echo "📁 Recopilando archivos estáticos..."
python manage.py collectstatic --noinput

# Mostrar información útil
echo ""
echo "✅ Aplicación configurada correctamente"
echo "📋 Información del entorno:"
echo "   - Configuración: $DJANGO_SETTINGS_MODULE"
echo "   - Puerto: 80"
echo "   - Base de datos: /app/data/db.sqlite3"
echo "   - Servidor: Gunicorn (idéntico a producción)"
echo ""

# Iniciar Gunicorn (igual que en producción)
echo "🚀 Iniciando servidor Gunicorn..."
exec gunicorn --bind 0.0.0.0:80 --workers 2 --reload ramosDcc.wsgi:application
