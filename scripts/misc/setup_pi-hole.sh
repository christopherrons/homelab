#!/bin/bash
# Utility script that installs pi-hole.
set -e
source ../setenv.sh

if [[ ${1+x} ]]; then
  LXC_IP="$1"
else
  echo "Failed... Host ip required!"
  exit 1
fi

ssh -tt "$ROOT_USER"@"$LXC_IP" 'sudo curl -sSL https://install.pi-hole.net | bash'
ssh -tt "$ROOT_USER"@"$LXC_IP" 'pihole -a -p'


ssh -tt "$ROOT_USER"@"$LXC_IP" "echo $HOMELAB_SERVER_IP $HOMELAB_SERVER_NAME.$LOCAL_DOMAIN >> /etc/pihole/custom.list"
ssh -tt "$ROOT_USER"@"$LXC_IP" "echo $DOCKER_LXC_IP $DOCKER_LXC_NAME.$LOCAL_DOMAIN >> /etc/pihole/custom.list"
ssh -tt "$ROOT_USER"@"$LXC_IP" "echo $JENKINS_MASTER_LXC_IP $JENKINS_MASTER_LXC_NAME.$LOCAL_DOMAIN >> /etc/pihole/custom.list"
ssh -tt "$ROOT_USER"@"$LXC_IP" "echo $JENKINS_AGENT_1_LXC_IP $JENKINS_AGENT_1_LXC_NAME.$LOCAL_DOMAIN >> /etc/pihole/custom.list"
ssh -tt "$ROOT_USER"@"$LXC_IP" "echo $MISC_LXC_IP $MISC_LXC_NAME.$LOCAL_DOMAIN >> /etc/pihole/custom.list"
ssh -tt "$ROOT_USER"@"$LXC_IP" "echo $FINANCIAL_SERVICES_1_LXC_IP $FINANCIAL_SERVICES_1_LXC_NAME.$LOCAL_DOMAIN >> /etc/pihole/custom.list"

