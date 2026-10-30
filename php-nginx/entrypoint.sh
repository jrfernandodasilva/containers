#!/bin/sh

set -e

envsubst '$NGINX_ROOT,$NGINX_CLIENT_MAX_BODY_SIZE,$NGINX_WORKER_PROCESS' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf.tmp
rm /etc/nginx/nginx.conf
mv /etc/nginx/nginx.conf.tmp /etc/nginx/nginx.conf

envsubst < "$PHP_INI_DIR/conf.d/opcache.ini" > "$PHP_INI_DIR/conf.d/opcache.ini.tmp"
mv "$PHP_INI_DIR/conf.d/opcache.ini.tmp" "$PHP_INI_DIR/conf.d/opcache.ini"

envsubst < "$PHP_INI_DIR/conf.d/php-ext.ini" > "$PHP_INI_DIR/conf.d/php-ext.ini.tmp"
mv "$PHP_INI_DIR/conf.d/php-ext.ini.tmp" "$PHP_INI_DIR/conf.d/php-ext.ini"

# A custom CMD (worker, CLI, shell) runs in place of the web stack, with the rendered config.
if [ "$#" -gt 0 ]; then
    exec "$@"
fi

nginx -t
nginx
# exec so php-fpm is PID 1 and gets the SIGTERM from `docker stop`
exec php-fpm -F
