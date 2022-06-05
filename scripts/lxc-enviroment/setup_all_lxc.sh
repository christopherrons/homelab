#!/bin/bash
# Utility script which creates and add ssh key to all lxc
set -e
source ../setenv.sh

if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Failed... Hostname required!"
  exit 1
fi

allLXC=("$DOCKER_LXC")
for lxc_name in "${allLXC[@]}"; do
  ./setup_lxc.sh "$HOST" "$lxc_name"
done
