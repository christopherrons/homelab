# Homelab Setup

The homelab is run on a small asus machine running ubuntu server. On the server lxc is used to create linux containers
which are used for deploying projects and setting up various tools relevant to DevOps. In this readme you will find
instructions for setting up the homelab.

## Services

* `Docker`
    * Used for running applications in a container
* `Portainer`
    * Used for deploying docker containers
* `Jenkins`
    * Used for CI/CD
* `Homer`
    * Used as a dashboard for the homelab
* `Pi-Hole`
    * Used as a DNS and add blocker
* `Nginx`
    * Routing

## Ansible

Ansible is used to add the ssh key and verify that it exist on the host.

## Setting up LXC

Start by creating a bridge interface on the host machine, this will allow the LXC to get there ip from the router
enabling access from the local network. The interface should be added to `/etc/netplan/xx.yml` using the config
in [netplan.yml](resources/misc/netplan.yml) and once added run `sudo netplan apply`. Then run `lxd init` and when
prompted about creating a new bridge select no and instead add the bridge
specified in [netplan.yml](resources/misc/netplan.yml).

### Creating an LXC

LXC are set up by adding their name to the [setenv.sh](scripts/setenv.sh)
, [setup_all_lxc.sh](scripts/lxc-enviroment/setup_all_lxc.sh) and then
running [setup_all_lxc.sh](scripts/lxc-enviroment/setup_all_lxc.sh)
or [setup_lxc.sh](scripts/lxc-enviroment/setup_lxc.sh). The script will build an ubuntu-21.04 LXC and add the local
computers ssh-key to the root and lxc-user specified in [setenv.sh](scripts/setenv.sh).

## Setup Docker on lxc

Build an lxc and simple run the [setup_all_lxc.sh](scripts/docker/setup_docker_ubuntu-lxc.sh) on the specified
lxc. The script will install docker add the user to the docker group. It will also set the lxc to allow nesting.

## Setup Portainer on Docker

Run the [setup_all_lxc.sh](scripts/docker/apps/setup_portainer.sh) on the specified
lxc, which will install Portainer.

## Setup Homer on Docker

Run the [setup_all_lxc.sh](scripts/docker/apps/setup_homer.sh) on the specified
lxc, which install Homer. Then edit the [config.yml](resources/homer-dashboard/config.yml) and the
run [update_homer.sh](scripts/docker/apps/update_homer.sh).

## Setup Nginx on Docker

Run the [setup_nginx.sh](scripts/docker/apps/setup_nginx.sh) on the specified
lxc, which will install Nginx.

## Setup Jenkins

Create a jenkins master lxc and then run [setup_jenkins-master.sh](scripts/jenkins/setup_jenkins-master.sh). The
remaining jenkins master setup requires som manual work.

### Setup and Startup Agent

Use the [setup_jenkins_agent.sh](scripts/jenkins/setup_jenkins_agent.sh) to create the agent. The agent can then be
started using the command given in the GUI as input to the [start_agent.sh](scripts/jenkins/start_agent.sh) script
(see [tutorial](https://www.youtube.com/watch?v=V2ejGOY_uJI&t=175s)).