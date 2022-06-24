#!/bin/bash
# Utility script that runs multiple setup scripts.
set -e
source setenv.sh

CURRENT_DIR="$(pwd)"
cd lxc-enviroment && bash setup_all_lxc.sh "$HOMELAB_SERVER" && cd "$CURRENT_DIR"
cd "$CURRENT_DIR"/docker && bash setup_docker_ubuntu-lxc.sh "$HOMELAB_SERVER_NAME" "$HOMELAB_SERVER_IP" "$DOCKER_LXC_NAME" "$DOCKER_LXC_IP" && cd "$CURRENT_DIR"
cd "$CURRENT_DIR"/docker/apps && bash setup_homer.sh "$DOCKER_LXC_IP" && cd "$CURRENT_DIR"
cd "$CURRENT_DIR"/docker/apps && bash update_homer.sh "$DOCKER_LXC_IP" && cd "$CURRENT_DIR"
cd "$CURRENT_DIR"/docker/apps && bash setup_portainer.sh "$DOCKER_LXC_IP" && cd "$CURRENT_DIR"
cd "$CURRENT_DIR"/docker/apps && bash setup_nginx.sh "$DOCKER_LXC_IP" && cd "$CURRENT_DIR"
cd "$CURRENT_DIR"/docker/apps && bash setup_monitoring.sh "$DOCKER_LXC_IP" && cd "$CURRENT_DIR"
cd "$CURRENT_DIR"/misc && bash setup_pi-hole.sh "$MISC_LXC_IP" && cd "$CURRENT_DIR"
cd "$CURRENT_DIR"/jenkins && bash setup_jenkins-master.sh "$JENKINS_MASTER_LXC_IP" && cd "$CURRENT_DIR"
cd "$CURRENT_DIR"/jenkins && bash setup_jenkins-agent.sh "$JENKINS_AGENT_1_LXC_IP" && cd "$CURRENT_DIR"