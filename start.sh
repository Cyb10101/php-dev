#!/usr/bin/env bash

function startFunction {
    case ${1} in
        start)
            startFunction pull && \
            startFunction build && \
            startFunction up && \
            startFunction login
        ;;
        up)
            APPLICATION_UID=$(id -u) APPLICATION_GID=$(id -g) docker-compose up -d
        ;;
        down)
            docker-compose down --remove-orphans
        ;;
        login)
            docker-compose exec -u $(id -u):$(id -g) web bash
        ;;
        bash)
            docker-compose exec -u $(id -u):$(id -g) web bash
        ;;
        zsh)
            docker-compose exec -u $(id -u):$(id -g) web zsh
        ;;
        *)
            APPLICATION_UID=$(id -u) APPLICATION_GID=$(id -g) docker-compose "${@:1}"
        ;;
    esac
}

startFunction "${@:1}"
exit $?
