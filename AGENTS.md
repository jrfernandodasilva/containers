# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## What this repo is

Docker images published to Docker Hub as `fernandojrdev/php-nginx`. Each image runs PHP-FPM and Nginx together on Alpine. There is no application code and no test suite. Your work here is image variants (PHP version × Alpine version × PDO driver) and their build config.

## Commands

```sh
make help                     # list every build/publish target
make build-php-nginx-8.4      # build one variant locally, tagged php-nginx:<ver>
make build-all                # build every variant
make publish-php-nginx-8.4    # docker tag + push to fernandojrdev/... + rmi
make -n publish-php-nginx     # dry run: show the push commands without running them

# check a build
docker run --rm php-nginx:8.4 php -v
docker run --rm php-nginx:8.4 php -m
```

Build one image by hand (build args are the whole interface):

```sh
docker build --build-arg PHP_VERSION=8.4 --build-arg ALPINE_VERSION=3.24 \
  --build-arg REDIS_VERSION=6.3.0 --build-arg PDO_DRIVER=pgsql \
  --build-arg OPCACHE_FILE_NAME=opcache-php8.ini -t php-nginx:8.4 ./php-nginx
```

## Two sources of truth: keep them in sync

The variant list is defined twice, by hand:

- `.github/workflows/docker-image-php-nginx.yml`: the `matrix.php_config` entries. This is the real release path. A push to `main` that touches `php-nginx/**` or the workflow builds `linux/amd64,linux/arm64` and pushes every entry.
- `Makefile`: one `build-*` and one `publish-*` target per variant, for local builds and manual publishing.

Adding, removing, or bumping a variant means editing both files. `php-nginx/README.md` uses `8.4-alpine3.XX` in its examples, so update it when the Alpine version of 8.4 changes. Each Makefile variant builds to its own local tag (`php-nginx:8.4-pgsql`), and `publish-*` maps it to the Hub tag. The `firebird`/`sqlite`/`odbc` targets exist but are left out of the aggregate targets, matching the commented-out CI entries (`firebird` always fails, see below).

Tag format, enforced by the workflow regex: `fernandojrdev/php-nginx:<major.minor[.patch]>-alpine<X.Y>[-<suffix>]`. The suffix is the PDO driver (`-pgsql`, `-dblib`) or `-grpc`. Most variants use a floating minor tag (`8.4`), which gets the newest patch on each build. One variant also pins an exact patch (for example `8.4.27`).

Before you bump versions, check that the base tag exists. `php:<ver>-fpm-alpine<X.Y>` must exist on Docker Hub, and not every PHP/Alpine pair does (newer patches only ship on recent Alpine releases; EOL PHP lines stop at an older Alpine). Query it with:
`curl -s "https://hub.docker.com/v2/repositories/library/php/tags?page_size=100&name=8.4."`

## Image architecture (`php-nginx/`)

- `Dockerfile`: multi-stage. A `build_essentials` stage, then a `redis_ext` stage that compiles `pecl redis-$REDIS_VERSION`. The final `php:<ver>-fpm-alpine<ver>` stage copies `redis.so` in, installs the core extensions, and installs one PDO driver chosen by `PDO_DRIVER` (default `mysql`; `firebird` is deliberately rejected). It then removes the build deps.
- `Dockerfile-grpc`: older fork of the same file that also builds `protobuf` (`PROTOBUF_VERSION`) and `grpc` (hardcoded `GRPC_VERSION`). Only the 8.0 `-grpc` variant uses it. Changes to `Dockerfile` do not reach it automatically.
- `OPCACHE_FILE_NAME`: picks `opcache-php8.ini` (PHP 8+) or `opcache-php7.ini`. 7.x variants pass an empty value or omit it.
- Runtime config is templated. `nginx.conf`, `opcache.ini` and `php-ext.ini` contain `${VAR}` placeholders. `entrypoint.sh` fills them from env vars with `envsubst` (`NGINX_ROOT`, `NGINX_CLIENT_MAX_BODY_SIZE`, `NGINX_WORKER_PROCESS`, `PHP_OPCACHE_*`, `PHP_UPLOAD_MAX_FILESIZE`, `PHP_POST_MAX_SIZE`, `PHP_MEMORY_LIMIT`; defaults are set in the Dockerfile `ENV` lines). When you add a tunable, add the `ENV` default, the placeholder in the ini/conf, and for nginx also the variable list in `entrypoint.sh`.
- `entrypoint.sh` always renders the config first. With an empty `CMD` it runs `nginx -t`, starts nginx, then `exec php-fpm -F` (php-fpm becomes PID 1). With a non-empty `CMD` it runs that command instead of nginx/php-fpm.
- Default workdir and web root: `/app/public`, port 80.

## Conventions

Commits use Conventional Commits with a scope, e.g. `build(dockerfile): ...`, `chore(makefile): ...`, `build(workflow): ...`.
