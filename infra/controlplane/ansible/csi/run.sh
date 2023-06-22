#!/usr/bin/env bash
# !! WIP !!
# https://jonathangazeley.com/2021/01/05/using-truenas-to-provide-persistent-storage-for-kubernetes/
set -ex

wget https://raw.githubusercontent.com/democratic-csi/charts/master/stable/democratic-csi/examples/freenas-nfs.yaml
## Modify this heavily...

wget https://raw.githubusercontent.com/democratic-csi/charts/master/stable/democratic-csi/examples/freenas-iscsi.yaml
## Modify this heavily...

# Install them using helm


# TODO Wrap in ansible playbook