# Despliegue en Servidor CaDCC

## 🎯 **Objetivo**
Desplegar la nueva aplicación Django ramosDCC **coexistiendo** con la aplicación actual `ramos`.

## 📋 **Preparación**

### 1. Estructura en el servidor CaDCC:
```
/home/usuario/Docker/
├── docker-compose.yml (archivo principal del servidor)
├── ramos/ (aplicación actual - NO TOCAR)
└── ramosdcc/ (nueva aplicación Django)
    ├── Dockerfile.caddy
    ├── start-caddy.sh
    ├── requirements.txt
    ├── docker-compose-cadcc.yml (referencia)
    └── ramosDcc/ (código Django)
```

### 2. Agregar al docker-compose.yml del servidor:
```yaml
# Agregar esta sección a services: en docker-compose.yml
    ramosdcc:
        build: 
            context: ./ramosdcc/
            dockerfile: Dockerfile.caddy
        container_name: ramosdcc
        restart: always
        depends_on:
            - caddy
        volumes:
            - ./ramosdcc/data:/app/data
            - ./ramosdcc/logs:/app/logs
            - ./ramosdcc/media:/app/media
            - /etc/localtime:/etc/localtime:ro
        environment:
            - DJANGO_SETTINGS_MODULE=ramosDcc.settings_cadcc
        networks:
            - proxy
```

### 3. Configurar Caddy (Caddyfile):
Agregar al Caddyfile del servidor:
```
qaramos.cadcc.cl {
    reverse_proxy ramosdcc:8000
    log {
        output file /logs/qaramos.cadcc.cl.log
    }
}
```

## 🚀 **Comandos de Despliegue**

### Construcción:
```bash
cd /home/usuario/Docker
docker-compose build ramosdcc
```

### Inicio:
```bash
docker-compose up -d ramosdcc
```

### Verificación:
```bash
docker-compose ps ramosdcc
docker-compose logs ramosdcc
```

### Mantenimiento:
```bash
# Parar
docker-compose stop ramosdcc

# Reiniciar
docker-compose restart ramosdcc

# Ver logs en tiempo real
docker-compose logs -f ramosdcc

# Eliminar (mantiene volúmenes)
docker-compose stop ramosdcc
docker-compose rm ramosdcc
```

## 🔧 **Configuraciones importantes**

### Diferencias con despliegue standalone:
- ❌ **NO expone puertos** (Caddy hace proxy)
- ✅ **Usa network proxy** para comunicarse con Caddy
- ✅ **Headers de proxy** configurados correctamente
- ✅ **SSL terminado en Caddy**, no en Django

### Dominios configurados:
- **Staging**: `qaramos.cadcc.cl`
- **Producción futura**: `ramos.cadcc.cl` (cuando se reemplace)

### Volúmenes persistentes:
- `./ramosdcc/data/` → Base de datos SQLite
- `./ramosdcc/logs/` → Logs de Django
- `./ramosdcc/media/` → Archivos subidos

## 🔍 **Troubleshooting**

### Verificar conectividad con Caddy:
```bash
# Desde dentro del container de Caddy
docker exec caddy curl -I http://ramosdcc:8000

# Verificar que ramosdcc esté en la red proxy
docker network inspect docker_proxy
```

### Ver configuración Django:
```bash
docker exec ramosdcc python -c "
from django.conf import settings
print(f'DEBUG: {settings.DEBUG}')
print(f'ALLOWED_HOSTS: {settings.ALLOWED_HOSTS}')
print(f'USE_X_FORWARDED_HOST: {settings.USE_X_FORWARDED_HOST}')
"
```

## 📊 **Coexistencia**

| Servicio | Contenedor | Dominio | Estado |
|---|---|---|---|
| `ramos` | ramos | ramos.cadcc.cl | **Actual (mantener)** |
| `ramosdcc` | ramosdcc | qaramos.cadcc.cl | **Nueva aplicación** |

Ambos servicios pueden correr simultáneamente sin problemas.
