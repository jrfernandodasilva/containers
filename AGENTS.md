# AGENTS.md

## What this repo is

Docker images published to Docker Hub as `fernandojrdev/php-nginx`. Each image runs PHP-FPM and Nginx together on Alpine. There is no application code and no test suite. Your work here is image variants (PHP version × Alpine version × PDO driver) and their build config.

## Publishing is public

`make publish-*` and any push to `main` that touches `php-nginx/**` or the workflow push to the public Hub repo. Run them only when asked. Preview with `make -n`.

## Commands

```sh
make build-php-nginx-8.4         # build one variant locally
make -n build-php-nginx-8.4-pgsql # show the exact docker build (args, local tag) for a variant
make build-all                   # build every variant that CI publishes
make -n publish-php-nginx        # show the tag/push commands without running them

# check a build: version, and that every extension loads (no "Unable to load dynamic library")
docker run --rm php-nginx:8.4 php -v
docker run --rm php-nginx:8.4-pgsql php -m
```

To build by hand, copy the command from `make -n` instead of writing your own. The local tag must be the one the matching `publish-*` target expects (`php-nginx:8.4-pgsql`). A wrong tag gets the image pushed under another variant's name.

Local builds are host-arch only. CI also builds `linux/arm64`, so arm64-only failures show up only in CI.

The shell is zsh: an unquoted `$VAR` is not word-split, so `for t in $TAGS` runs once. Use an array (`T=(a b); for t in "${T[@]}"`) or list the items inline.

## Two sources of truth: keep them in sync

The variant list is defined twice, by hand:

- `.github/workflows/docker-image-php-nginx.yml`: the `matrix.php_config` entries. This is the real release path. It builds `linux/amd64,linux/arm64` and pushes every entry.
- `Makefile`: one `build-*` and one `publish-*` target per variant, for local builds and manual publishing.

Adding, removing, or bumping a variant means editing both files. `php-nginx/README.md` uses `8.4-alpine3.XX` in its examples, so update it when the Alpine version of 8.4 changes. The `firebird`/`sqlite`/`odbc` targets exist but are left out of the aggregate targets, matching the commented-out CI entries (`firebird` always fails, see below).

Tag format, enforced by the workflow regex: `fernandojrdev/php-nginx:<major.minor[.patch]>-alpine<X.Y>[-<suffix>]`. The suffix is lowercase letters only: the PDO driver (`-pgsql`, `-dblib`) or `-grpc`. Most variants use a floating minor tag (`8.4`), which gets the newest patch on each build. One variant also pins an exact patch.

Before you bump versions, check that both base tags exist: `php:<ver>-alpine<X.Y>` (used by the redis build stage) and `php:<ver>-fpm-alpine<X.Y>`. Not every PHP/Alpine pair exists. Newer patches only ship on recent Alpine releases, and EOL PHP lines stop at an older Alpine; for example `8.4.27-fpm-alpine3.22` does not exist. Check one tag with:
`curl -sf -o /dev/null https://hub.docker.com/v2/repositories/library/php/tags/<tag> && echo ok`

## Image architecture (`php-nginx/`)

- `Dockerfile`: multi-stage. A `build_essentials` stage, then a `redis_ext` stage that compiles `pecl redis-$REDIS_VERSION`. The final `php:<ver>-fpm-alpine<ver>` stage copies `redis.so` in, installs the core extensions, and installs one PDO driver chosen by `PDO_DRIVER` (default `mysql`; `firebird` is deliberately rejected). It then removes the build deps (`.build-deps`, `.build-driver-deps`), so a driver that links a shared lib must also `apk add` its runtime package outside the virtual (`libpq`, `freetds`, `unixodbc`). Otherwise `php -m` warns `Unable to load dynamic library`. `pdo_sqlite` is already in the base image, so the `sqlite` driver installs nothing.
- `Dockerfile-grpc`: older fork of the same file that also builds `protobuf` (`PROTOBUF_VERSION`) and `grpc` (hardcoded `GRPC_VERSION`). Only the 8.0 `-grpc` variant uses it. Changes to `Dockerfile` do not reach it automatically. It lacks the runtime-lib fix and accepts `firebird`, so only `PDO_DRIVER=mysql` is safe there.
- `OPCACHE_FILE_NAME`: `opcache-php8.ini` for PHP 8+, `opcache-php7.ini` for 7.x. Never pass it empty: `COPY` then copies the whole build context into a directory named `opcache.ini`, and the container exits at start with `envsubst: error while reading "standard input": Is a directory`.
- Runtime config is templated. `nginx.conf`, `opcache.ini` and `php-ext.ini` contain `${VAR}` placeholders. `entrypoint.sh` fills them from env vars with `envsubst`. The ini files are substituted with every env var. `nginx.conf` uses an allowlist (`NGINX_ROOT`, `NGINX_CLIENT_MAX_BODY_SIZE`, `NGINX_WORKER_PROCESS`), because it also contains nginx's own `$uri`-style variables. A `${VAR}` left off that list stays literal in the rendered config. When you add a tunable, add the `ENV` default in the Dockerfile and the placeholder in the ini/conf; for nginx, also add it to the list in `entrypoint.sh`. `PHP_OPCACHE_BLACKLIST_FILENAME` has no `ENV` default and renders empty.
- `entrypoint.sh` always renders the config first. With an empty `CMD` it runs `nginx -t`, starts nginx, then `exec php-fpm -F` (php-fpm becomes PID 1). With a non-empty `CMD` it runs that command instead of nginx/php-fpm.
- Default workdir and web root: `/app/public`, port 80.
