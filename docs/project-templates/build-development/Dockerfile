FROM cyb10101/php-dev:nginx-8.1

# Configuration file changed
# --force-confold:  Keep current configuration (New file: .dpkg-dist suffix)
# --force-confnew:  Install the new version (Old file: .dpkg-old suffix)
# --force-confdef:  Dpkg decide alone when it can and prompt otherwise
# --force-confmiss: Add if missing
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confdef" install nginx-extras && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN if [ -f /etc/nginx/nginx.conf ]; then sed -i -E 's/^user\s+(www-data|nginx);/user application application;/g' /etc/nginx/nginx.conf; fi
RUN if [ -f /etc/nginx/nginx.conf ]; then sed -i '1 i\load_module "modules/ngx_http_fancyindex_module.so";' /etc/nginx/nginx.conf; fi

COPY fancyindexing/ /opt/.fancyindexing/

COPY nginx_vhost.conf /opt/docker/etc/nginx/vhost.conf
COPY nginx_10-location-root.conf /opt/docker/etc/nginx/vhost.common.d/10-location-root.conf

RUN if hash a2enmod 2>/dev/null; then a2enmod vhost_alias; fi;
COPY apache_fancyindexing.conf /opt/docker/etc/httpd/vhost.common.d/fancyindexing.conf
COPY apache_90-wildcard.conf /etc/apache2/sites-enabled/90-wildcard.conf

