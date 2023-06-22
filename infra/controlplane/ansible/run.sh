#!/usr/bin/env bash

set -exu

bash make-hosts.sh
rm -rf metallb-conf.yml
cp metallb-conf.tpl metallb-conf.yml
sed -i "s/{{ ip_range }}/$IP_RANGE/g" metallb-conf.yml
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user=kubeuser kube.yml -i hosts