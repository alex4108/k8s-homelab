#!/usr/bin/env bash
set -eux

if [[ "${PROXMOX_HOST}" == "" ]]; then
    echo "no proxmxox host"
    exit 1
fi

bash 1-bootstrap.sh
bash 2-customize.sh
bash 3-scp.sh
bash 4-proxmox-install.sh
bash 5-templatize.sh
