# Nginx Reverse Proxy

This project relies on [pluswerk/docker-global](https://github.com/pluswerk/docker-global).

File docker-compose.yml:

```yaml
services:
  web:
    environment:
      - VIRTUAL_HOST=domain.localhost
      - VIRTUAL_HOST=domain.localhost,www.domain.localhost

      # domain.localhost and www.domain.localhost
      #- VIRTUAL_HOST=~^(www\.)?domain\.localhost$$

      # domain.localhost and *.domain.localhost
      - VIRTUAL_HOST=~^(.+\.)?domain\.localhost$$

      - VIRTUAL_PROTO=https
      - VIRTUAL_PORT=443
```

Below is a clarification of the VIRTUAL_* variable.

## VIRTUAL_HOST: Virtual host (your domain)

Through the VIRTUAL_HOST variable the nginx reverse proxy knows which domain belongs to which Docker container.

## VIRTUAL_PROTO & VIRTUAL_PORT: SSL

Virtual protocol (VIRTUAL_PROTO) and virtual port (VIRTUAL_PORT) are only there to regulate the communication between nginx-reverse-proxy and the website.

Not for communication between web browser and nginx reverse proxy!

### HTTP: default communication

Web-browser <-(http/https)-> nginx-reverse-proxy (docker-global) <-(http)-> Website (php-dev)

The communication between the nginx-reverse-proxy usually runs completely through http.
Although it looks from the outside, as if you have SSL configured.
But behind it the communication runs over http.

You do not have to configure anything for that.

### HTTPS: SSL between nginx-reverse-proxy & website

Web-browser <-(http/https)-> nginx-reverse-proxy (docker-global) <-(https)-> Website (php-dev)

If a website requires https, it can happen that endless redirects are made.

That's why you have to set the virtual protocol to https and change the virtual port to 443.

The communication between nginx-reverse-proxy and the website is now always via https.
No matter if you surf from the web browser via http or https.
