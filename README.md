# PHP Webserver Development

PHP-DEV is a small package that includes a web server, PHP and some tools needed to develop a web application.
You can easily decide which version of PHP you want to use and whether you want to start an Apache or a Nginx webserver by setting the values in a docker-compose.yml.
We recommend using [Cyb10101/docker-global](https://github.com/Cyb10101/docker-global) as a wrapper for your projects, since this Dockerfile has been built keeping that in mind.

## Documentation

* [Nginx Reverse Proxy](docs/nginx-reverse-proxy.md)
* [TYPO3 configuration >=8](docs/typo3-configuration.md)
* [TYPO3 configuration <=7](docs/typo3-configuration-legacy.md)
* [Change docker project name](docs/docker-project-name.md)
* [ImageMagick or GraphicMagick](docs/magick.md)
* [Environment variables](docs/docs/environment-variables.md)
* [XDebug](docs/xdebug.md)
* [Project templates](docs/project-templates.md)
* [Set user and group id](docs/set-user-and-group-id.md)
* [Mail](docs/mail.md)
* [Vulnerabilities](docs/vulnerabilities.md)

### Further topics

* [webdevops/php-apache-dev](https://hub.docker.com/r/webdevops/php-apache-dev)
* [webdevops/php-nginx-dev](https://hub.docker.com/r/webdevops/php-nginx-dev)
* [webdevops/Dockerfile](https://github.com/webdevops/Dockerfile)
* [pluswerk/php-dev](https://github.com/pluswerk/php-dev)
* [Composer](https://getcomposer.org/) (`composer`)
* [WP-Cli](https://wp-cli.org/) (`wp-cli`)
* [NPM](https://www.npmjs.com/) (`npm`)
* [Yarn](https://yarnpkg.com/) (`yarn`)
* [jq: JSON processor](https://stedolan.github.io/jq/) (`jq`)
* [yq: YAML/XML processor](https://github.com/kislyuk/yq) (`yq`, `xq`)

## Docker compose

This is an example of a docker-compose.yml file.
It is enough to put this file into the project, configure it and start the Docker container.
Further information can be found in the documentation.

Example file for development: [docker-compose.yml](docker-compose.yml)

## Setup

Create a docker-compose.yml like shown above.
Change all your settings. Mainly the `VIRTUAL_HOST`, `WEB_DOCUMENT_ROOT` and maybe the application context.

Then you can copy the [start.sh](start.sh) into your project and start it.
