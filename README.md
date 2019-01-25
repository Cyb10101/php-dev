# PHP Webserver Development

## Docker Global

To use this Docker image you still need this repository:
[pluswerk/docker-global](https://github.com/pluswerk/docker-global).

## Docker compose

Example File: docker-compose.yaml

```yaml
version: '3.5'

services:
  web:
    # Restart if aborted or start after reboot
    #restart: always

    #build: php-dev
    image: cyb10101/php-dev:apache-7.3

    volumes:
      - .:/app
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ~/.ssh:/home/application/.ssh:ro
      # Note: /home/application/.ssh will be copied to /root/.ssh if is empty or not exists
      - ~/.composer/cache:/home/application/.composer/cache
      - ~/.gitconfig:/home/application/.gitconfig:ro

    env_file:
      - .env
    environment:
      - VIRTUAL_HOST=~^(.+\.)?docker-website\.vm$$
      - WEB_DOCUMENT_ROOT=/app/public
      - PHP_DISMOD=ioncube
      - PHP_SENDMAIL_PATH="/home/application/go/bin/mhsendmail --smtp-addr=global-mail:1025"
      - php.display_errors=1

      - php.xdebug.cli_color=1
      - php.xdebug.idekey=PHPSTORM
      - php.xdebug.max_nesting_level=400
      - php.xdebug.remote_enable=On
      - php.xdebug.remote_connect_back=On
      #- php.xdebug.remote_host=192.168.178.123
      - php.xdebug.remote_port=9000
      - php.xdebug.remote_autostart=On
      - php.xdebug.remote_log=/tmp/xdebug.log

      # SSL: Use default cert from global-nginx-proxy
      - CERT_NAME=default
      # SSL: Do not a redirect in global-nginx-proxy, if you use another port than 443
      - HTTPS_METHOD=noredirect
    working_dir: /app

  node:
    image: node:lts
    volumes:
      - ./:/app
    working_dir: /app
    command: tail -f /dev/null

networks:
  default:
    external:
      name: global
```

## ImageMagick & GraphicMagick included in PHP

If you need ImageMagick or GraphicMagick as a PHP module, you need to install and activate it.
You can create your own Dockerfile and derive from this image.

Both are already preinstalled in the Docker image and it is recommended that you use these binarys instead of the PHP module.

For Example:

```php
<?php exec('/usr/bin/convert ...');
```

### Install ImageMagick or GraphicMagick included in PHP

If you still want to install and activate the PHP module, then create your own Dockerfile.

Install ImageMagick:

```dockerfile
RUN apt install -y imagemagick libmagickwand-dev && printf "\n" | pecl install imagick
```

Install GraphicMagick:

```dockerfile
RUN apt install -y graphicsmagick gcc libgraphicsmagick1-dev && \
    PHP_VERSION=`php -r "echo version_compare(PHP_VERSION, '7.0.0', '<');";` && \
    if [ "${PHP_VERSION}" = "1" ]; then printf "\n" | pecl install gmagick-1.1.7RC3; else printf "\n" | pecl install gmagick-2.0.5RC1; fi;
```

For whatever reason, you can only activate one of them in PHP. If you activate both, PHP will not work properly anymore.
Therefore either use ImageMagick or GraphicMagick:

```dockerfile
# For ImageMagick
RUN echo 'extension=imagick.so' >> /usr/local/etc/php/conf.d/docker-php-ext-magick.ini;

# For GraphicMagick
RUN echo 'extension=gmagick.so' >> /usr/local/etc/php/conf.d/docker-php-ext-magick.ini;
```
