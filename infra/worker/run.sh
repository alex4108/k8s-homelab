#!/usr/bin/env bash
set -eux

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

export TF_VAR_template_id="$(cat $SCRIPTPATH/../proxmox-images/.template_server_name | awk '{print $2}')"
terraform init

if [[ "$PM_USER" == "" || "$PM_PASS" == "" ]]; then
    echo "no proxmox credentials set!"
    exit 1
fi

terraform plan -out=plan.out
bash $SCRIPTPATH/../controlplane/terraform/approve.sh
terraform apply -parallelism=1 plan.out 
