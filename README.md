# ramosDCC

Sistema de evaluación y comentarios de cursos del Departamento de Ciencias de la Computación (DCC) de la Universidad de Chile.

## 🎯 **Descripción**

ramosDCC es una aplicación web desarrollada en Django que permite a los estudiantes del DCC evaluar y comentar sobre los cursos que han tomado, facilitando la toma de decisiones académicas para futuros estudiantes.

## ⚡ **Características**

- 📝 **Evaluaciones de cursos** con sistema de likes
- 👤 **Gestión de usuarios** con autenticación
- 📊 **Sistema de opiniones** estructurado
- 🎨 **Interfaz responsiva** con CSS moderno
- 🔒 **Configuración de seguridad** para producción

## 🚀 **Despliegue**

Este proyecto está configurado para múltiples entornos de despliegue:

- **🌐 Servidor CaDCC** (Recomendado): Con Caddy reverse proxy
- **🧪 Staging**: Para testing con debugging activado  
- **📦 Producción**: Para despliegue standalone

Ver [DEPLOY.md](DEPLOY.md) para instrucciones detalladas.

## 🛠️ **Stack Tecnológico**

- **Backend**: Django 3.2.25
- **Frontend**: HTML, CSS, JavaScript
- **Base de datos**: SQLite (configurable a PostgreSQL)
- **Servidor web**: Gunicorn + WhiteNoise
- **Contenedores**: Docker
- **Proxy**: Caddy (en servidor CaDCC)

## 📁 **Estructura del Proyecto**

```
ramosDCC/
├── ramosDcc/                 # Aplicación Django
│   ├── opinion/             # App principal
│   ├── ramosDcc/           # Configuración
│   └── manage.py
├── Dockerfile              # Para despliegue standalone
├── Dockerfile.caddy        # Para servidor CaDCC
├── requirements.txt        # Dependencias
└── deploy-*.sh            # Scripts de despliegue
```

## 🔧 **Desarrollo Local**

```bash
# Clonar repositorio
git clone https://github.com/3lue4rt/ramosDCC.git
cd ramosDCC

# Crear entorno virtual
python -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate   # Windows

# Instalar dependencias
pip install -r requirements.txt

# Configurar base de datos
cd ramosDcc
python manage.py migrate

# Ejecutar servidor de desarrollo
python manage.py runserver
```

## 📄 **Licencia**

Ver [LICENSE](LICENSE) para más detalles.

## 👥 **Contribución**

Este proyecto es parte de la infraestructura del CaDCC de la Universidad de Chile.
