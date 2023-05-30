#!/usr/bin/env bash

set -eux

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
proxmox_ssh="ssh $PROXMOX_USER@$PROXMOX_HOST"

# Terminate the proxmox VMs
for vmid in 9010 9011 9012; do
    $proxmox_ssh "qm stop $vmid"
    $proxmox_ssh "qm destroy $vmid --destroy-unreferenced-disks 1 --purge 1 --skiplock 1"
done

# Delete the image
$proxmox_ssh "qm destroy 9000 --destroy-unreferenced-disks 1 --purge 1 --skiplock 1"

