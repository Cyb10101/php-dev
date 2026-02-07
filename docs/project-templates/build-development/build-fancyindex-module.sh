#!/usr/bin/env bash
set -euo pipefail

apt-get update
apt-get install -y --no-install-recommends build-essential ca-certificates curl git libpcre3-dev zlib1g-dev libssl-dev
rm -rf /var/lib/apt/lists/*

NGINX_VER="$(nginx -v 2>&1 | sed -n 's|^nginx version: nginx/||p')"
NGINX_ARGS_RAW="$(nginx -V 2>&1 | sed -n 's|^configure arguments: ||p')"

# Parse args with quoting preserved
read -r -a NGINX_ARGS <<<"$(bash -lc 'printf "%s\n" "$1"' _ "$NGINX_ARGS_RAW")"

mkdir -p /tmp/build && cd /tmp/build
curl -fsSLO "https://nginx.org/download/nginx-${NGINX_VER}.tar.gz"
tar -xzf "nginx-${NGINX_VER}.tar.gz"
git clone --depth 1 https://github.com/aperezdc/ngx-fancyindex.git

cd "nginx-${NGINX_VER}"

# Configure using the same args, plus dynamic module
# Ensure --with-compat is present (add it if your args don't include it)
# Build dynamic module with compatibility flag
./configure $NGINX_ARGS --with-compat --add-dynamic-module=../ngx-fancyindex

make modules
install -D -m 644 objs/ngx_http_fancyindex_module.so /usr/lib/nginx/modules/ngx_http_fancyindex_module.so
rm -rf /tmp/build

