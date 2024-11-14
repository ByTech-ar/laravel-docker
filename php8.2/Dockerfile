# Set master image
FROM php:8.2-fpm-alpine
# docker run -it --rm php:8.4-fpm-alpine /bin/sh
LABEL maintainer="Andres Lacquaniti (hal@caseroft.com.ar)"

# Directorio de trabajo.
WORKDIR /app/

## el paquete shadow activa el usermod
# Instalo dependencias.

RUN apk update && apk add --no-cache \
    libzip-dev \
    zip \
    unzip \
    curl \
    nginx \
    supervisor \
    figlet \
    bash  \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    icu-dev \
    mariadb-connector-c-dev \
    $PHPIZE_DEPS


# Configurar e instalar las extensiones GD, pcntl , zip , intl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd pcntl zip intl pdo_mysql \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del $PHPIZE_DEPS

# Remove Cache
RUN rm -rf /var/cache/apk/*


## Copio archivos Supervisor.
COPY config/supervisord.conf /etc/supervisord.conf
COPY config/supervisor.d/* /etc/supervisor.d/

#Copio Archivo de Nginx
COPY config/nginx/default.conf /etc/nginx/http.d/default.conf


# Creo directorio de Nginx y ajusto permisos
RUN mkdir -p /run/nginx/ \
    && chown www-data:www-data /run/nginx/ \
    && chown -R www-data:www-data /var/lib/nginx/


## Cargoe el phpInfo -> el archivo se rescribe cunado se sube el laravel.
RUN mkdir -p /app/public/
RUN echo "<?php phpinfo(); " > /app/public/index.php

COPY config/docker-entrypoint.sh /docker-entrypoint.sh
RUN  sed -i 's/\r$//' /docker-entrypoint.sh
# Configuro punto de entrada y comando por defecto

ENTRYPOINT ["sh","/docker-entrypoint.sh"]
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]


EXPOSE 80

# Variables de entorno
ENV ENABLE_CRON 0
ENV ENABLE_NGINX 1
ENV ENABLE_PHP_FPM 1
ENV ENABLE_LARAVEL_HORIZON 0
ENV ENABLE_LARAVEL_WORKER 0
