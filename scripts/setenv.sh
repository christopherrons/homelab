#!/bin/bash
# Utility script that inits user names used in scripts.

# Hosts Names nad IP
ROUTER_IP=192.168.50.1

HOMELAB_SERVER_NAME=homelab
HOMELAB_SERVER_IP=192.168.50.10

DOCKER_LXC_NAME=docker
DOCKER_LXC_IP=192.168.50.11

MISC_LXC_NAME=misc
MISC_LXC_IP=192.168.50.12

JENKINS_MASTER_LXC_NAME=jenkins-master
JENKINS_MASTER_LXC_IP=192.168.50.13

JENKINS_AGENT_1_LXC_NAME=jenkins-agent-1
JENKINS_AGENT_1_LXC_IP=192.168.50.14

FINANCIAL_SERVICES_1_LXC_NAME=financial-services-1
FINANCIAL_SERVICES_1_LXC_IP=192.168.50.15

# Users
ROOT_USER=root
HOMELAB_USER=herron
LXC_USER=herron

#Misc
DEFAULT_PASSWD=herron1
LOCAL_DOMAIN=int.herron.se
