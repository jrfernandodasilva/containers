#!/bin/sh

set -e

exec "$@"

envsubst '$NGINX_ROOT,$NGINX_CLIENT_MAX_BODY_SIZE,$NGINX_WORKER_PROCESS' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf.tmp
mv /etc/nginx/nginx.conf.tmp /etc/nginx/nginx.conf
nginx -t

envsubst < "$PHP_INI_DIR/conf.d/opcache.ini" > "$PHP_INI_DIR/conf.d/opcache.ini.tmp"
mv "$PHP_INI_DIR/conf.d/opcache.ini.tmp" "$PHP_INI_DIR/conf.d/opcache.ini"

envsubst < "$PHP_INI_DIR/conf.d/php-ext.ini" > "$PHP_INI_DIR/conf.d/php-ext.ini.tmp"
mv "$PHP_INI_DIR/conf.d/php-ext.ini.tmp" "$PHP_INI_DIR/conf.d/php-ext.ini"

nginx; php-fpm -F