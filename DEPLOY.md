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

## 📋 Comandos de Despliegue

### Para Staging (qaramos.cadcc.cl)
```bash
# En el servidor
./deploy-qaramos.sh
```

### Para Producción (ramos.cadcc.cl)
```bash
# En el servidor
docker build -t ramosdcc:prod .
docker run -d -p 8000:8000 \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/logs:/app/logs \
  -e DJANGO_SETTINGS_MODULE=ramosDcc.settings_production \
  --name ramosdcc-prod \
  --restart unless-stopped \
  ramosdcc:prod
```

## 🔧 Diferencias entre Entornos

| Característica | Staging | Producción |
|---|---|---|
| DEBUG | ✅ True | ❌ False |
| Dominio | qaramos.cadcc.cl | ramos.cadcc.cl |
| Log Level | DEBUG | INFO |
| Error Display | Detallado | Básico |
| X_FRAME_OPTIONS | SAMEORIGIN | DENY |

## 📝 Logs

### Ver logs en tiempo real
```bash
docker logs -f ramosdcc-staging  # Para staging
docker logs -f ramosdcc-prod     # Para producción
```

### Archivos de log
- Staging: `staging-logs/django-staging.log`
- Producción: `logs/django.log`

## 🛠️ Comandos Útiles

```bash
# Ver estado de contenedores
docker ps

# Reiniciar aplicación
docker restart ramosdcc-staging

# Parar aplicación
docker stop ramosdcc-staging

# Ver logs de base de datos (si es necesario)
docker exec -it ramosdcc-staging python manage.py dbshell

# Ejecutar comandos Django
docker exec -it ramosdcc-staging python manage.py createsuperuser
docker exec -it ramosdcc-staging python manage.py collectstatic

# Acceder al contenedor
docker exec -it ramosdcc-staging bash
```

## 🔍 Debugging en Staging

La versión de staging incluye:
- ✅ Errores detallados en pantalla
- ✅ Logs verbosos en consola y archivo
- ✅ SQL logging (comentado, descomentar si es necesario)
- ✅ Django Debug Toolbar (si se instala)

## 🚨 Seguridad

### Staging (qaramos.cadcc.cl)
- DEBUG activado (solo para testing)
- Logs detallados disponibles
- Errores visibles en navegador

### Producción (ramos.cadcc.cl)
- DEBUG desactivado
- Errores ocultos al usuario
- Logs solo en servidor
- Headers de seguridad completos

## 📦 Archivos de Configuración

- `settings_staging.py` - Configuración de staging/debug
- `settings_production.py` - Configuración de producción
- `deploy-qaramos.sh` - Script de despliegue para staging
- `Dockerfile` - Imagen Docker unificada
- `start.sh` - Script de inicio del contenedor
