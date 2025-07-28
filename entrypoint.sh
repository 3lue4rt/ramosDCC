#!/bin/bash

# Esperar a que la base de datos esté lista (si fuera necesario)
echo "Iniciando aplicación Django..."

# Ejecutar migraciones
echo "Ejecutando migraciones..."
python manage.py migrate --noinput

# Recopilar archivos estáticos
echo "Recopilando archivos estáticos..."
python manage.py collectstatic --noinput

# Iniciar Gunicorn
echo "Iniciando servidor Gunicorn..."
exec gunicorn --bind 0.0.0.0:80 --workers 3 ramosDcc.wsgi:application
