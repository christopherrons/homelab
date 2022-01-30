#!/bin/bash
# exit when any command fails
set -e
#source setup_homer.sh

if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Failed... Hostname required!"
  exit 1
fi


echo "Remove old file..."
REMOVE_CONFIG="cd /home/homelab && \
                rm config.yml"
ssh -tt root@"$HOST" "$REMOVE_CONFIG"

echo "Updating file..."
CONFIG_DIR="/home/homelab"
rsync -r -p ../resources/homer-dashboard/config.yml root@"$HOST":"$CONFIG_DIR"
echo "Done!"