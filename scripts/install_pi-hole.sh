#!/bin/bash
# exit when any command fails
set -e

if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Failed... Hostname required!"
  exit 1
fi

curl -sSL https://install.pi-hole.net | bash