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
  ssh -tt "$LXC_USER"@"$HOST" "$command"
}

BASE_PATH="/home/$LXC_USER/docker-volumes"
PROMTAIL_PATH="$BASE_PATH"/promtail
LOKI_PATH="$BASE_PATH"/loki
GRAFANA_PATH="$BASE_PATH"/grafana
echo "On host $HOST, create monitoring dirs!"
run_ssh "mkdir -p $PROMTAIL_PATH && mkdir -p $LOKI_PATH && mkdir -p $GRAFANA_PATH"

echo "On host $HOST, add docker compose file!"
scp ../../../resources/monitoring/docker-compose.yml "$LXC_USER"@"$HOST":"$BASE_PATH"

echo "On host $HOST, add loki config file!"
scp ../../../resources/monitoring/loki-config.yml "$LXC_USER"@"$HOST":"$LOKI_PATH"

echo "On host $HOST, add promtail config file!"
scp ../../../resources/monitoring/promtail-config.yml "$LXC_USER"@"$HOST":"$PROMTAIL_PATH"

echo "On host $HOST, start monitoring!"
run_ssh "cd $BASE_PATH && docker-compose up -d --force-recreate"

echo "On host $HOST, delete docker compose file!"
#run_ssh rm "$BASE_PATH"/docker-compose.yml
