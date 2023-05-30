#!/usr/bin/env bash
set -ex
ssh $PROXMOX_USER@$PROXMOX_HOST "qm template 9000"
ssh $PROXMOX_USER@$PROXMOX_HOST "cat /etc/pve/qemu-server/9000.conf  | grep name" > .template_server_name
echo "Template created!  Time to spin some nodes!"