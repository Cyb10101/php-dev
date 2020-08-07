# Set user and group id

As a user with a UID other than 1000, you have permissions issues with files.

The variables are automatically changed in `start.sh` for `.env`. But ultimately have to be handed over `docker-compose.yaml`.

Required: APPLICATION_UID & APPLICATION_GID

docker-compose.yaml:

```yaml
services:
  web:
    environment:
    # Set user and group id
    - APPLICATION_UID=${APPLICATION_UID:-1000}
    - APPLICATION_GID=${APPLICATION_GID:-1000}
```
