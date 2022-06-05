#!/bin/bash
# Utility script that runs multiple setup scripts.
set -e
source setenv.sh

cd lxc-enviroment && bash setup_all_lxc.sh "$HOMELAB_SERVER" && cd -
cd docker && bash setup_docker_ubuntu-lxc.sh "$HOMELAB_SERVER" "$DOCKER_LXC" && cd -
cd docker/apps && bash setup_homer.sh "$DOCKER_LXC" && cd -
cd docker/apps && bash update_homer.sh "$DOCKER_LXC" && cd -
cd docker/apps && bash setup_portainer.sh "$DOCKER_LXC" && cd -
cd misc && bash setup_pi-hole.sh "$MISC_LXC" && cd -
cd jenkins && bash setup_jenkins-master.sh "$JENKINS_MASTER_LXC" && cd -
cd jenkins && bash setup_jenkins-agent.sh "$JENKINS_AGENT_1_LXC" && cd -


