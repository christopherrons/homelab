#!/bin/bash
# Utility script which installs lxc and set ssh key
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

echo "Add key to host: $HOST"
ansible-playbook ../../ansible/playbooks/authorized_keys.yml --verbose -i ../../ansible/inventory/hosts.yml

SSH_KEY="$(cat  ~/.ssh/id_rsa.pub)"
echo "On host $HOST, creating lxc: $LXC."
run_ssh "$HOST" "$LXC_USER" "lxc launch ubuntu:21.04 $LXC"
sleep 10

echo "On host $LXC, adding ssh key to user $ROOT_USER."
run_ssh "$HOST" "$LXC_USER"  "lxc exec $LXC -- bash -c \"touch /root/.ssh/authorized_keys && echo $SSH_KEY >> /$ROOT_USER/.ssh/authorized_keys\""

echo "On host $LXC, changing ubuntu/$ROOT_USER user password."
run_ssh "$HOST" "$LXC_USER" "lxc exec $LXC -- bash -c \"echo '$ROOT_USER:$DEFAULT_PASSWD' | sudo chpasswd\""
run_ssh "$HOST" "$LXC_USER" "lxc exec $LXC -- bash -c \"echo 'ubuntu:$DEFAULT_PASSWD' | sudo chpasswd\""

echo "On host $LXC, changing ubuntu username to $LXC_USER."
run_ssh "$LXC" "$ROOT_USER" "usermod -l $LXC_USER  ubuntu && sudo usermod -d /home/$LXC_USER -m $LXC_USER"

echo "On host $LXC, adding ssh key to user $LXC_USER."
run_ssh "$HOST" "$LXC_USER" "lxc exec $LXC -- bash -c \"touch /home/$LXC_USER/.ssh/authorized_keys && echo $SSH_KEY >> /home/$LXC_USER/.ssh/authorized_keys\""

