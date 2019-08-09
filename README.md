# PHP Webserver Development

PHP-DEV is a small package that includes a web server, PHP and some tools needed to develop a web application.
You can easily decide with a docker-compose.yaml which PHP version you want and whether you want to start an Apache or a Nginx webserver.
We recommend to use [pluswerk/docker-global](https://github.com/pluswerk/docker-global) as a wrapper for your projects since this Dockerfile has been build by keeping that in mind.

## Docker compose

This is an example of a docker-compose.yaml file.
It is enough to put this file into the project, configure it and start the Docker container.
Further information can be found in the [documentation].

Example file: docker-compose.yaml

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
      # Note: The docker socket is optional if no node container is needed
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ~/.ssh:/home/application/.ssh:ro
      # Note: /home/application/.ssh will be copied to /root/.ssh if is empty or not exists
      - ~/.composer/cache:/home/application/.composer/cache
      - ~/.gitconfig:/home/application/.gitconfig:ro

    environment:
      # domain.vm, *.domain.vm
      - VIRTUAL_HOST=~^(.+\.)?docker-website\.(vm|vmd)$$

      # domain.vm, www.domain.vm
      #- VIRTUAL_HOST=~^(www\.)?docker-website\.(vm|vmd)$$

      # subdomain.domain.vm
      #- VIRTUAL_HOST=~^subdomain\.docker-website\.(vm|vmd)$$

      #- VIRTUAL_PROTO=https
      #- VIRTUAL_PORT=443

      - WEB_DOCUMENT_ROOT=/app/public
      - php.error_reporting=32767

      # PHP_DEBUGGER: xdebug, blackfire or none
      - PHP_DEBUGGER=${PHP_DEBUGGER:-none}
      - XDEBUG_REMOTE_HOST=${XDEBUG_REMOTE_HOST:-}
      - XDEBUG_REMOTE_PORT=${XDEBUG_REMOTE_PORT:-9000}
      - php.xdebug.idekey=${XDEBUG_IDEKEY:-PHPSTORM}
      - php.xdebug.remote_log=${XDEBUG_REMOTE_LOG:-/tmp/xdebug.log}
      #- php.xdebug.cli_color=${XDEBUG_CLI_COLOR:-1}
      #- php.xdebug.max_nesting_level=${XDEBUG_MAX_NESTING_LEVEL:-400}
      #- php.xdebug.remote_enable=${XDEBUG_REMOTE_ENABLE:-On}
      #- XDEBUG_REMOTE_CONNECT_BACK=${XDEBUG_REMOTE_CONNECT_BACK:-On}
      #- XDEBUG_REMOTE_AUTOSTART=${XDEBUG_REMOTE_AUTOSTART:-On}
      - BLACKFIRE_SERVER_ID=${BLACKFIRE_SERVER_ID:-}
      - BLACKFIRE_SERVER_TOKEN=${BLACKFIRE_SERVER_TOKEN:-}

      # SSL: Use default cert from global-nginx-proxy
      - CERT_NAME=default
      # SSL: Do not a redirect in global-nginx-proxy, if you use another port than 443
      - HTTPS_METHOD=noredirect

      # Project environment variables (enable what you need)
      - WWW_CONTEXT=${WWW_CONTEXT:-Development/Docker}
      - TYPO3_CONTEXT=${TYPO3_CONTEXT:-Development/Docker}
      - FLOW_CONTEXT=${FLOW_CONTEXT:-Development/Docker}
      #- APP_ENV=development_docker
      #- PIMCORE_ENVIRONMENT=development_docker

      # Don't forget to connect via ./start.sh
      - APPLICATION_UID=${APPLICATION_UID:-1000}
      - APPLICATION_GID=${APPLICATION_GID:-1000}
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

## Documentation

* See the [documentation] for more information.
* [webdevops/Dockerfile](https://github.com/webdevops/Dockerfile)
* [pluswerk/php-dev](https://github.com/pluswerk/php-dev)

## Setup

Create a docker-compose.yaml like the one from above.
Change all your settings. Mainly the `VIRTUAL_HOST`, `WEB_DOCUMENT_ROOT` and maybe the application context.

Then you can copy the [start.sh](start.sh) into your project and start it.

[documentation]: docs/index.md

