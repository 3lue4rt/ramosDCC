# Instrucciones de Despliegue - RamosDCC

## 🧪 Pruebas Locales (RECOMENDADO)

Antes de desplegar al servidor, es altamente recomendado probar localmente:

### Opción 1: Script automático (Windows)
```powershell
.\test-local.ps1
```

### Opción 2: Script automático (Linux/Mac)
```bash
chmod +x test-local.sh
./test-local.sh
```

### Opción 3: Comandos manuales
```bash
# 1. Crear directorio de datos
mkdir -p data

# 2. Construir imagen local
docker-compose -f docker-compose.local.yml build

# 3. Iniciar contenedor
docker-compose -f docker-compose.local.yml up -d

# 4. Ver logs
docker-compose -f docker-compose.local.yml logs -f

# 5. Crear superusuario (opcional)
docker-compose -f docker-compose.local.yml exec ramos-django python manage.py createsuperuser

# 6. Parar cuando termines
docker-compose -f docker-compose.local.yml down
```

### Verificar funcionamiento
- Abre http://localhost:8500 en tu navegador
- Verifica que se carguen los archivos estáticos (CSS/JS)
- Prueba el login/registro si aplica
- Revisa los logs en busca de errores

---

## 🚀 Preparación del proyecto para servidor

1. **Subir archivos al servidor**
   - Copia toda la carpeta del proyecto al directorio `./ramos/` en el servidor donde está el docker-compose.yml

2. **Configurar el Caddyfile**
   - Agrega la configuración del archivo `Caddyfile-config.txt` al archivo `./caddy/Caddyfile` del servidor
   - La configuración debe verse así:
   ```
   ramos.cadcc.cl {
       reverse_proxy ramos-django:8000
       log {
           output file /logs/ramos.cadcc.cl.log
       }
   }
   ```

3. **Agregar el servicio al docker-compose.yml**
   - Agrega la configuración del archivo `docker-compose-service.yml` al archivo docker-compose.yml principal del servidor
   - La configuración debe ir bajo la sección `services:`

4. **Generar una clave secreta segura**
   ```bash
   python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
   ```
   - Reemplaza `tu_clave_secreta_aqui_cambiar_en_produccion` en el docker-compose.yml con la clave generada

## Comandos de despliegue

1. **Construir la imagen**
   ```bash
   docker-compose build ramos-django
   ```

2. **Iniciar el servicio**
   ```bash
   docker-compose up -d ramos-django
   ```

3. **Reiniciar Caddy para aplicar la nueva configuración**
   ```bash
   docker-compose restart caddy
   ```

## Verificación

1. Verificar que el contenedor esté corriendo:
   ```bash
   docker-compose ps ramos-django
   ```

2. Ver los logs del contenedor:
   ```bash
   docker-compose logs ramos-django
   ```

3. Verificar que la aplicación responda:
   ```bash
   curl -I https://ramos.cadcc.cl
   ```

## Comandos útiles de mantenimiento

- **Ver logs en tiempo real:**
  ```bash
  docker-compose logs -f ramos-django
  ```

- **Reiniciar el servicio:**
  ```bash
  docker-compose restart ramos-django
  ```

- **Actualizar la aplicación:**
  ```bash
  docker-compose stop ramos-django
  docker-compose build ramos-django
  docker-compose up -d ramos-django
  ```

- **Ejecutar comandos Django dentro del contenedor:**
  ```bash
  docker-compose exec ramos-django python manage.py [comando]
  ```

- **Crear superusuario:**
  ```bash
  docker-compose exec ramos-django python manage.py createsuperuser
  ```

## Estructura de archivos esperada en el servidor

```
./ramos/
├── Dockerfile
├── entrypoint.sh
├── requirements.txt
├── .dockerignore
└── ramosDcc/
    ├── manage.py
    ├── ramosDcc/
    │   ├── settings.py
    │   ├── settings_production.py
    │   ├── urls.py
    │   └── wsgi.py
    └── opinion/
        ├── models.py
        ├── views.py
        ├── static/
        └── ...
```

## Notas importantes

- La aplicación usará WhiteNoise para servir archivos estáticos
- La base de datos SQLite se guardará en `./ramos/data/db.sqlite3`
- Los logs de acceso se guardarán en `/logs/ramos.cadcc.cl.log`
- El certificado SSL se generará automáticamente via Let's Encrypt
- La aplicación estará disponible en https://ramos.cadcc.cl
