#!/usr/bin/env bash

set -exu

bash make-hosts.sh 
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user=kubeuser kube.yml -i hosts