#!/usr/bin/env bash
set -eux
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

ts=$(date +"%Y%m%d%H%M%S")

buildCPFiles() { 
    for x in 1 2 3; do
        cloudInitFile="cp-${x}.yml"
        rm -rf ${cloudInitFile}
        uuid=$(uuidgen | head -c 6)
        newHostname="ubuntu-2004-${ts}-${uuid}"
        cp ../../proxmox-images/cloud-config-user.yml ./${cloudInitFile}
        sed -i "s/hostname: ubuntu.\*/hostname: ${newHostname}/" ${cloudInitFile}
        scp ./${cloudInitFile} root@$PROXMOX_HOST:/var/lib/vz/snippets/${cloudInitFile}
        export TF_VAR_cp${!x}hostname="${newHostname}"
    done
}

export TF_VAR_template_id="$(cat $SCRIPTPATH/../../proxmox-images/.template_server_name | awk '{print $2}')"
terraform init

if [[ "$PM_USER" == "" || "$PM_PASS" == "" ]]; then
    echo "no proxmox credentials set!"
    exit 1
fi

buildCPFiles

terraform plan -out=plan.out
#bash $SCRIPTPATH/approve.sh
terraform apply -parallelism=1 plan.out 
bash $SCRIPTPATH/post.sh