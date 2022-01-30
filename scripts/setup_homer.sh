#!/bin/bash
# exit when any command fails
set -e
if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Failed... Hostname required!"
  exit 1
fi

CONFIG_DIR="/home/homelab"

echo "Create Folder configs"
CREATE_DIR="mkdir -p $CONFIG_DIR"
ssh -tt root@"$HOST" "$CREATE_DIR"

echo "Creating homer-dashboard docker image"
host_uid=$(ssh -tt root@"$HOST" "id --user")
host_user_name=$(ssh -tt root@"$HOST" "id --user --name")
host_gid=$(ssh -tt root@"$HOST" "id --group")
host_group_name=$(ssh -tt root@"$HOST" "id --group --name")
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
ssh -tt root@"$HOST" "$INSTALL_DEPENDENCIES"