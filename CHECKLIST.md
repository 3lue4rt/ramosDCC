# Checklist de Despliegue - RamosCC

## Antes del Despliegue

### ✅ Archivos Creados/Modificados
- [ ] `Dockerfile` - Configuración de la imagen Docker
- [ ] `start.sh` - Script de inicio para producción
- [ ] `requirements.txt` - Actualizado con gunicorn
- [ ] `ramosDcc/settings_production.py` - Configuraciones de producción
- [ ] `.dockerignore` - Optimización de construcción
- [ ] `docker-compose-config.yml` - Configuración para el servidor
- [ ] `DESPLIEGUE.md` - Documentación completa
- [ ] `test-docker.ps1` - Script de prueba local (Windows)

### ✅ Verificaciones Locales
- [ ] Probar la aplicación localmente con `python manage.py runserver`
- [ ] Verificar que no hay errores en las migraciones
- [ ] Probar la construcción Docker: `docker build -t ramosdcc:test .`
- [ ] Probar el contenedor localmente usando `test-docker.ps1`
- [ ] Verificar que la aplicación responde en http://localhost:8000

### ✅ Configuraciones de Producción
- [ ] `DEBUG = False` en settings_production.py
- [ ] `ALLOWED_HOSTS` configurado correctamente
- [ ] Archivos estáticos configurados
- [ ] Base de datos configurada (SQLite en /app/data/)
- [ ] Logging configurado

## Durante el Despliegue

### ✅ En el Servidor
- [ ] Subir archivos al servidor en `/ruta/Docker/ramos/`
- [ ] Verificar que el dominio `ramos.cadcc.cl` apunta al servidor
- [ ] Agregar configuración al `docker-compose.yml` del servidor
- [ ] Ejecutar `docker-compose build ramos`
- [ ] Ejecutar `docker-compose up -d ramos`

### ✅ Verificaciones Post-Despliegue
- [ ] Verificar logs: `docker-compose logs ramos`
- [ ] Verificar que el contenedor está corriendo: `docker-compose ps ramos`
- [ ] Probar acceso web: https://ramos.cadcc.cl
- [ ] Verificar certificado SSL automático
- [ ] Probar funcionalidades principales de la aplicación

### ✅ Configuración Inicial (Opcional)
- [ ] Crear superusuario si es necesario
- [ ] Cargar datos iniciales si los hay
- [ ] Configurar cron jobs si son necesarios

## Después del Despliegue

### ✅ Monitoreo
- [ ] Configurar alertas de monitoreo
- [ ] Documentar procedimientos de backup
- [ ] Establecer rutinas de mantenimiento
- [ ] Documentar procedimientos de actualización

### ✅ Backup y Mantenimiento
- [ ] Configurar backup automático de `/app/data/`
- [ ] Documentar procedimiento de rollback
- [ ] Establecer rutina de limpieza de logs
- [ ] Documentar acceso admin y procedimientos

## Comandos de Referencia Rápida

```bash
# Construir y desplegar
docker-compose build ramos
docker-compose up -d ramos

# Ver logs
docker-compose logs -f ramos

# Ejecutar comandos Django
docker-compose exec ramos python manage.py <comando> --settings=ramosDcc.settings_production

# Parar servicio
docker-compose stop ramos

# Actualizar aplicación
docker-compose stop ramos && docker-compose build ramos && docker-compose up -d ramos

# Backup base de datos
cp Docker/ramos/data/db.sqlite3 backup-$(date +%Y%m%d).sqlite3
```

## Contactos de Emergencia
- Administrador de sistemas CaDCC: sistemas@cadcc.cl
- Desarrollador: [tu-email]

---
**Fecha de despliegue**: ___________
**Responsable**: ___________
**Versión**: ___________
