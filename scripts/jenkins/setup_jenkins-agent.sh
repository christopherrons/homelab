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
  ssh -tt "$ROOT_USER"@"$host" "$command"
}

echo "Install java on agent $HOST_AGENT"
run_ssh "$HOST_AGENT" "sudo apt-get update && sudo apt-get install openjdk-8-jdk"

echo "Create ssh-key on $HOST_AGENT"
run_ssh "$HOST_AGENT" "cd  /root/.ssh/ && ssh-keygen && cat /root/.ssh/id_rsa"

echo "Add agent public key on agent $ENKINS_MASTER_LXC_NAME"
KEY="$(run_ssh "$HOST_AGENT" "cat /root/.ssh/id_rsa.pub")"
run_ssh "$ENKINS_MASTER_LXC_NAME" "echo $KEY >> /root/.ssh/authorized_keys"

echo "Create ssh-key on $JENKINS_MASTER_LXC_NAME"
run_ssh "$JENKINS_MASTER_LXC_IP" "cd  /root/.ssh/ && ssh-keygen && cat /root/.ssh/id_rsa"

echo "Add master public key on agent $HOST_AGENT"
KEY="$(run_ssh "$JENKINS_MASTER_LXC_IP" "cat /root/.ssh/id_rsa.pub")"
run_ssh "$HOST_AGENT" "echo $KEY >> /root/.ssh/authorized_keys"

