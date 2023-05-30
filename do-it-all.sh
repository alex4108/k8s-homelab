#!/usr/bin/env bash

make prep
export PROXMOX_HOST=10.127.222.41
export PROXMOX_USER=root

proxmox_host=${PROXMOX_HOST} make image
proxmox_host=${PROXMOX_HOST} make controlplane
proxmox_host=${PROXMOX_HOST} make workers

