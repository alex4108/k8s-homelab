#!/usr/bin/env bash

set -eux

# qemu-img convert -O qcow2 focal-server-cloudimg-amd64-big.img focal-server-cloudimg-amd64-small.img

tar cvfz focal-server-cloudimg-amd64-big.img.tar.gz focal-server-cloudimg-amd64-big.img

scp ./focal-server-cloudimg-amd64-big.img.tar.gz $PROXMOX_USER@$PROXMOX_HOST:/tmp/focal-server-cloudimg-amd64-big.img.tar.gz
scp ./build-template.sh $PROXMOX_USER@$PROXMOX_HOST:/tmp/build-template.sh
ssh $PROXMOX_USER@$PROXMOX_HOST "mkdir -p /var/lib/vz/snippets"
scp ./cloud-config-user.yml $PROXMOX_USER@$PROXMOX_HOST:/var/lib/vz/snippets/kube-cloudinit-user.yml
scp ./cloud-config-network.yml $PROXMOX_USER@$PROXMOX_HOST:/var/lib/vz/snippets/kube-cloudinit-network.yml
ssh $PROXMOX_USER@$PROXMOX_HOST "cd /tmp && tar xvfz focal-server-cloudimg-amd64-big.img.tar.gz"

echo "SCP Complete"