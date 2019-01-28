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
      # domain.vm, *.domain.vm
      - VIRTUAL_HOST=~^(.+\.)?docker-website\.(vm|vmd)$$

      # domain.vm, www.domain.vm
      #- VIRTUAL_HOST=~^(www\.)?docker-website\.(vm|vmd)$$

      # subdomain.domain.vm
      #- VIRTUAL_HOST=~^subdomain\.docker-website\.(vm|vmd)$$

      - WEB_DOCUMENT_ROOT=/app/public
      - PHP_DISMOD=ioncube
      - PHP_SENDMAIL_PATH="/home/application/go/bin/mhsendmail --smtp-addr=global-mail:1025"

      - php.error_reporting=32767
      - php.display_errors=1

      # PHP_DEBUGGER: xdebug, blackfire or none
      - PHP_DEBUGGER=${PHP_DEBUGGER:-none}
      - XDEBUG_REMOTE_HOST=${XDEBUG_REMOTE_HOST:-}
      - XDEBUG_REMOTE_PORT=${XDEBUG_REMOTE_PORT:-9000}
      - php.xdebug.idekey=${XDEBUG_IDEKEY:-PHPSTORM}
      - php.xdebug.remote_log=${XDEBUG_REMOTE_LOG:-/tmp/xdebug.log}
      - php.xdebug.cli_color=${XDEBUG_CLI_COLOR:-1}
      - php.xdebug.max_nesting_level=${XDEBUG_MAX_NESTING_LEVEL:-400}
      - php.xdebug.remote_enable=${XDEBUG_REMOTE_ENABLE:-On}
      - XDEBUG_REMOTE_CONNECT_BACK=${XDEBUG_REMOTE_CONNECT_BACK:-On}
      - XDEBUG_REMOTE_AUTOSTART=${XDEBUG_REMOTE_AUTOSTART:-On}
      - BLACKFIRE_SERVER_ID=${BLACKFIRE_SERVER_ID:-}
      - BLACKFIRE_SERVER_TOKEN=${BLACKFIRE_SERVER_TOKEN:-}

      # SSL: Use default cert from global-nginx-proxy
      - CERT_NAME=default
      # SSL: Do not a redirect in global-nginx-proxy, if you use another port than 443
      - HTTPS_METHOD=noredirect

      # Use Context if you want, overridden bei env_file
      - WWW_CONTEXT=${WWW_CONTEXT:-Development/Docker}
      - TYPO3_CONTEXT=${TYPO3_CONTEXT:-Development/Docker}
      - FLOW_CONTEXT=${FLOW_CONTEXT:-Development/Docker}
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

### Change docker project name

The Docker project name is generated by the current folder.

```text
Project name: {current-folder}_{service}_{id}

/my-project/docker-compose.yaml, container: web
Project name: my-project_web_1
```

However, if the folder name is the same as another project, there is a problem and a container shuts down.

To fix this, you can specify the project name itself in the ``.env`` file:

```bash
COMPOSE_PROJECT_NAME=my-project1
```

After starting both containers:

```text
/my-project1/www/docker-compose.yaml, container: web
Project name: my-project1_web_1

/my-project2/www/docker-compose.yaml, container: web
Project name: my-project2_web_1
```

# Documentation

## TYPO3 AdditionalConfiguration.php examples

### TYPO3 database configuration

Configure as environment variable:

```bash
DATABASE_URL=mysql://global-db
DATABASE_URL=mysql://global-db/database_name
DATABASE_URL=mysql://username:password@127.0.0.1:3306/database_name
```

Add php code in additional configuration:

```php
<?php
if (isset($_SERVER['TYPO3_CONTEXT']) && $_SERVER['TYPO3_CONTEXT'] === 'Development/Docker') {
    // Configure database
    $configDatabase = parse_url(getenv('DATABASE_URL'));
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['host'] = isset($configDatabase['host']) ? $configDatabase['host'] : 'global-db';
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['port'] = isset($configDatabase['port']) ? $configDatabase['port'] : '3306';
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['user'] = isset($configDatabase['user']) ? $configDatabase['user'] : 'root';
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['password'] = isset($configDatabase['pass']) ? $configDatabase['pass'] : 'root';
    if (isset($configDatabase['path']) && trim($configDatabase['path'], '/') !== '') {
        $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['dbname'] = trim($configDatabase['path'], '/');
    }
}
```

### TYPO3 mail configuration

Configure as environment variable:

```bash
MAILER_URL=sendmail://localhost/home/user/go/bin/mhsendmail

MAILER_URL=smtp://global-mail:1025
MAILER_URL=smtp://username:passwort@smtp.example.org:25
MAILER_URL=smtp://info@example.org:passwort@smtp.gmail.com?encryption=tls
```

Add php code in additional configuration:

```php
<?php
if (isset($_SERVER['TYPO3_CONTEXT']) && $_SERVER['TYPO3_CONTEXT'] === 'Development/Docker') {
    // Configure mail
    $configMail = parse_url(getenv('MAILER_URL'));
    if (isset($configMail['scheme'])) {
        $configMailQuery = [];
        if (isset($configMail['query'])) {
            parse_str($configMail['query'], $configMailQuery);
        }

        if ($configMail['scheme'] === 'sendmail') {
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport'] = 'sendmail';
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_sendmail_command'] = isset($configMail['path']) ? $configMail['path'] : '/home/user/go/bin/mhsendmail';
        } else if ($configMail['scheme'] === 'smtp') {
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport'] = 'smtp';
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_smtp_encrypt'] = isset($configMailQuery['encryption']) ? $configMailQuery['encryption'] : '';
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_smtp_password'] = isset($configMail['pass']) ? $configMail['pass'] : '';
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_smtp_username'] = isset($configMail['user']) ? $configMail['user'] : '';

            $mailServer = isset($configMail['host']) ? $configMail['host'] : '';
            if (isset($configMail['port'])) {
                $mailServer .= ':' . $configMail['port'];
            }
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_smtp_server'] = $mailServer;
        }
    }
}
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
