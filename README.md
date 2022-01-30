# Homelab Setup

Scripts and instructions for setting up mt homelab.

## Services

* `Proxmox`
    * Used for creating Linux Containers
* `Portainer`
    * Used for deploying docker containers
* `Docker`
    * Used for running applications in a container
* `Jenkins`
    * Used for Ci/Cd
* `Homer`
    * Used as a dashboard for the homelab

## Proxmox Setup

1. Download [Proxmox](https://proxmox.com/en/).
2. Flash it to a USB drive using e.g. [Etcher](https://www.balena.io/etcher/).
3. Insert drive and install.
    1. [Guide to install Proxmox](https://www.youtube.com/watch?v=7OVaWaqO2aU&t=95s).
4. Create some LXC.
    1. [Guide to create LXC](https://www.youtube.com/watch?v=cyjXxsQ8Igw).
    2. Allow root ssh by going to `/etc/ssh/sshd_config` and setting `PasswordRootLoging yes`.

## Docker Setup

### Requirements

* SSH public key located on LXC.
* The LXC had to be unprivileged and keycl set to true.

### Installation

Run the script [setup_docker_ubuntu.sh](scripts/setup_docker_ubuntu.sh). For reference se the
official [documentation](https://docs.docker.com/engine/install/ubuntu/).

## Portainer Setup

### Requirements

* SSH public key located on LXC.
* Docker has to be installed.

### Installation

Run the script [setup_portainer.sh](scripts/setup_portainer.sh).

## Homer-Dashboard Setup

### Requirements

* Docker has to be installed.

# Installation

Run the script [setup_homer.sh](scripts/setup_homer.sh) or use portainer, see
this [youtube guide](https://www.youtube.com/watch?v=9iTPm45EmxM). Official
repo [Git](https://github.com/bastienwirtz/homer).