ARG PHP_VERSION=8.5
ARG ALPINE_VERSION=3.24

FROM php:${PHP_VERSION}-alpine${ALPINE_VERSION} AS build_essentials

RUN apk upgrade --no-cache && \
    apk add --no-cache \
    autoconf build-base zlib-dev linux-headers binutils libstdc++ && \
    pecl channel-update pecl.php.net

FROM build_essentials AS redis_ext

ARG REDIS_VERSION

RUN pecl install redis-$REDIS_VERSION && \
    strip --strip-debug $(php-config --extension-dir)/redis.so && \
    mv $(php-config --extension-dir)/redis.so /redis.so

FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY php-fpm.ini "$PHP_INI_DIR/php-fpm.ini"

RUN apk upgrade --no-cache && \
    apk add --no-cache --virtual .build-deps libzip-dev icu-dev libexif-dev linux-headers && \
    apk add --no-cache nginx gettext libstdc++ libzip icu-libs libexif

# PHP 8.5+ has opcache compiled in, and docker-php-ext-enable fails on it.
RUN docker-php-ext-install pcntl intl zip exif bcmath sockets && \
    { php -m | grep -q 'Zend OPcache' || docker-php-ext-enable opcache; }

# gd with jpeg/webp/freetype. Runtime libs stay; *-dev are removed in the same layer.
# PHP < 7.4 uses the old --with-*-dir flags.
RUN apk add --no-cache libpng libjpeg-turbo libwebp freetype \
    && apk add --no-cache --virtual .gd-build-deps libpng-dev libjpeg-turbo-dev libwebp-dev freetype-dev \
    && if php -r 'exit(PHP_VERSION_ID < 70400 ? 0 : 1);'; then \
         docker-php-ext-configure gd --with-jpeg-dir=/usr --with-png-dir=/usr --with-webp-dir=/usr --with-freetype-dir=/usr; \
       else \
         docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype; \
       fi \
    && docker-php-ext-install gd \
    && apk del .gd-build-deps

# Conditional installation of PDO driver
ARG PDO_DRIVER
RUN if [ -n "$PDO_DRIVER" ]; then \
        case "$PDO_DRIVER" in \
            mysql) apk add --no-cache --virtual .build-driver-deps mariadb-connector-c-dev && docker-php-ext-install pdo_mysql ;; \
            dblib) apk add --no-cache --virtual .build-driver-deps freetds-dev && apk add --no-cache freetds && docker-php-ext-install pdo_dblib ;; \
            firebird) echo >&2 "❌ Firebird PDO driver is not supported. Aborting."; exit 1 ;; \
#            firebird) apk add --no-cache --virtual .build-driver-deps firebird-dev && docker-php-ext-install pdo_firebird ;; \
            odbc) apk add --no-cache --virtual .build-driver-deps unixodbc-dev && apk add --no-cache unixodbc && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr && docker-php-ext-install pdo_odbc ;; \
            pgsql) apk add --no-cache --virtual .build-driver-deps postgresql-dev && apk add --no-cache libpq && docker-php-ext-install pdo_pgsql ;; \
            sqlite) echo "pdo_sqlite is bundled in the base image, nothing to install" ;; \
            *) echo "Unsupported PDO Driver: $PDO_DRIVER" && exit 1 ;; \
        esac; \
    else \
        echo "No PDO driver specified, installing pdo_mysql as default"; \
        apk add --no-cache --virtual .build-driver-deps mariadb-connector-c-dev && docker-php-ext-install pdo_mysql; \
    fi

COPY --from=redis_ext /redis.so /tmp/redis.so

RUN mv /tmp/redis.so $(php-config --extension-dir)/ && \
    docker-php-ext-enable redis

RUN docker-php-source delete && \
    apk del .build-deps && \
    { ! apk info -e .build-driver-deps >/dev/null || apk del .build-driver-deps; } && \
    rm -rf /var/cache/apk/* /tmp/*

ARG OPCACHE_FILE_NAME=opcache-php7.ini
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10" \
    PHP_OPCACHE_JIT="tracing" \
    PHP_OPCACHE_JIT_BUFFER_SIZE="128M"
COPY ${OPCACHE_FILE_NAME} "$PHP_INI_DIR/conf.d/opcache.ini"

ENV PHP_UPLOAD_MAX_FILESIZE="2M" \
    PHP_POST_MAX_SIZE="8M" \
    PHP_MEMORY_LIMIT="128M"
COPY php-ext.ini "$PHP_INI_DIR/conf.d/php-ext.ini"

COPY nginx.conf /etc/nginx/nginx.conf
ENV NGINX_ROOT="/app/public" \
    NGINX_CLIENT_MAX_BODY_SIZE="1M" \
    NGINX_WORKER_PROCESS="2"

WORKDIR /app/public
RUN rm -rf *

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD []

EXPOSE 80