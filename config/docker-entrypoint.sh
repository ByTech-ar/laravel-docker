#!/bin/sh
set -e


# Cron siempre esta activado, solo si se pasa el ENABLE_CRON Activa el schedule:run
mv /etc/supervisor.d/cron.conf /etc/supervisor.d/cron.conf


# Habilitar servicios según las variables de entorno
# Habilitar el cron de Laravel
if [ "$ENABLE_CRON" = "1" ]; then
    echo "* * * * * php /app/artisan schedule:run >> /dev/null 2>&1" >> /etc/crontabs/www-data
fi

if [ "$ENABLE_NGINX" = "1" ]; then
    cp /etc/supervisor.d/nginx.disable /etc/supervisor.d/nginx.conf
fi

if [ "$ENABLE_PHP_FPM" = "1" ]; then
    cp /etc/supervisor.d/php-fpm.disable /etc/supervisor.d/php-fpm.conf
fi

# Habilitar Laravel Horizon
if [ "$ENABLE_LARAVEL_HORIZON" = "1" ]; then
    cp /etc/supervisor.d/horizon.disable /etc/supervisor.d/horizon.conf
fi

# Habilitar trabajadores de cola de Laravel
if [ "$ENABLE_LARAVEL_WORKER" = "1" ]; then
    cp /etc/supervisor.d/worker.disable /etc/supervisor.d/worker.conf
fi

# Habilitar trabajadores de cola de Laravel
if [ "$ENABLE_OCTANE" = "1" ]; then
    cp /etc/supervisor.d/octane.disable /etc/supervisor.d/octane.conf
fi


# Corregir permisos del directorio /app/storage/
if [ -d "/app/storage/" ]; then
    chown www-data:www-data -R /app/storage/
fi

# Ejecutar comandos de Artisan si existe el archivo /app/artisan
if [ -f "/app/artisan" ]; then
    cd /app/
    chmod +x artisan
    # Limpiar caché y configuración de Laravel
    php artisan cache:clear
    php artisan config:clear
    php artisan route:clear
    php artisan view:clear
    php artisan about
fi

# Ejecutar el comando pasado como argumento
exec "$@"
