#!/bin/bash
# exit when any command fails
set -e
source ../../setenv.sh

if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Hostname required"
  exit 1
fi

function run_ssh() {
  command="$1"
  ssh -tt "$ROOT_USER"@"$HOST"  "$command"
}

echo "Checking if docker is installed!"
IS_DOCKER_INSTALLED_COMMAND="docker ps"
run_ssh "$IS_DOCKER_INSTALLED_COMMAND"

echo "Installing Portainer with docker"
INSTALL_PORTAINER_COMMAND="docker run -d \
                           --name=portainer \
                           --restart always \
                           -p 9000:9000 \
                           -p 8000:8000 \
                           -v /var/run/docker.sock:/var/run/docker.sock \
                           -v portainer_data:/data \
                           portainer/portainer-ce:latest"
run_ssh "$INSTALL_PORTAINER_COMMAND"
