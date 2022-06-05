#!/bin/bash
# Utility script that runs ansible playbooks
ansible-playbook ../../ansible/playbooks/host-setup.yml --verbose -i ../../ansible/inventory/hosts.yml