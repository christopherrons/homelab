#!/bin/bash
# Utility script that setsup the jenkins agent.
set -e
source ../setenv.sh

# Tutorial for agents: https://www.youtube.com/watch?v=V2ejGOY_uJI&t=175s

if [[ ${1+x} ]]; then
  HOST_AGENT="$1"
else
  echo "Failed... Jenkins agent required!"
  exit 1
fi

function run_ssh() {
  host="$1"
  command="$2"
  ssh -n "$ROOT_USER"@"$host" "$command"
}

echo "Create ssh-key on $JENKINS_MASTER_LXC"
run_ssh "$JENKINS_MASTER_LXC" "ssh-keygen && cat /root/.ssh/id_rsa"

echo "Set master public key on agent $HOST_AGENT"
KEY="$(run_ssh "cat /root/.ssh/id_rsa.pub")"
run_ssh "$HOST_AGENT" "echo $KEY >> root/.ssh/authorized_keys"

echo "Install java on agent $HOST_AGENT"
run_ssh "$HOST_AGENT" "sudo apt-get update && sudo apt-get install openjdk-8-jdk"

