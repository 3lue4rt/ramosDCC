"""
Configuraciones de staging/debug para ramosDcc
Versión intermedia entre desarrollo y producción para qaramos.cadcc.cl
"""
from .settings import *
import os

# DEBUG activado para staging/debug
DEBUG = True

# Hosts permitidos - incluir el dominio de staging
ALLOWED_HOSTS = ['qaramos.cadcc.cl', 'localhost', '127.0.0.1']

# WhiteNoise middleware para servir archivos estáticos
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',  # Agregar WhiteNoise
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

# Security settings - más relajados para staging
SECURE_SSL_REDIRECT = False  # Caddy maneja SSL
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'SAMEORIGIN'  # Más permisivo para debug

# Static files configuration
STATIC_URL = '/static/'
STATIC_ROOT = '/app/staticfiles'

# Sobrescribir STATICFILES_DIRS para evitar el error
STATICFILES_DIRS = []

# WhiteNoise configuration
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

# Database - SQLite para simplicidad en staging
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/app/data/db.sqlite3',
    }
}

# Logging configuration - más verbose para debug
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
        'simple': {
            'format': '{levelname} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'file': {
            'level': 'DEBUG',  # Más detalle en logs
            'class': 'logging.FileHandler',
            'filename': '/app/logs/django-staging.log',
            'formatter': 'verbose',
        },
        'console': {
            'level': 'DEBUG',  # Debug en consola también
            'class': 'logging.StreamHandler',
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file', 'console'],
            'level': 'DEBUG',
            'propagate': True,
        },
        'opinion': {
            'handlers': ['file', 'console'],
            'level': 'DEBUG',
            'propagate': True,
        },
    },
    'root': {
        'handlers': ['console', 'file'],
        'level': 'DEBUG',
    },
}

# Configuraciones adicionales para debugging
INTERNAL_IPS = [
    '127.0.0.1',
    'localhost',
]

# Mostrar errores de SQL si es necesario
# Descomenta estas líneas si necesitas ver queries SQL
# LOGGING['loggers']['django.db.backends'] = {
#     'handlers': ['console'],
#     'level': 'DEBUG',
#     'propagate': False,
# }
