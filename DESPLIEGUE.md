# Despliegue de RamosCC en el Servidor CaDCC

Este documento explica cómo desplegar la aplicación Django "RamosCC" en el servidor del CaDCC usando Docker.

## Archivos Agregados para el Despliegue

- `Dockerfile`: Configuración de la imagen Docker
- `start.sh`: Script de inicio para producción
- `ramosDcc/settings_production.py`: Configuraciones de producción
- `.dockerignore`: Archivos a ignorar en la construcción Docker
- `docker-compose-config.yml`: Configuración para agregar al docker-compose.yml del servidor

## Pasos para el Despliegue

### 1. Preparar los archivos en el servidor

```bash
# En tu máquina local, copia toda la carpeta del proyecto al servidor
scp -r ramosDCC/ usuario@servidor:/ruta/al/Docker/

# En el servidor, renombra la carpeta
mv ramosDCC ramos
```

### 2. Configurar el dominio

Asegúrate de que el dominio `ramos.cadcc.cl` apunte al servidor en el DNS.

### 3. Agregar al docker-compose.yml

Edita el archivo `Docker/docker-compose.yml` del servidor y agrega el servicio que está en `docker-compose-config.yml`.

### 4. Construir y ejecutar

```bash
cd Docker
docker-compose build ramos
docker-compose up -d ramos
```

### 5. Verificar el despliegue

```bash
# Ver logs
docker-compose logs -f ramos

# Verificar que el contenedor esté corriendo
docker-compose ps ramos
```

### 6. Configuración inicial (si es necesario)

```bash
# Crear superusuario
docker-compose exec ramos python manage.py createsuperuser --settings=ramosDcc.settings_production

# Aplicar migraciones (si hay cambios)
docker-compose exec ramos python manage.py migrate --settings=ramosDcc.settings_production
```

## Comandos Útiles

### Actualizar la aplicación
```bash
docker-compose stop ramos
docker-compose build ramos
docker-compose up -d ramos
```

### Ver logs en tiempo real
```bash
docker-compose logs -f ramos
```

### Ejecutar comandos Django
```bash
docker-compose exec ramos python manage.py <comando> --settings=ramosDcc.settings_production
```

### Backup de la base de datos
```bash
# Copia el archivo SQLite
cp Docker/ramos/data/db.sqlite3 backup-$(date +%Y%m%d).sqlite3
```

## Estructura de Archivos en el Servidor

```
Docker/
└── ramos/
    ├── Dockerfile
    ├── start.sh
    ├── requirements.txt
    ├── ramosDcc/
    │   ├── manage.py
    │   ├── ramosDcc/
    │   │   ├── settings.py
    │   │   ├── settings_production.py
    │   │   └── ...
    │   └── opinion/
    │       └── ...
    ├── data/              # Datos persistentes (base de datos)
    ├── logs/              # Logs de la aplicación
    └── staticfiles/       # Archivos estáticos generados
```

## Configuración de Producción

La aplicación está configurada para:
- Usar gunicorn como servidor WSGI
- Servir archivos estáticos correctamente
- Logging a archivos
- Configuraciones de seguridad para producción
- SSL/HTTPS manejado por Caddy (proxy reverso)

## Troubleshooting

### La aplicación no inicia
```bash
docker-compose logs ramos
```

### Problemas con archivos estáticos
```bash
docker-compose exec ramos python manage.py collectstatic --noinput --settings=ramosDcc.settings_production
```

### Problemas con la base de datos
```bash
docker-compose exec ramos python manage.py migrate --settings=ramosDcc.settings_production
```

### Problemas de permisos
```bash
# En el servidor, verifica los permisos de las carpetas
sudo chown -R 1000:1000 Docker/ramos/data/
sudo chown -R 1000:1000 Docker/ramos/logs/
```

## Contacto

Para dudas sobre el despliegue, contacta al administrador de sistemas del CaDCC.
