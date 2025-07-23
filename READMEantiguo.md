# 2025-1-CC4401-grupo-6

Pasos a seguir para correr correctamente el proyecto:
- (Recomendado) Después de clonado el repositorio, crear un entorno virtual para instalar las librerias del proyecto usando los siguientes comandos (en windows)
  ```
  python -m venv myenv
  myenv\Bin\activate
  ```
- Luego, cambiar al directorio del proyecto e instalar las librerias con los siguientes comandos
  ```
  cd .\2025-1-CC4401-grupo-6\
  pip install -r requirements.txt
  ```
- Finalmente, cambiar al directorio de ramosDcc y correr el servidor con el siguiente comando
  ```
  cd .\ramosDcc\
  python .\manage.py runserver
  ```

La pagina web de RamosDCC permite a los usuarios crear cuentas, registrar opiniones sobre cursos que hayan cursado y visualizar estadísticas agregadas como promedios de dificultad y carga de tiempo al realizar el ramo. El backend está desarrollado en Django, usando un modelo relacional entre entidades clave.

## Modelo Entidad-Relación

### Usuario (`User`)

La entidad `User` extiende el modelo `AbstractUser` de Django, lo que le otorga funcionalidades integradas de autenticación y manejo de usuarios. A esto se le añade un campo personalizado:

- `name`: nombre(s) del usuario 
- `last_name`: apellidos
- `username`: nombre de usuario único
- `password`: contraseña
- `email`: correo electrónico
- `malla`: archivo subido por el usuario

La entidad `User` también tiene posibilidad de ser admin o normal, en particular el tipo admin funciona igual que uno normal, pero le suma funcionalidades de administrador, como administrar los ramos (agregar, eliminar y/o editar ramos).
Resumen de campos visibles en el formulario de creación de cuenta:

- Nombre de usuario (`username`)
- Contraseña (`password`)
- Nombre(s) (`name`)
- Apellidos (`last_name`)
- Email (`email`)
- Subida de archivo de malla (`malla`)

### Ramo (`Ramo`)

Representa un curso que este dentro de la malla universitaria. Esta entidad contiene información básica del ramo, junto con propiedades que permiten calcular estadísticas basadas en opiniones.

Campos definidos:

- `name`: nombre del ramo
- `code`: código único (clave lógica)
- `descripción`: descripción general
- `requisitos`: cursos previos necesarios
- `semestre`: semestre típico en que se dicta
- `credits`: número de créditos académicos
- `opinions`: retorna todas las opiniones que tienen el mismo `ramo_code` que el ramo actual
- `rate_dificulty()`: calcula el promedio de dificultad según las opiniones
- `rate_time()`: calcula el promedio de carga de tiempo según las opiniones


### Opinión (`Opinion`)

Representa la evaluación que un usuario hace sobre un ramo determinado.

Campos definidos:

- `ramo_code`: código del ramo evaluado (string, sirve como clave externa lógica)
- `rate_dificulty`: valoración de dificultad (entero entre 1 y 5)
- `rate_time`: valoración de carga de tiempo (entero entre 1 y 5)
- `opinion_text`: comentario libre

## Relaciones entre entidades

- Un `User` puede registrar múltiples `Opinion` (relación uno a muchos).
- Un `Ramo` puede tener múltiples `Opinion` asociadas (relación uno a muchos).
- En la implementación actual, `Opinion` se vincula a `Ramo` mediante el campo `ramo_code` (string).
