# Homelab Setup

The homelab is run on a small Asus machine running ubuntu server. On the server lxc is used to create linux containers
which are used for deploying projects and setting up various tools relevant to DevOps. In this readme you will find
instructions for setting up the homelab.

## Services

* `Docker`
    * Used for running applications in a container
* `Portainer`
    * GUI for deploying docker containers
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
The [run-host-setup-playbook.sh](scripts/lxc-enviroment/run-host-setup-playbook.sh) can be used to add keys and update
multiple hosts.

## Setting up LXC

Start by creating a bridge interface on the host machine, using a static ip. The interface should be added
to `/etc/netplan/xx.yml` using the config
in [netplan.yml](resources/misc/netplan.yml) and once added run `sudo netplan apply`. Then run `lxd init` and when
prompted about creating a new bridge select no and instead add the bridge
specified in [netplan.yml](resources/misc/netplan.yml).

### Creating an LXC

LXC are set up by adding their name and static ip to the [setenv.sh](scripts/setenv.sh)
, [setup_all_lxc.sh](scripts/lxc-enviroment/setup_all_lxc.sh) and then
running [setup_all_lxc.sh](scripts/lxc-enviroment/setup_all_lxc.sh)
or [setup_lxc.sh](scripts/lxc-enviroment/setup_lxc.sh). The script will build an ubuntu-21.04 LXC and add the local
computers ssh-key to the root and lxc-user specified in [setenv.sh](scripts/setenv.sh).

## Setup Docker in lxc

Build an lxc and simple run the [setup_docker_ubuntu_lxc.sh](scripts/docker/setup_docker_ubuntu-lxc.sh) for a specified
lxc. The script will install docker add the user to the docker group. It will also set the lxc to allow nesting.

## Setup Portainer in Docker

Run the [setup_portainer.sh](scripts/docker/apps/setup_portainer.sh) to install which will install Portainer.

## Setup Homer in Docker

Run the [setup_homer.sh](scripts/docker/apps/setup_homer.sh) on the specified
lxc, which install Homer. Then edit the [config.yml](resources/homer-dashboard/config.yml) and the
run [update_homer.sh](scripts/docker/apps/update_homer.sh).

## Setup Nginx in Docker

Run the [setup_nginx.sh](scripts/docker/apps/setup_nginx.sh) to will install Nginx.

## Setup Pihole 

Run the [setup_pi-hole.sh](scripts/misc/setup_pi-hole.sh) to install pi-hole and create DNS for all lxc.
Set the domain on the router the same as in [setenv.sh](scripts/setenv.sh). 

## Setup Jenkins

Create a jenkins master lxc and then run [setup_jenkins-master.sh](scripts/jenkins/setup_jenkins-master.sh). The
remaining jenkins master setup requires som manual work.

### Setup and Startup Agent

Use the [setup_jenkins_agent.sh](scripts/jenkins/setup_jenkins-agent.sh) to create the agent. The agent can then be
started using the command given in the GUI as input to the [start_agent.sh](scripts/jenkins/start_agent.sh) script
(see [tutorial](https://www.youtube.com/watch?v=V2ejGOY_uJI&t=175s)).