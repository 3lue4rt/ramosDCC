# Usar Python 3.12 como imagen base
FROM python:3.12-slim

# Configurar variables de entorno
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=ramosDcc.settings_production

# Establecer directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements y instalar dependencias de Python
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código de la aplicación
COPY ramosDcc/ /app/

# Crear directorio para archivos estáticos
RUN mkdir -p /app/staticfiles

# Recopilar archivos estáticos
RUN python manage.py collectstatic --noinput

# Crear directorio para la base de datos y darle permisos
RUN mkdir -p /app/data && chmod 755 /app/data

# No ejecutar migraciones aquí - se ejecutarán en el entrypoint

# Crear un script de entrada
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Exponer puerto
EXPOSE 8500

# Comando por defecto
ENTRYPOINT ["/app/entrypoint.sh"]
