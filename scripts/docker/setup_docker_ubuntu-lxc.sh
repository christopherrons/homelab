#!/bin/bash
# exit when any command fails
set -e
source ../setenv.sh

if [[ ${1+x} ]]; then
  HOST_NAME="$1"
else
  echo "Failed... host name required!"
  exit 1
fi

if [[ ${2+x} ]]; then
  HOST_IP="$2"
else
  echo "Failed... host ip required!"
  exit 1
fi

if [[ ${3+x} ]]; then
  LXC_NAME="$3"
else
  echo "Failed... LXC name required!"
  exit 1
fi

if [[ ${4+x} ]]; then
  LXC_IP="$4"
else
  echo "Failed... LXC ip required!"
  exit 1
fi

function run_ssh() {
  host="$1"
  user="$2"
  command="$3"
  ssh -o StrictHostKeyChecking=no -tt "$user"@"$host" "$command"
  echo ""
}

echo "Set lxc nesting to true on host $HOST_NAME!"
NESTING_COMMAND="lxc config set docker security.nesting true"
run_ssh "$HOST_IP" "$LXC_USER" "$NESTING_COMMAND"

echo "Started setting up docker repository on host $LXC_NAME!"
UPDATE_COMMAND="sudo apt-get update"
run_ssh "$LXC_IP" "$ROOT_USER" "$UPDATE_COMMAND"

INSTALL_DEPENDENCIES="sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release"
run_ssh "$LXC_IP" "$ROOT_USER" "$INSTALL_DEPENDENCIES"

GET_DOCKER_GPG_KEY_COMMAND="curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg"
run_ssh "$LXC_IP" "$ROOT_USER" "$GET_DOCKER_GPG_KEY_COMMAND"

SETUP_DOCKER_REPO_COMMAND="echo \
                             'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
                             $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
run_ssh "$LXC_IP" "$ROOT_USER" "$SETUP_DOCKER_REPO_COMMAND"
echo "Done updating docker repository!"

echo "Started setting up docker engine!"
UPDATE_COMMAND="sudo apt-get update"
run_ssh "$LXC_IP" "$ROOT_USER" "$UPDATE_COMMAND"

INSTALL_DOCKER_COMMAND="sudo apt-get install docker-ce docker-ce-cli containerd.io"
run_ssh "$LXC_IP" "$ROOT_USER" "$INSTALL_DOCKER_COMMAND"
echo "Done setting up docker engine!"

echo "Testing Docker!"
TEST_DOCKER_COMMAND="sudo docker run hello-world"
run_ssh "$LXC_IP" "$ROOT_USER" "$TEST_DOCKER_COMMAND"
echo "Done testing docker!"

echo "Add user $LXC_USER to docker on host $LXC_NAME!"
DOCKER_GROUP_COMMAND="sudo usermod -aG docker $LXC_USER"
run_ssh "$LXC_IP" "$ROOT_USER" "$DOCKER_GROUP_COMMAND"