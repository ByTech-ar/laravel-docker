# Set master image
FROM php:8.2-fpm-alpine
# docker run -it --rm php:8.4-fpm-alpine /bin/sh
LABEL maintainer="Andres Lacquaniti (hal@caseroft.com.ar)"

# Directorio de trabajo.
WORKDIR /app/

## el paquete shadow activa el usermod
# Instalo dependencias.

RUN apk update && apk add --no-cache \
    shadow \
    curl \
    nginx \
    supervisor \
    figlet \
    php-common \
    php-openssl \
    php-bz2 \
    php-mbstring \
    php-curl \
    php-xml \
    php-json \
    php-phar \
    php-zip \
    php-gd \
    php-dom \
    php-session \
    php-zlib \
    php-exif \
    php-bcmath \
    mysql-client \
    libc6-compat \
    bash

## Notas => el mysql-cliente lo necesito para usar el mysqldump para los bk

# ZIP:
RUN apk add --no-cache libzip-dev zlib-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install -j "$(nproc)" zip

# GD:
RUN apk add --no-cache gd jpeg-dev libpng-dev freetype-dev libjpeg-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# MYSQL PDO DRIVER:
RUN docker-php-ext-configure pdo_mysql \
    && docker-php-ext-install -j "$(nproc)" pdo_mysql

# INTL: 
RUN apk add --no-cache icu-dev \
    &&  docker-php-ext-configure intl \
    &&  docker-php-ext-install intl

# Remove Cache
RUN rm -rf /var/cache/apk/*

## Instalo Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 

## Copio archivos Supervisor.
COPY config/supervisord.conf /etc/supervisord.conf
COPY config/supervisor.d/* /etc/supervisor.d/

#Copio Archivo de Nginx
COPY config/nginx/default.conf /etc/nginx/http.d/default.conf


# Creo directorio de Nginx y ajusto permisos
RUN mkdir -p /run/nginx/ \
    && chown www-data:www-data /run/nginx/ \
    && chown -R www-data:www-data /var/lib/nginx/

# Use the default production configuration ($PHP_INI_DIR variable already set by the default image)
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

## Cargoe el phpInfo -> el archivo se rescribe cunado se sube el laravel.
RUN mkdir -p /app/public/
RUN echo "<?php phpinfo(); " > /app/public/index.php

COPY config/docker-entrypoint.sh /docker-entrypoint.sh
#RUN chmod +x /docker-entrypoint.sh
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
