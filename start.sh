#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
APPLICATION_UID=${APPLICATION_UID:-1000}
APPLICATION_GID=${APPLICATION_GID:-1000}
APPLICATION_USER=${APPLICATION_USER:-application}
APPLICATION_GROUP=${APPLICATION_GROUP:-application}

# Fix special user permissions
if [ "$(id -u)" != "1000" ]; then
    grep -q '^APPLICATION_UID=' .env && sed -i 's/^APPLICATION_UID=.*/APPLICATION_UID='$(id -u)'/' .env || echo 'APPLICATION_UID='$(id -u) >> .env
    grep -q '^APPLICATION_GID=' .env && sed -i 's/^APPLICATION_GID=.*/APPLICATION_GID='$(id -g)'/' .env || echo 'APPLICATION_GID='$(id -g) >> .env
fi;

# Load environment file
if [ -f .env ]; then
  source .env
fi
if [ -f .env.local ]; then
  source .env.local
fi

DOCKER_COMPOSE_FILE=docker-compose.yml

# Select docker compose file by user variable
ENV_DOCKER_CONTEXT=${ENV_DOCKER_CONTEXT:-}
if [ "${ENV_DOCKER_CONTEXT:0:11}" == "Development" ]; then
  DOCKER_COMPOSE_FILE=docker-compose.dev.yml
fi

# Select docker compose file by symfony environment
APP_ENV=${APP_ENV:-}
if [ "${APP_ENV}" == "dev" ]; then
  DOCKER_COMPOSE_FILE=docker-compose.dev.yml
fi

dockerCompose() {
    docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" "${@:1}"
}

startFunction() {
    case ${1} in
        start)
            startFunction pull && \
            startFunction build && \
            startFunction up
        ;;
        up)
            dockerCompose up -d
        ;;
        down)
            dockerCompose down --remove-orphans
        ;;
        login-root)
            dockerCompose exec web bash
        ;;
        login)
            startFunction bash
        ;;
        bash)
            dockerCompose exec -u ${APPLICATION_USER} web bash
        ;;
        zsh)
            dockerCompose exec -u ${APPLICATION_USER} web zsh
        ;;
        exec-web)
            dockerCompose exec -u ${APPLICATION_USER} web "${@:2}"
        ;;
        *)
            dockerCompose "${@:1}"
        ;;
    esac
}

startFunction "${@:1}"
exit $?
