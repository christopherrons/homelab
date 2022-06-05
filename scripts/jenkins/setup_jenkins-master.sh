#!/bin/bash
# Utility script that runs multiple setup scripts.
set -e
source ../setenv.sh

# Tutorial for agents: https://www.youtube.com/watch?v=V2ejGOY_uJI&t=175s

if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Failed... Hostname required!"
  exit 1
fi

function run_ssh() {
  command="$1"
  ssh -tt "$ROOT_USER"@"$HOST" "$command"
}

echo "Install Jenkins on host $HOST"
INSTALL_JENKINS_COMMAND="sudo apt-get update && \
                        sudo apt-get install openjdk-8-jdk && \
                        wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add - && \
                        sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && \
                        sudo apt-get update && \
                        sudo apt-get install jenkins && \
                        sudo apt install git"
run_ssh "$INSTALL_JENKINS_COMMAND"

echo "Show initial password."
run_ssh "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"



