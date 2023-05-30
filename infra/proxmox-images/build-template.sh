#!/usr/bin/env bash
set -ex

export ts=$(date +"%Y%m%d-%H%M%S")

qm create 9000 --name "kube-ubuntu-2004-$ts" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 9000 /tmp/focal-server-cloudimg-amd64-big.img local-zfs
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --cicustom user=local:snippets/kube-cloudinit-user.yml
qm set 9000 --cicustom network=local:snippets/kube-cloudinit-network.yml
qm set 9000 --ide2 local-zfs:cloudinit
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1

