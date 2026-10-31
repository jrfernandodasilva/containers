#!/bin/sh

set -e

# Non-root or read-only rootfs: run a custom CMD without rendering (PHP expands ${VAR} in .ini itself).
# A real write probe: `[ -w ]` reports writable for root on a read-only rootfs.
if [ "$#" -gt 0 ] && ! { touch /etc/nginx/.w && rm /etc/nginx/.w && touch "$PHP_INI_DIR/conf.d/.w" && rm "$PHP_INI_DIR/conf.d/.w"; } 2>/dev/null; then
    exec "$@"
fi

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
# exec so php-fpm is PID 1 and gets the stop signal (SIGQUIT, from the base image) from `docker stop`
exec php-fpm -F
