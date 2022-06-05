#!/bin/bash
# Utility script that updates the homer dashboard config
set -e
source ../../setenv.sh

if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Failed... Hostname required!"
  exit 1
fi


CONFIG_DIR="/home/$LXC_USER/dev-portal"
echo "Remove old file..."
REMOVE_CONFIG="cd $CONFIG_DIR && rm config.yml"
ssh -tt root@"$HOST" "$REMOVE_CONFIG"

echo "Updating file..."

rsync -r -p ../../../resources/homer-dashboard/config.yml "$LXC_USER"@"$HOST":"$CONFIG_DIR"
echo "Done!"