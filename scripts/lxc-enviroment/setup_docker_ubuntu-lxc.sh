#!/bin/bash
# exit when any command fails
set -e
source ../setenv.sh

if [[ ${1+x} ]]; then
  HOST="$1"
else
  echo "Failed... Hostname required!"
  exit 1
fi

if [[ ${2+x} ]]; then
  LXC="$2"
else
  echo "Failed... LXC required!"
  exit 1
fi

function run_ssh() {
  host="$1"
  user="$2"
  command="$3"
  ssh -o StrictHostKeyChecking=no -tt "$user"@"$host" "$command"
  echo ""
}

echo "Set lxc nesting to true on host $HOST!"
NESTING_COMMAND="lxc config set docker security.nesting true"
run_ssh "$HOST" "$LXC_USER" "$NESTING_COMMAND"

echo "Started setting up docker repository on host $LXC!"
UPDATE_COMMAND="sudo apt-get update"
run_ssh "$LXC" "$ROOT_USER" "$UPDATE_COMMAND"

INSTALL_DEPENDENCIES="sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release"
run_ssh "$LXC" "$ROOT_USER" "$INSTALL_DEPENDENCIES"

GET_DOCKER_GPG_KEY_COMMAND="curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg"
run_ssh "$LXC" "$ROOT_USER" "$GET_DOCKER_GPG_KEY_COMMAND"

SETUP_DOCKER_REPO_COMMAND="echo \
                             'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
                             $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
run_ssh "$LXC" $ROOT_USER "$SETUP_DOCKER_REPO_COMMAND"
echo "Done updating docker repository!"

echo "Started setting up docker engine!"
UPDATE_COMMAND="sudo apt-get update"
run_ssh "$LXC" "$ROOT_USER" "$UPDATE_COMMAND"

INSTALL_DOCKER_COMMAND="sudo apt-get install docker-ce docker-ce-cli containerd.io"
run_ssh "$LXC" "$ROOT_USER" "$INSTALL_DOCKER_COMMAND"
echo "Done setting up docker engine!"

echo "Testing Docker!"
TEST_DOCKER_COMMAND="sudo docker run hello-world"
run_ssh "$LXC" "$ROOT_USER" "$TEST_DOCKER_COMMAND"
echo "Done testing docker!"

echo "Add user $LXC_USER to docker on host $LXC!"
DOCKER_GROUP_COMMAND="sudo usermod -aG docker $LXC_USER"
run_ssh "$LXC" "$LXC_USER" "$DOCKER_GROUP_COMMAND"