#!/usr/bin/env bash

# Fix special user permissions
if [ "$(id -u)" != "1000" ]; then
    grep -q '^APPLICATION_UID=' .env && sed -i 's/^APPLICATION_UID=.*/APPLICATION_UID='$(id -u)'/' .env || echo 'APPLICATION_UID='$(id -u) >> .env
    grep -q '^APPLICATION_GID=' .env && sed -i 's/^APPLICATION_GID=.*/APPLICATION_GID='$(id -g)'/' .env || echo 'APPLICATION_GID='$(id -g) >> .env
fi;

function startFunction {
    case ${1} in
        start)
            startFunction pull && \
            startFunction build && \
            startFunction up && \
            startFunction login
        ;;
        up)
            docker-compose up -d
        ;;
        down)
            docker-compose down --remove-orphans
        ;;
        login)
            startFunction zsh
        ;;
        bash)
            docker-compose exec -u $(id -u) web bash
        ;;
        zsh)
            docker-compose exec -u $(id -u) web zsh
        ;;
        *)
            docker-compose "${@:1}"
        ;;
    esac
}

startFunction "${@:1}"
exit $?
