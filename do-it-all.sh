#!/usr/bin/env bash

# I have no idea if this really works.

make prep
export PROXMOX_HOST=10.127.222.41
export PROXMOX_USER=root
export PM_USER='root@pam'
export PM_PASS=xyz

proxmox_host=${PROXMOX_HOST} make image
proxmox_host=${PROXMOX_HOST} make controlplane
proxmox_host=${PROXMOX_HOST} count=3 make workers

