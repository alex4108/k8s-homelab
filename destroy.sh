#!/usr/bin/env bash

# no set -e because we might be in half-deployed state and still need cleanup

set -ux

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
proxmox_ssh="ssh $PROXMOX_USER@$PROXMOX_HOST"

# Terminate the proxmox VMs
for vmid in 9010 9011 9012; do
    $proxmox_ssh "qm stop $vmid"
    $proxmox_ssh "qm destroy $vmid --destroy-unreferenced-disks 1 --purge 1 --skiplock 1"
done

# Delete the image
$proxmox_ssh "qm destroy 9000 --destroy-unreferenced-disks 1 --purge 1 --skiplock 1"

# TODO destroy worker VMs

# Blast the terraform states
for path in infra/controlplane/terraform infra/worker/terraform/; do
    rm -rf $SCRIPTPATH/$path/.terraform
    rm -rf $SCRIPTPATH/$path/terraform.tfstate
    rm -rf $SCRIPTPATH/$path/terraform.tfstate.backup
    rm -rf $SCRIPTPATH/$path/.terraform.lock.hcl
    rm -rf $SCRIPTPATH/$path/.terraform.tfstate.lock.info
done

echo "Destroy complete."