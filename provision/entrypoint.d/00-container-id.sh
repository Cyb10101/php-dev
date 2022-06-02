#!/usr/bin/env bash

getDockerContainerId() {
  info=`awk '/^.*\/var\/lib\/docker\/containers\/([^\/]+)\/hosts.*$/{print $4}' /proc/1/mountinfo`
  if [[ "${info}" =~ \/var\/lib\/docker\/containers\/([0-9a-z]+) ]]; then echo ${BASH_REMATCH[1]}; fi
}

# @todo Not working anymore, bug?
# cat /proc/1/cpuset > /container-id

# @todo Hostname can change
# cat /etc/hostname > /container-id

# Not nice, but working
echo "$(getDockerContainerId)" > /container-id

# @todo docker run --cidfile="/container-id" not available for docker-compose
