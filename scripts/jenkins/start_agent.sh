#!/bin/bash
# Utility script that start the jenkins agent.
set -e
source ../setenv.sh

if [[ ${1+x} ]]; then
  HOST_AGENT="$1"
else
  echo "Failed... Jenkins agent required!"
  exit 1
fi

if [[ ${2+x} ]]; then
  START_COMMAND="$2"
else
  echo "Failed... Start command required"
  exit 1
fi

echo "Start agent on $HOST_AGENT"
rsync -r -P /home/christopher/Downloads/agent.jar "$ROOT_USER"@"$HOST_AGENT":
ssh "$ROOT_USER"@"$HOST_AGENT" "java -jar agent.jar $START_COMMAND"



