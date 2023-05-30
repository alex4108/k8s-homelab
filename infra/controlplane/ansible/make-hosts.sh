#!/usr/bin/env bash
set -exu

## Get IPs of masters, export to ansible inventory
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
rm -rf $SCRIPTPATH/hosts
cp $SCRIPTPATH/hosts.tpl $SCRIPTPATH/hosts

proxmox_ssh="ssh $PROXMOX_USER@$PROXMOX_HOST"

master_ips=()
for vmid in $master_vmids; do
    interfaces=$($proxmox_ssh "qm guest cmd $vmid network-get-interfaces")
    ip=$(echo "$interfaces" | jq -r '.[]."ip-addresses"[] | select(."ip-address-type" == "ipv4") | select(.prefix == 24)."ip-address"' | head -n 1)
    master_ips+=("$ip")    
done

echo "${master_ips[@]}"

i=1
for ip in "${master_ips[@]}"; do
    sed -i "s/{{ master_${i}_ip }}/$ip/g" $SCRIPTPATH/hosts
    i=$(( $i + 1 ))
done