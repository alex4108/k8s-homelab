#!/usr/bin/env bash
set -eux

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

join_command=$(cat $SCRIPTPATH/../controlplane/ansible/.join_command)
cloudinit="$SCRIPTPATH/kube-worker-cloudinit-user.yml"

cp $SCRIPTPATH/../proxmox-images/kube-cloudinit-user.yml $cloudinit

echo "  - $join_command" >> $cloudinit

scp $cloudinit $PROXMOX_USER@$PROXMOX_HOST:/var/lib/vz/snippets/kube-worker-cloudinit-user.yml