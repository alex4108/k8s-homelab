#!/usr/bin/env bash
set -eux

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

join_command=$(cat $SCRIPTPATH/../controlplane/ansible/.join_command)
cloudinit="$SCRIPTPATH/kube-worker-cloudinit-user.yml"

cp $SCRIPTPATH/../proxmox-images/kube-cloudinit-user.yml $cloudinit

echo "  - $join_command" >> $cloudinit

for x in 1 2 3; do
    cp $cloudinit ./worker-${x}.yml
    sed -i ./worker-${x}.yml
    scp $cloudinit $PROXMOX_USER@$PROXMOX_HOST:/var/lib/vz/snippets/worker-${x}.yml
done