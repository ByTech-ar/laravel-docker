# Descripción

Este repositorio contiene archivos de configuración para automatizar el proceso de construcción y despliegue de imágenes Docker utilizando GitLab CI/CD. Las imágenes Docker se construyen para diferentes versiones de PHP (8.2) y se almacenan en el registro de GitLab.

## Pasos

El proceso de construcción se divide en varias etapas (stages) definidas en el archivo `.gitlab-ci.yml`. A continuación se describen las etapas y los pasos asociados:

1. **Etapa de Construcción (build)**
   - Esta etapa es responsable de construir las imágenes Docker para las diferentes versiones de PHP.

## Configuraciones

En el archivo `.gitlab-ci.yml`, se definen las siguientes configuraciones:

- **Servicios utilizados:** Se utiliza el servicio `docker:dind` (Docker in Docker) para ejecutar las tareas de construcción de imágenes Docker dentro de un contenedor Docker.
- **Variables de entorno:** Se utilizan variables de entorno para definir el nombre de las imágenes Docker y las credenciales de inicio de sesión en el registro de GitLab.
  - `CI_REGISTRY_USER`: Usuario para iniciar sesión en el registro de GitLab.
  - `CI_REGISTRY_PASSWORD`: Contraseña para iniciar sesión en el registro de GitLab.
  - `CI_REGISTRY_IMAGE`: Dirección del registro de GitLab donde se almacenarán las imágenes Docker.

## Pasos de Construcción

Se definen múltiples pasos de construcción para cada versión de PHP:

4. **Construcción de PHP 8.2 (`build_82`):**
   - Se construye la imagen Docker utilizando el archivo `./php8.2/dockerfile`.
   - La imagen se etiqueta como `$CI_REGISTRY_IMAGE:php83` y se sube al registro de GitLab.
