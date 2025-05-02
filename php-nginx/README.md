# PHP-FPM Nginx

This image provides a pre-configured environment for running PHP applications with Nginx and PHP-FPM.

## Installed extensions
- BCMath
- Ctype
- cURL
- DOM
- Exif
- Fileinfo
- Filter
- gRPC
- Hash
- Internationalization (intl)
- Mbstring
- MySQL
- OPCache
- OpenSSL
- PCRE
- PDO
- Process Control (pcntl)
- Protobuf
- Redis
- Session
- Sockets
- sqlite3
- Tokenizer
- XML
- ZIP

### Images with the `-grpc` tag

Images with the `-grpc` suffix tag (for example, fernandojrdev/php-nginx:8.0-alpine3.16-grpc) indicate that, in addition to the standard PHP extensions, they include two essential modules for working with gRPC: 

  - **Protobuf:** This module allows you to define and manipulate data structures efficiently and independently of the programming language. It is essential for communication between services using the gRPC protocol.
  - **gRPC:** The gRPC module, in turn, offers a framework for creating high-performance, low-latency APIs using the HTTP/2 protocol and the Protobuf serialization format.

> To see all image modules, run the command like this:
> ```sh
> docker run --rm -it fernandojrdev/php-nginx:8.0-alpine3.16-grpc php -m
> ```

## How to use

```dockerfile
FROM fernandojrdev/php-nginx:8.4-alpine3.20

# copy the whole project to the default workdir /app/public
COPY . .

# define your startup command (optional)
CMD [ "my", "custom", "command" ]
```

To customize the nginx configuration, change the file located in `/etc/nginx/nginx.conf` as needed for the best
performance of your application. If you only want to change the root directory, use the environment variable `NGINX_ROOT`.

## Environment variables

- `NGINX_ROOT`: This is used to customize the Nginx root directory. Default is `/app/public`.
- `NGINX_CLIENT_MAX_BODY_SIZE`: The nginx client max body size. Default is `1M`.
- `NGINX_WORKER_PROCESS`: This defines the number of Nginx worker processes, limited to 1024 connections each. Horizontal Pod Autoscaling (HPA) can scale up as needed. Default is `2`.
- `PHP_UPLOAD_MAX_FILESIZE`: This variable sets the maximum allowed size for file uploads in PHP. Default is `2M`.
- `PHP_POST_MAX_SIZE`: This variable determines the maximum size of POST data that PHP can accept. Default is `8M`
- `PHP_MEMORY_LIMIT`: This environment variable sets the maximum amount of memory that PHP scripts are allowed to consume. Default is `128M`.
- `PHP_OPCACHE_VALIDATE_TIMESTAMPS`: Checks if PHP scripts have been modified since they were cached. Default is `0`, but it is recommended to set to `1` in a development environment.
- `PHP_OPCACHE_MAX_ACCELERATED_FILES`: The maximum number of PHP scripts that can be cached by opcache. Default is `10000`.
- `PHP_OPCACHE_MEMORY_CONSUMPTION`: How much memory opcache can use. Default is `192`.
- `PHP_OPCACHE_MAX_WASTED_PERCENTAGE`: The maximum amount of memory that can be wasted by opcache. Default is `10`.
- `PHP_OPCACHE_BLACKLIST_FILENAME`: Specifies a file containing patterns to exclude from opcache. Empty by default.
- `PHP_OPCACHE_JIT`: Enables JIT compilation. Default is `tracing`. Available only on `PHP 8 or higher` image tags.
- `PHP_OPCACHE_JIT_BUFFER_SIZE`: The size of the JIT buffer. Default is `128M`. Available only on `PHP 8 or higher` image tags. 

## Image Configurations

The settings can be customized easily by replacing the image tag with the desired version. The environment variables will be applied automatically by the image entrypoint when the container is started.

1. **NGINX Configuration** (`nginx.conf`)
    - **Image Tag:** Replace `8.4-alpine3.20` with the desired image tag.    
    - **Environment Variables:** The image's entrypoint will automatically apply environment variables set during container startup.

      To view the current configuration:
      ```sh
      docker run --rm -it fernandojrdev/php-nginx:8.4-alpine3.20 cat /etc/nginx/nginx.conf
      ```

2. **PHP-FPM Configuration (`php-fpm.ini`)
    - **Image Tag:** Replace `8.4-alpine3.20` with the desired image tag.
    - **Environment Variables:** The image's entrypoint will automatically apply environment variables set during container startup.

      To view the current configuration:
      ```sh
      docker run --rm -it fernandojrdev/php-nginx:8.4-alpine3.20 cat /usr/local/etc/php/php-fpm.ini
      ```

3. **PHP Configuration** (`php.ini`)
    - **Image Tag:** Replace `8.4-alpine3.20` with the desired image tag.

      To view the current configuration:
      ```sh
      docker run --rm -it fernandojrdev/php-nginx:8.4-alpine3.20 cat /usr/local/etc/php/php.ini
      ```

4. **OPcache Configuration** (`opcache.ini`)
    - **Image Tag:** Replace `8.4-alpine3.20` with the desired image tag.
    - **Environment Variables:** The image's entrypoint will automatically apply environment variables set during container startup.
    - **JIT:** Available only on `PHP 8 or higher` image tags.

      To view the current configuration:
      ```sh
      docker run --rm -it fernandojrdev/php-nginx:8.4-alpine3.20 cat /usr/local/etc/php/conf.d/opcache.ini
      ```

5. **PHP Extensions Configuration** (`php-ext.ini`)
    - **Image Tag:** Replace `8.4-alpine3.20` with the desired image tag.
    - **Environment Variables:** The image's entrypoint will automatically apply environment variables set during container startup.

      To view the current configuration:
      ```sh
      docker run --rm -it fernandojrdev/php-nginx:8.4-alpine3.20 cat /usr/local/etc/php/conf.d/php-ext.ini
      ```

## Custom Tags for Other Database Drivers

This image is designed to be easily extensible, allowing build custom tags with support for additional database drivers such as `pdo_pgsql`, `pdo_firebird`, `pdo_dblib` and `pdo_odbc`. <br/>
If necessary, we can quickly launch a tag with the desired driver.

## Dockerhub

The image containers are available on Dockerhub link: 
- [php-nginx](https://hub.docker.com/r/fernandojrdev/php-nginx)