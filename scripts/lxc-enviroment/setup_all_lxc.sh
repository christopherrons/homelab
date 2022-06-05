#!/bin/bash
# Utility script which creates and add ssh key to all lxc
set -e
source ../setenv.sh

./setup_lxc.sh "$HOMELAB_SERVER_NAME" "$HOMELAB_SERVER_IP" "$DOCKER_LXC_NAME" "$DOCKER_LXC_IP"
./setup_lxc.sh "$HOMELAB_SERVER_NAME" "$HOMELAB_SERVER_IP" "$MISC_LXC_NAME" "$MISC_LXC_IP"
./setup_lxc.sh "$HOMELAB_SERVER_NAME" "$HOMELAB_SERVER_IP" "$JENKINS_MASTER_LXC_NAME" "$JENKINS_MASTER_LXC_IP"
./setup_lxc.sh "$HOMELAB_SERVER_NAME" "$HOMELAB_SERVER_IP" "$JENKINS_AGENT_1_LXC_NAME" "$JENKINS_AGENT_1_LXC_IP"
./setup_lxc.sh "$HOMELAB_SERVER_NAME" "$HOMELAB_SERVER_IP" "$FINANCIAL_SERVICES_1_LXC_NAME" "$FINANCIAL_SERVICES_1_LXC_IP"