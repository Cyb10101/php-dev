# Xdebug

You can set the default value for the PHP_DEBUGGER in your `.env` file:

```env
PHP_DEBUGGER=xdebug
XDEBUG_REMOTE_HOST=192.168.178.123
```

`XDEBUG_REMOTE_HOST` is the ip-address of your IDE.

Information on how to set up xdebug with PHPStorm is here: [Creating a PHP Debug Server](https://www.jetbrains.com/help/phpstorm/creating-a-php-debug-server-configuration.html)

## Enable and disable xdebug in running container

```bash
# enables xdebug and restarts fpm
xdebug-enable
# disable xdebug and restarts fpm
xdebug-disable
```

## With xdebug enabled you need to activate xdebug on script run.

CLI: run any php script with this prefixed

````
PHP_IDE_CONFIG="serverName=Unnamed" XDEBUG_CONFIG="remote_enable=1" php #...
````

WEB:
We recommend the usage of an enable-disable [Xdebug helper](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc.)

### Listening for PHP Debug Sessions

If you want to use the "Start Listening for PHP Debug Connections" Button in PHPStorm, you can set these ENV variables:
Where Unnamed is the name of the server config in PHPStorm.

```yaml
    - php.xdebug.remote_enable=1
    - php.xdebug.remote_autostart=1
    - PHP_IDE_CONFIG=serverName=Unnamed
```
