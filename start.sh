#!/usr/bin/env bash

# Fix special user permissions
if [ "$(id -u)" != "1000" ]; then
    grep -q '^APPLICATION_UID_OVERRIDE=' .env && sed -i 's/^APPLICATION_UID_OVERRIDE=.*/APPLICATION_UID_OVERRIDE='$(id -u)'/' .env || echo 'APPLICATION_UID_OVERRIDE='$(id -u) >> .env
    grep -q '^APPLICATION_GID_OVERRIDE=' .env && sed -i 's/^APPLICATION_GID_OVERRIDE=.*/APPLICATION_GID_OVERRIDE='$(id -g)'/' .env || echo 'APPLICATION_GID_OVERRIDE='$(id -g) >> .env
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
