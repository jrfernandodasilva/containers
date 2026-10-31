.PHONY: help

GREEN := $(shell tput setaf 2)
RESET := $(shell tput sgr0)

help:
	@echo "Available commands:"
	@echo "  $(GREEN)help$(RESET): See this help"
	@echo "  $(GREEN)build-all$(RESET): Build all PHP-NGINX images"
	@echo "  $(GREEN)build-and-publish-all$(RESET): Build and publish all PHP-NGINX images"
	@echo "  $(GREEN)build-php-nginx$(RESET): Build PHP-NGINX images"
	@echo "  $(GREEN)publish-php-nginx$(RESET): Publish PHP-NGINX images"
	@echo "  $(GREEN)build-php-nginx-8$(RESET): Build PHP-NGINX 8.x images"
	@echo "  $(GREEN)build-php-nginx-7$(RESET): Build PHP-NGINX 7.x images"
	@echo "  $(GREEN)publish-php-nginx-8$(RESET): Publish PHP-NGINX 8.x images"
	@echo "  $(GREEN)publish-php-nginx-7$(RESET): Publish PHP-NGINX 7.x images"
	@echo "  $(GREEN)build-php-nginx-8.5$(RESET): Build PHP-NGINX 8.5 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)build-php-nginx-8.4$(RESET): Build PHP-NGINX 8.4 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)build-php-nginx-8.4-pgsql$(RESET): Build PHP-NGINX 8.4 image with PostgreSQL PDO driver"
	@echo "  $(GREEN)build-php-nginx-8.4-firebird$(RESET): Build PHP-NGINX 8.4 image with Firebird PDO driver"
	@echo "  $(GREEN)build-php-nginx-8.4-sqlite$(RESET): Build PHP-NGINX 8.4 image with SQLite PDO driver"
	@echo "  $(GREEN)build-php-nginx-8.4-odbc$(RESET): Build PHP-NGINX 8.4 image with ODBC PDO driver"
	@echo "  $(GREEN)build-php-nginx-8.4-dblib$(RESET): Build PHP-NGINX 8.4 image with DBLIB PDO driver"
	@echo "  $(GREEN)build-php-nginx-8.3$(RESET): Build PHP-NGINX 8.3 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)build-php-nginx-8.2$(RESET): Build PHP-NGINX 8.2 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)build-php-nginx-8.1$(RESET): Build PHP-NGINX 8.1 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)build-php-nginx-8.0$(RESET): Build PHP-NGINX 8.0 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)build-php-nginx-8.0-grpc$(RESET): Build PHP-NGINX 8.0 image with MySQL and SQLite PDO drivers and gRPC support"
	@echo "  $(GREEN)publish-php-nginx-8.5$(RESET): Publish on DockerHub the PHP-NGINX 8.5 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)publish-php-nginx-8.4$(RESET): Publish on DockerHub the PHP-NGINX 8.4 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)publish-php-nginx-8.4-pgsql$(RESET): Publish on DockerHub the PHP-NGINX 8.4 image with PostgreSQL PDO driver"
	@echo "  $(GREEN)publish-php-nginx-8.4-dblib$(RESET): Publish on DockerHub the PHP-NGINX 8.4 image with DBLIB PDO driver"
	@echo "  $(GREEN)publish-php-nginx-8.3$(RESET): Publish on DockerHub the PHP-NGINX 8.3 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)publish-php-nginx-8.2$(RESET): Publish on DockerHub the PHP-NGINX 8.2 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)publish-php-nginx-8.1$(RESET): Publish on DockerHub the PHP-NGINX 8.1 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)publish-php-nginx-8.0$(RESET): Publish on DockerHub the PHP-NGINX 8.0 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)publish-php-nginx-8.0-grpc$(RESET): Publish on DockerHub the PHP-NGINX 8.0 image with MySQL and SQLite PDO drivers and gRPC support"
	@echo "  $(GREEN)build-php-nginx-7.4$(RESET): Build PHP-NGINX 7.4 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)build-php-nginx-7.4-pgsql$(RESET): Build PHP-NGINX 7.4 image with PostgreSQL PDO driver"
	@echo "  $(GREEN)build-php-nginx-7.4-firebird$(RESET): Build PHP-NGINX 7.4 image with Firebird PDO driver"
	@echo "  $(GREEN)build-php-nginx-7.4-sqlite$(RESET): Build PHP-NGINX 7.4 image with SQLite PDO driver"
	@echo "  $(GREEN)build-php-nginx-7.4-odbc$(RESET): Build PHP-NGINX 7.4 image with ODBC PDO driver"
	@echo "  $(GREEN)build-php-nginx-7.4-dblib$(RESET): Build PHP-NGINX 7.4 image with DBLIB PDO driver"	
	@echo "  $(GREEN)build-php-nginx-7.3$(RESET): Build PHP-NGINX 7.3 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)build-php-nginx-7.2$(RESET): Build PHP-NGINX 7.2 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)publish-php-nginx-7.4$(RESET): Publish on DockerHub the PHP-NGINX 7.4 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)publish-php-nginx-7.4-pgsql$(RESET): Publish on DockerHub the PHP-NGINX 7.4 image with PostgreSQL PDO driver"
	@echo "  $(GREEN)publish-php-nginx-7.4-dblib$(RESET): Publish on DockerHub the PHP-NGINX 7.4 image with DBLIB PDO driver"
	@echo "  $(GREEN)publish-php-nginx-7.3$(RESET): Publish on DockerHub the PHP-NGINX 7.3 image with MySQL and SQLite PDO drivers"
	@echo "  $(GREEN)publish-php-nginx-7.2$(RESET): Publish on DockerHub the PHP-NGINX 7.2 image with MySQL and SQLite PDO drivers"
	@echo
	@echo "Useful links:"
	@echo "  $(GREEN)PHP Docker Tags$(RESET):       https://hub.docker.com/_/php/tags"
	@echo "  $(GREEN)PECL Redis Package$(RESET):    https://pecl.php.net/package/redis"
	@echo "  $(GREEN)PECL Protobuf Package$(RESET): https://pecl.php.net/package/protobuf"
	@echo "  $(GREEN)PECL gRPC Package$(RESET):     https://pecl.php.net/package/gRPC"

# ALL
build-all: build-php-nginx
	@echo "done"

build-and-publish-all: build-php-nginx publish-php-nginx
	@echo "done"

build-php-nginx: build-php-nginx-8 build-php-nginx-7

publish-php-nginx: publish-php-nginx-8 publish-php-nginx-7

# PHP-NGINX 8.x
build-php-nginx-8: build-php-nginx-8.5 build-php-nginx-8.4  build-php-nginx-8.4-pgsql build-php-nginx-8.4-dblib build-php-nginx-8.3 build-php-nginx-8.2 build-php-nginx-8.1 build-php-nginx-8.0 build-php-nginx-8.0-grpc

publish-php-nginx-8: publish-php-nginx-8.5 publish-php-nginx-8.4 publish-php-nginx-8.4-pgsql publish-php-nginx-8.4-dblib publish-php-nginx-8.3 publish-php-nginx-8.2 publish-php-nginx-8.1 publish-php-nginx-8.0 publish-php-nginx-8.0-grpc

build-php-nginx-8.5:
	@docker build \
		--build-arg PHP_VERSION=8.5.12 \
		--build-arg ALPINE_VERSION=3.24 \
		--build-arg REDIS_VERSION=6.3.0 \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.5 \
		./php-nginx


build-php-nginx-8.4:
	@docker build \
		--build-arg PHP_VERSION=8.4.27 \
		--build-arg ALPINE_VERSION=3.24 \
		--build-arg REDIS_VERSION=6.3.0 \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.4 \
		./php-nginx

build-php-nginx-8.4-pgsql:
	@docker build \
		--build-arg PHP_VERSION=8.4.27 \
		--build-arg ALPINE_VERSION=3.24 \
		--build-arg REDIS_VERSION=6.3.0 \
		--build-arg PDO_DRIVER=pgsql \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.4-pgsql \
		./php-nginx

build-php-nginx-8.4-firebird:
	@docker build \
		--build-arg PHP_VERSION=8.4.27 \
		--build-arg ALPINE_VERSION=3.24 \
		--build-arg REDIS_VERSION=6.3.0 \
		--build-arg PDO_DRIVER=firebird \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.4-firebird \
		./php-nginx

build-php-nginx-8.4-sqlite:
	@docker build \
		--build-arg PHP_VERSION=8.4.27 \
		--build-arg ALPINE_VERSION=3.24 \
		--build-arg REDIS_VERSION=6.3.0 \
		--build-arg PDO_DRIVER=sqlite \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.4-sqlite \
		./php-nginx

build-php-nginx-8.4-odbc:
	@docker build \
		--build-arg PHP_VERSION=8.4.27 \
		--build-arg ALPINE_VERSION=3.24 \
		--build-arg REDIS_VERSION=6.3.0 \
		--build-arg PDO_DRIVER=odbc \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.4-odbc \
		./php-nginx

build-php-nginx-8.4-dblib:
	@docker build \
		--build-arg PHP_VERSION=8.4.27 \
		--build-arg ALPINE_VERSION=3.24 \
		--build-arg REDIS_VERSION=6.3.0 \
		--build-arg PDO_DRIVER=dblib \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.4-dblib \
		./php-nginx

build-php-nginx-8.3:
	@docker build \
		--build-arg PHP_VERSION=8.3.36 \
		--build-arg ALPINE_VERSION=3.24 \
		--build-arg REDIS_VERSION=6.1.0 \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.3 \
		./php-nginx

build-php-nginx-8.2:
	@docker build \
		--build-arg PHP_VERSION=8.2.35 \
		--build-arg ALPINE_VERSION=3.24 \
		--build-arg REDIS_VERSION=6.1.0 \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.2 \
		./php-nginx

build-php-nginx-8.1:
	@docker build \
		--build-arg PHP_VERSION=8.1.34 \
		--build-arg ALPINE_VERSION=3.22 \
		--build-arg REDIS_VERSION=6.1.0 \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.1 \
		./php-nginx

build-php-nginx-8.0:
	@docker build \
		--build-arg PHP_VERSION=8.0.30 \
		--build-arg ALPINE_VERSION=3.16 \
		--build-arg REDIS_VERSION=6.1.0 \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.0 \
		./php-nginx

build-php-nginx-8.0-grpc:
	@docker build \
		--build-arg PHP_VERSION=8.0.30 \
		--build-arg ALPINE_VERSION=3.16 \
		--build-arg PROTOBUF_VERSION=3.25.5 \
		--build-arg REDIS_VERSION=6.1.0 \
		--build-arg OPCACHE_FILE_NAME=opcache-php8.ini \
		-t php-nginx:8.0-grpc \
		-f php-nginx/Dockerfile-grpc \
		./php-nginx

publish-php-nginx-8.5:
	@docker tag php-nginx:8.5 fernandojrdev/php-nginx:8.5.12-alpine3.24
	@docker push fernandojrdev/php-nginx:8.5.12-alpine3.24
	@docker rmi fernandojrdev/php-nginx:8.5.12-alpine3.24

publish-php-nginx-8.4:
	@docker tag php-nginx:8.4 fernandojrdev/php-nginx:8.4.27-alpine3.24
	@docker push fernandojrdev/php-nginx:8.4.27-alpine3.24
	@docker rmi fernandojrdev/php-nginx:8.4.27-alpine3.24

publish-php-nginx-8.4-pgsql:
	@docker tag php-nginx:8.4-pgsql fernandojrdev/php-nginx:8.4.27-alpine3.24-pgsql
	@docker push fernandojrdev/php-nginx:8.4.27-alpine3.24-pgsql
	@docker rmi fernandojrdev/php-nginx:8.4.27-alpine3.24-pgsql

publish-php-nginx-8.4-dblib:
	@docker tag php-nginx:8.4-dblib fernandojrdev/php-nginx:8.4.27-alpine3.24-dblib
	@docker push fernandojrdev/php-nginx:8.4.27-alpine3.24-dblib
	@docker rmi fernandojrdev/php-nginx:8.4.27-alpine3.24-dblib

publish-php-nginx-8.3:
	@docker tag php-nginx:8.3 fernandojrdev/php-nginx:8.3.36-alpine3.24
	@docker push fernandojrdev/php-nginx:8.3.36-alpine3.24
	@docker rmi fernandojrdev/php-nginx:8.3.36-alpine3.24

publish-php-nginx-8.2:
	@docker tag php-nginx:8.2 fernandojrdev/php-nginx:8.2.35-alpine3.24
	@docker push fernandojrdev/php-nginx:8.2.35-alpine3.24
	@docker rmi fernandojrdev/php-nginx:8.2.35-alpine3.24

publish-php-nginx-8.1:
	@docker tag php-nginx:8.1 fernandojrdev/php-nginx:8.1.34-alpine3.22
	@docker push fernandojrdev/php-nginx:8.1.34-alpine3.22
	@docker rmi fernandojrdev/php-nginx:8.1.34-alpine3.22

publish-php-nginx-8.0:
	@docker tag php-nginx:8.0 fernandojrdev/php-nginx:8.0.30-alpine3.16
	@docker push fernandojrdev/php-nginx:8.0.30-alpine3.16
	@docker rmi fernandojrdev/php-nginx:8.0.30-alpine3.16

publish-php-nginx-8.0-grpc:
	@docker tag php-nginx:8.0-grpc fernandojrdev/php-nginx:8.0.30-alpine3.16-grpc
	@docker push fernandojrdev/php-nginx:8.0.30-alpine3.16-grpc
	@docker rmi fernandojrdev/php-nginx:8.0.30-alpine3.16-grpc

# PHP-NGINX 7.x
build-php-nginx-7: build-php-nginx-7.4 build-php-nginx-7.4-pgsql build-php-nginx-7.4-dblib build-php-nginx-7.3 build-php-nginx-7.2

publish-php-nginx-7: publish-php-nginx-7.4 publish-php-nginx-7.4-pgsql publish-php-nginx-7.4-dblib publish-php-nginx-7.3 publish-php-nginx-7.2

build-php-nginx-7.4:
	@docker build \
		--build-arg PHP_VERSION=7.4.33 \
		--build-arg ALPINE_VERSION=3.16 \
		--build-arg REDIS_VERSION=6.1.0 \
		-t php-nginx:7.4 \
		./php-nginx

build-php-nginx-7.4-pgsql:
	@docker build \
		--build-arg PHP_VERSION=7.4.33 \
		--build-arg ALPINE_VERSION=3.16 \
		--build-arg REDIS_VERSION=6.1.0 \
		--build-arg PDO_DRIVER=pgsql \
		-t php-nginx:7.4-pgsql \
		./php-nginx

build-php-nginx-7.4-firebird:
	@docker build \
		--build-arg PHP_VERSION=7.4.33 \
		--build-arg ALPINE_VERSION=3.16 \
		--build-arg REDIS_VERSION=6.1.0 \
		--build-arg PDO_DRIVER=firebird \
		-t php-nginx:7.4-firebird \
		./php-nginx

build-php-nginx-7.4-sqlite:
	@docker build \
		--build-arg PHP_VERSION=7.4.33 \
		--build-arg ALPINE_VERSION=3.16 \
		--build-arg REDIS_VERSION=6.1.0 \
		--build-arg PDO_DRIVER=sqlite \
		-t php-nginx:7.4-sqlite \
		./php-nginx

build-php-nginx-7.4-odbc:
	@docker build \
		--build-arg PHP_VERSION=7.4.33 \
		--build-arg ALPINE_VERSION=3.16 \
		--build-arg REDIS_VERSION=6.1.0 \
		--build-arg PDO_DRIVER=odbc \
		-t php-nginx:7.4-odbc \
		./php-nginx

build-php-nginx-7.4-dblib:
	@docker build \
		--build-arg PHP_VERSION=7.4.33 \
		--build-arg ALPINE_VERSION=3.16 \
		--build-arg REDIS_VERSION=6.1.0 \
		--build-arg PDO_DRIVER=dblib \
		-t php-nginx:7.4-dblib \
		./php-nginx

build-php-nginx-7.3:
	@docker build \
		--build-arg PHP_VERSION=7.3.33 \
		--build-arg ALPINE_VERSION=3.15 \
		--build-arg REDIS_VERSION=6.0.2 \
		-t php-nginx:7.3 \
		./php-nginx

build-php-nginx-7.2:
	@docker build \
		--build-arg PHP_VERSION=7.2.34 \
		--build-arg ALPINE_VERSION=3.12 \
		--build-arg REDIS_VERSION=6.0.2 \
		-t php-nginx:7.2 \
		./php-nginx

publish-php-nginx-7.4:
	@docker tag php-nginx:7.4 fernandojrdev/php-nginx:7.4.33-alpine3.16
	@docker push fernandojrdev/php-nginx:7.4.33-alpine3.16
	@docker rmi fernandojrdev/php-nginx:7.4.33-alpine3.16

publish-php-nginx-7.4-pgsql:
	@docker tag php-nginx:7.4-pgsql fernandojrdev/php-nginx:7.4.33-alpine3.16-pgsql
	@docker push fernandojrdev/php-nginx:7.4.33-alpine3.16-pgsql
	@docker rmi fernandojrdev/php-nginx:7.4.33-alpine3.16-pgsql

publish-php-nginx-7.4-dblib:
	@docker tag php-nginx:7.4-dblib fernandojrdev/php-nginx:7.4.33-alpine3.16-dblib
	@docker push fernandojrdev/php-nginx:7.4.33-alpine3.16-dblib
	@docker rmi fernandojrdev/php-nginx:7.4.33-alpine3.16-dblib

publish-php-nginx-7.3:
	@docker tag php-nginx:7.3 fernandojrdev/php-nginx:7.3.33-alpine3.15
	@docker push fernandojrdev/php-nginx:7.3.33-alpine3.15
	@docker rmi fernandojrdev/php-nginx:7.3.33-alpine3.15

publish-php-nginx-7.2:
	@docker tag php-nginx:7.2 fernandojrdev/php-nginx:7.2.34-alpine3.12
	@docker push fernandojrdev/php-nginx:7.2.34-alpine3.12
	@docker rmi fernandojrdev/php-nginx:7.2.34-alpine3.12