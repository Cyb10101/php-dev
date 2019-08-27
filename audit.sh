#!/usr/bin/env bash

source ~/.shell-methods.sh

if test -S "/var/run/docker.sock"; then
    addDockerAlias
    cd /app
    sudo docker exec -u $(id -u):$(id -g) -w $(pwd) -it ${NODE_CONTAINER} yarn audit
fi
