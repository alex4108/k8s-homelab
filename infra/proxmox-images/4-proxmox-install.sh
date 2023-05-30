#!/usr/bin/env bash
set -ex
ssh $PROXMOX_USER@$PROXMOX_HOST "sh /tmp/build-template.sh"

echo "VM 9000 built."
