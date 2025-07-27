# Despliegue de ramosDCC

## 🎯 Versiones de Despliegue

### 🧪 Staging/Debug: qaramos.cadcc.cl
- **Propósito**: Versión de pruebas con debugging activado
- **DEBUG**: `True`
- **Logging**: Verbose (DEBUG level)
- **Configuración**: `settings_staging.py`

### 🚀 Producción: ramos.cadcc.cl
- **Propósito**: Versión final para usuarios
- **DEBUG**: `False`
- **Logging**: INFO level
- **Configuración**: `settings_production.py`

### 🌐 Servidor CaDCC
- **Propósito**: Despliegue en infraestructura CaDCC con Caddy proxy
- **DEBUG**: `False`
- **Configuración**: `settings_cadcc.py`
- **Proxy**: Caddy reverse proxy

## 📋 Comandos de Despliegue

### Para Servidor CaDCC (Recomendado)
```bash
# En el servidor CaDCC (/home/usuario/Docker/)
./deploy-cadcc.sh
```

### Para Staging (qaramos.cadcc.cl)
```bash
# En el servidor
./deploy-qaramos.sh
```

### Para Producción standalone (ramos.cadcc.cl)
```bash
# En el servidor
./deploy-production.sh
```

## 🔧 Diferencias entre Entornos

| Característica | Staging | Producción | CaDCC |
|---|---|---|---|
| DEBUG | ✅ True | ❌ False | ❌ False |
| Dominio | qaramos.cadcc.cl | ramos.cadcc.cl | Configurado en Caddy |
| Log Level | DEBUG | INFO/WARNING | INFO/WARNING |
| SSL | Directo | Directo | **Terminado en Caddy** |
| Proxy | No | No | **Caddy Reverse Proxy** |
| Puerto expuesto | 8000 | 8000 | **Solo interno** |

## 🐳 Configuraciones Docker

### Standalone (Desarrollo/Testing)
- **Dockerfile**: `Dockerfile`
- **Puertos**: Expone 8000
- **Comando**: `gunicorn` con bind 0.0.0.0:8000

### Servidor CaDCC
- **Dockerfile**: `Dockerfile.caddy`
- **Puertos**: Solo interno 8000
- **Proxy**: Caddy maneja SSL y routing
- **Network**: `proxy` para comunicación con Caddy

## 📝 Logs

### Ver logs en tiempo real
```bash
# Standalone
docker logs -f ramosdcc-staging
docker logs -f ramosdcc-prod

# Servidor CaDCC
docker-compose logs -f ramosdcc
```

### Archivos de log
- Staging: `staging-logs/django-staging.log`
- Producción: `prod-logs/django.log` y `prod-logs/django-errors.log`
- CaDCC: Volúmenes persistentes en `/logs/`

## 🛠️ Comandos Útiles

### Servidor CaDCC
```bash
# Ver estado
docker-compose ps ramosdcc

# Reiniciar
docker-compose restart ramosdcc

# Parar
docker-compose stop ramosdcc

# Acceder al contenedor
docker-compose exec ramosdcc bash

# Comandos Django
docker-compose exec ramosdcc python manage.py migrate
docker-compose exec ramosdcc python manage.py createsuperuser
docker-compose exec ramosdcc python manage.py collectstatic
```

### Standalone
```bash
# Ver estado de contenedores
docker ps

# Reiniciar aplicación
docker restart ramosdcc-prod

# Ejecutar comandos Django
docker exec -it ramosdcc-prod python manage.py createsuperuser
```

## 🔍 Configuración Específica del Servidor CaDCC

### Requisitos
1. **Caddy** como reverse proxy
2. **Network proxy** configurada
3. **Volúmenes persistentes** para datos

### Estructura en servidor
```
/home/usuario/Docker/
├── docker-compose.yml (principal)
├── caddy/
│   └── Caddyfile (configurar dominio)
└── ramosdcc/
    ├── Dockerfile.caddy
    ├── start-caddy.sh
    ├── requirements.txt
    ├── ramosDcc/ (código Django)
    ├── data/ (base de datos)
    ├── logs/ (logs)
    └── media/ (archivos subidos)
```

### Configuración Caddyfile
```
qaramos.cadcc.cl {
    reverse_proxy ramosdcc:8000
    log {
        output file /logs/qaramos.cadcc.cl.log
    }
}
```

## 🚨 Seguridad

### Staging (qaramos.cadcc.cl)
- DEBUG activado (solo para testing)
- Logs detallados disponibles
- Errores visibles en navegador

### Producción (ramos.cadcc.cl)
- DEBUG desactivado
- Errores ocultos al usuario
- Headers de seguridad completos

### Servidor CaDCC
- DEBUG desactivado
- SSL terminado en Caddy
- Headers de proxy configurados
- Logs centralizados

## 📦 Archivos de Configuración

### Docker
- `Dockerfile` - Imagen para despliegue standalone
- `Dockerfile.caddy` - Imagen optimizada para servidor CaDCC
- `docker-compose-cadcc.yml` - Configuración para agregar al compose principal

### Configuración Django
- `settings_staging.py` - Configuración de staging/debug
- `settings_production.py` - Configuración de producción standalone
- `settings_cadcc.py` - Configuración optimizada para servidor CaDCC

### Scripts de inicio
- `start.sh` - Script para contenedores standalone
- `start-caddy.sh` - Script optimizado para servidor CaDCC

### Scripts de despliegue
- `deploy-cadcc.sh` - Despliegue en servidor CaDCC (Recomendado)
- `deploy-qaramos.sh` - Despliegue staging
- `deploy-production.sh` - Despliegue producción standalone

### Características del servidor CaDCC
- 🔒 **SSL terminado en Caddy** (no en Django)
- 📊 **Proxy headers** configurados correctamente
- 📝 **Logs centralizados** con rotación
- 💾 **Volúmenes persistentes** para datos
- � **Restart automático** con `unless-stopped`
- 🌐 **Dominio personalizable** en Caddyfile
