#!/bin/bash
# exit when any command fails
set -e

if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Hostname required"
  exit 1
fi

echo "Started setting up docker repository!"
UPDATE_COMMAND="sudo apt-get update"
ssh -tt root@"$HOST" "$UPDATE_COMMAND"

INSTALL_DEPENDENCIES="sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release"
ssh -tt root@"$HOST" "$INSTALL_DEPENDENCIES"

GET_DOCKER_GPG_KEY_COMMAND="curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg"
ssh -tt root@"$HOST" "$GET_DOCKER_GPG_KEY_COMMAND"

SETUP_DOCKER_REPO_COMMAND="echo \
                             'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
                             $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
ssh -tt root@"$HOST" "$SETUP_DOCKER_REPO_COMMAND"
echo "Done updating docker repository!"

echo "Started setting up docker engine!"
UPDATE_COMMAND="sudo apt-get update"
ssh -tt root@"$HOST" "$UPDATE_COMMAND"

INSTALL_DOCKER_COMMAND="sudo apt-get install docker-ce docker-ce-cli containerd.io"
ssh -tt root@"$HOST" "$INSTALL_DOCKER_COMMAND"
echo "Done setting up docker engine!"

echo "Testing Docker!"
TEST_DOCKER_COMMAND="sudo docker run hello-world"
ssh -tt root@"$HOST" "$TEST_DOCKER_COMMAND"
echo "Done testing docker!"