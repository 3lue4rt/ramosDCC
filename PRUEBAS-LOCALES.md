# 🧪 Pruebas Locales - RamosDCC

Este directorio contiene todo lo necesario para probar la aplicación RamosDCC localmente antes del despliegue en producción.

## 🚀 Inicio Rápido

### Windows (PowerShell)
```powershell
.\test-local.ps1
```

### Linux/Mac (Bash)
```bash
chmod +x test-local.sh
./test-local.sh
```

Luego abre http://localhost:8500 en tu navegador.

## 📋 Archivos de Configuración Local

- **`docker-compose.local.yml`** - Configuración Docker para desarrollo local
- **`Dockerfile.local`** - Imagen Docker optimizada para desarrollo
- **`entrypoint-local.sh`** - Script de entrada que usa Gunicorn con --reload (idéntico a producción)
- **`settings_local.py`** - Configuración Django para desarrollo (con DEBUG=True)
- **`test-local.ps1`** - Script automatizado para Windows
- **`test-local.sh`** - Script automatizado para Linux/Mac

## 🔧 Comandos Útiles

```bash
# Ver logs en tiempo real
docker-compose -f docker-compose.local.yml logs -f

# Acceder al contenedor
docker-compose -f docker-compose.local.yml exec ramos-django bash

# Crear superusuario
docker-compose -f docker-compose.local.yml exec ramos-django python manage.py createsuperuser

# Ejecutar migraciones manualmente
docker-compose -f docker-compose.local.yml exec ramos-django python manage.py migrate

# Recopilar archivos estáticos
docker-compose -f docker-compose.local.yml exec ramos-django python manage.py collectstatic

# Parar el servicio
docker-compose -f docker-compose.local.yml down

# Parar y limpiar volúmenes
docker-compose -f docker-compose.local.yml down -v
```

## 🐛 Resolución de Problemas

### El contenedor no inicia
```bash
# Ver logs de construcción
docker-compose -f docker-compose.local.yml build --no-cache

# Ver logs del contenedor
docker-compose -f docker-compose.local.yml logs ramos-django
```

### Error de permisos en Linux/Mac
```bash
# Dar permisos a los scripts
chmod +x test-local.sh
chmod +x entrypoint-local.sh
```

### Puerto 8500 ocupado
```bash
# Ver qué proceso está usando el puerto
# Windows:
netstat -ano | findstr :8500

# Linux/Mac:
lsof -i :8500

# Cambiar el puerto en docker-compose.local.yml:
ports:
  - "8501:8500"  # Usar puerto 8501 localmente
```

### Base de datos corrupta
```bash
# Eliminar base de datos y empezar de nuevo
docker-compose -f docker-compose.local.yml down
rm -rf data/
mkdir data
docker-compose -f docker-compose.local.yml up -d
```

## 🔄 Diferencias con Producción

| Aspecto | Local | Producción |
|---------|-------|------------|
| **DEBUG** | True | False |
| **Servidor** | Gunicorn + --reload | Gunicorn |
| **Puerto** | 8500 (expuesto) | 8500 (interno) |
| **SSL** | No | Sí (Caddy + Let's Encrypt) |
| **Dominio** | localhost | ramos.cadcc.cl |
| **Logs** | Verbosos | Producción |
| **Proxy** | Directo | Caddy reverse proxy |

## ✅ Lista de Verificación

Antes de desplegar a producción, asegúrate de que:

- [ ] La aplicación inicia sin errores
- [ ] La página principal se carga correctamente
- [ ] Los archivos estáticos (CSS/JS) se sirven correctamente
- [ ] Las migraciones se ejecutan sin problemas
- [ ] El login/registro funciona (si aplica)
- [ ] No hay errores en los logs
- [ ] La aplicación responde en http://localhost:8500

## 📝 Notas

- La base de datos se guarda en `./data/db.sqlite3`
- Los archivos estáticos se sirven con WhiteNoise
- El modo DEBUG está activado para mejor debugging
- Se usa Gunicorn con --reload para hot-reload (similar a runserver)
