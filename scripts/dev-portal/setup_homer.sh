#!/bin/bash
# Utility script that install homer dashboard in a docker container.
set -e
source ../setenv.sh

if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Failed... Hostname required!"
  exit 1
fi

function run_ssh() {
  command="$1"
  ssh -tt "$LXC_USER"@"$HOST" "$command"
}

CONFIG_DIR="/home/$LXC_USER/dev-portal"

echo "Create config dir."
CREATE_DIR="mkdir -p $CONFIG_DIR"
run_ssh "$CREATE_DIR"

echo "Creating homer-dashboard docker image"
host_uid=$(run_ssh "id --user")
host_user_name=$(run_ssh "id --user --name")
host_gid=$(run_ssh "id --group")
host_group_name=$(run_ssh "id --group --name")
INSTALL_DEPENDENCIES="docker run -d \
                        --publish 8082:8080 \
                        --name homer-dashboard \
                        --env UID=$host_uid \
                        --env USER=$host_user_name \
                        --env GID=$host_gid \
                        --env GROUP=$host_group_name \
                        --mount type=bind,source=$CONFIG_DIR,target=/www/assets \
                        --restart=always \
                        b4bz/homer:latest"
run_ssh "$INSTALL_DEPENDENCIES"