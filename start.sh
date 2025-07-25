#!/bin/bash

# Script de inicio para la aplicación Django en producción

# Crear directorios necesarios
mkdir -p /app/data
mkdir -p /app/logs
mkdir -p /app/staticfiles

# Establecer la variable de entorno para Django
export DJANGO_SETTINGS_MODULE=ramosDcc.settings_production

# Ejecutar migraciones
python manage.py migrate

# Recolectar archivos estáticos
python manage.py collectstatic --noinput

# Crear superusuario si no existe (opcional)
# python manage.py createsuperuser --noinput

# Iniciar servidor con gunicorn (robusto para producción)
exec gunicorn ramosDcc.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --timeout 120
