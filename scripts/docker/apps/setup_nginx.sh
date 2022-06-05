#!/bin/bash
# exit when any command fails
set -e
source ../setenv.sh

if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Hostname required"
  exit 1
fi

function run_ssh() {
  command="$1"
  ssh -tt "$LXC_USER"@"$HOST" "$command"
}

echo "Checking if docker is installed!"
IS_DOCKER_INSTALLED_COMMAND="docker ps"
run_ssh "$IS_DOCKER_INSTALLED_COMMAND"

echo "Installing Portainer with docker"
INSTALL_NGINX_COMMAND="docker run -d \
                           --name=nginx \
                           --restart always \
                           -p 8085:80 \
                           -v /var/run/docker.sock:/var/run/docker.sock \
                           -v nginx_data:/data \
                           nginx:latest"
run_ssh "$INSTALL_NGINX_COMMAND"

