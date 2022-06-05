#!/bin/bash
# Utility script that installs pi-hole.
set -e
source ../setenv.sh

if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Failed... Hostname required!"
  exit 1
fi

ssh "$LXC_USER"@"$HOST" 'curl -sSL https://install.pi-hole.net | bash'