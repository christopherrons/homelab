#!/bin/bash
# Utility script that runs multiple setup scripts.
source ../setenv.sh

bash /lxc-enviroment/setup_all_lxc.sh "$HOMELAB_SERVER"
bash /lxc-enviroment/setup_docker_ubuntu-lxc.sh "$HOMELAB_SERVER" "$DOCKER_LXC"
bash /dev-portal/setup_homer.sh "$DOCKER_LXC"
bash /docker-apps/setup_portainer.sh "$DOCKER_LXC"
