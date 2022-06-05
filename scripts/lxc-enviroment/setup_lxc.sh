#!/bin/bash
# Utility script which installs lxc and set ssh key
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

echo "Add key to host: $HOST_NAME"
ansible-playbook ../../ansible/playbooks/authorized_keys.yml --verbose -i ../../ansible/inventory/hosts.yml

SSH_KEY="$(cat  ~/.ssh/id_rsa.pub)"
echo "On host $HOST_NAME, creating lxc: $LXC_NAME."
run_ssh "$HOST_IP" "$HOMELAB_USER" "lxc launch ubuntu:21.04 $LXC_NAME"
sleep 5

echo "On host $LXC_NAME, adding ssh key to user $ROOT_USER."
run_ssh "$HOST_IP" "$HOMELAB_USER"  "lxc exec $LXC_NAME -- bash -c \"touch /root/.ssh/authorized_keys && echo $SSH_KEY >> /$ROOT_USER/.ssh/authorized_keys\""

echo "On host $LXC_NAME, changing ubuntu/$ROOT_USER user password."
run_ssh "$HOST_IP" "$HOMELAB_USER" "lxc exec $LXC_NAME -- bash -c \"echo '$ROOT_USER:$DEFAULT_PASSWD' | sudo chpasswd\""
run_ssh "$HOST_IP" "$HOMELAB_USER" "lxc exec $LXC_NAME -- bash -c \"echo 'ubuntu:$DEFAULT_PASSWD' | sudo chpasswd\""

echo "On host $LXC_NAME, add static ip."
NETPLAN_CONFIG="$(cat <<-END
network:
  ethernets:
    eth0:
      addresses: [$LXC_IP/24]
      dhcp4: false
      gateway4: $ROUTER_IP
      nameservers:
        addresses: [$MISC_LXC_IP]
  version: 2
END
  )"

echo "$NETPLAN_CONFIG" >> 50-cloud-init.yaml
scp 50-cloud-init.yaml "$HOMELAB_USER"@"$HOST_IP":
run_ssh "$HOST_IP" "$HOMELAB_USER" "lxc exec $LXC_NAME -- bash -c \"rm /etc/netplan/50-cloud-init.yaml\""
run_ssh "$HOST_IP" "$HOMELAB_USER" "lxc file push 50-cloud-init.yaml $LXC_NAME/etc/netplan/"
run_ssh "$HOST_IP" "$HOMELAB_USER" "lxc exec $LXC_NAME -- bash -c \"netplan apply\""
rm 50-cloud-init.yaml
run_ssh "$HOST_IP" "$HOMELAB_USER" "rm 50-cloud-init.yaml"

echo "On host $LXC_NAME, changing ubuntu username to $LXC_USER."
run_ssh "$LXC_IP" "$ROOT_USER" "usermod -l $LXC_USER  ubuntu && sudo usermod -d /home/$LXC_USER -m $LXC_USER"

echo "On host $LXC_NAME, adding ssh key to user $LXC_USER."
run_ssh "$HOST_IP" "$HOMELAB_USER" "lxc exec $LXC_NAME -- bash -c \"touch /home/$LXC_USER/.ssh/authorized_keys && echo $SSH_KEY >> /home/$LXC_USER/.ssh/authorized_keys\""





