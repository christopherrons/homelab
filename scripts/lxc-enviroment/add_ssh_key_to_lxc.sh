#!/bin/bash
# Utility script that adds ssh key to lxc
set -e
source ../setenv.sh

if [[ ${1+x} ]]; then
  SOURCE_HOST="$1"
else
  echo "Failed... source host required!"
  exit 1
fi

if [[ ${2+x} ]]; then
  DESTINAION_HOST="$2"
else
  echo "Failed... destination host required!"
  exit 1
fi

SOURCE_KEY="$(ssh -o StrictHostKeyChecking=no -tt "$ROOT_USER"@"$SOURCE_HOST" "cat ~/.ssh/id_rsa.pub")"
ssh -o StrictHostKeyChecking=no -tt "$LXC_USER"@"$DESTINAION_HOST" "echo $SOURCE_KEY >> ~/.ssh/authorized_keys"