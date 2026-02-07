FROM cyb10101/php-dev:nginx-8.5

COPY fancyindexing/ /opt/.fancyindexing/
COPY build-fancyindex-module.sh /opt/build-fancyindex-module.sh
RUN if [ -f /etc/nginx/nginx.conf ]; then chmod +x /opt/build-fancyindex-module.sh && /opt/build-fancyindex-module.sh; fi
RUN if [ -f /etc/nginx/nginx.conf ]; then sed -i -E 's/^user\s+(www-data|nginx);/user application application;/g' /etc/nginx/nginx.conf; fi
RUN if [ -f /etc/nginx/nginx.conf ]; then sed -i '1 i\load_module "modules/ngx_http_fancyindex_module.so";' /etc/nginx/nginx.conf; fi

COPY nginx_vhost.conf /opt/docker/etc/nginx/vhost.conf
COPY nginx_10-location-root.conf /opt/docker/etc/nginx/vhost.common.d/10-location-root.conf

RUN if hash a2enmod 2>/dev/null; then a2enmod vhost_alias; fi;
COPY apache_fancyindexing.conf /opt/docker/etc/httpd/vhost.common.d/fancyindexing.conf
COPY apache_90-wildcard.conf /etc/apache2/sites-enabled/90-wildcard.conf

