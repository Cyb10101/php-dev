FROM cyb10101/php-dev:nginx-8.0

RUN apt-get update && \
    apt-get install -y nginx-extras && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY fancyindexing/ /opt/.fancyindexing/

COPY nginx_vhost.conf /opt/docker/etc/nginx/vhost.conf
COPY nginx_10-location-root.conf /opt/docker/etc/nginx/vhost.common.d/10-location-root.conf

RUN if hash a2enmod 2>/dev/null; then a2enmod vhost_alias; fi;
COPY apache_fancyindexing.conf /opt/docker/etc/httpd/vhost.common.d/fancyindexing.conf
COPY apache_90-wildcard.conf /etc/apache2/sites-enabled/90-wildcard.conf

