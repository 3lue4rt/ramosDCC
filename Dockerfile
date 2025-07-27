# Usa la imagen oficial de Python
FROM python:3.12-slim

# Establece variables de entorno
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=ramosDcc.settings_production

# Establece el directorio de trabajo
WORKDIR /app

# Instala dependencias del sistema
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copia los archivos de requerimientos
COPY requirements.txt /app/

# Instala las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia el código de la aplicación
COPY ramosDcc/ /app/
COPY start.sh /app/

# Hace el script ejecutable
RUN chmod +x /app/start.sh

# Crea directorios para datos persistentes
RUN mkdir -p /app/data /app/logs /app/staticfiles /app/media

# Crea un usuario no root para ejecutar la aplicación
RUN adduser --disabled-password --gecos '' appuser && chown -R appuser /app
USER appuser

# Expone el puerto 8000
EXPOSE 8000

# Comando para ejecutar la aplicación
CMD ["/app/start.sh"]
