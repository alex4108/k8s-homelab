#!/usr/bin/env bash

set -exu

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook mail.yml -i hosts --extra-vars "sasl=$(cat .sasl) maildomain=$(cat .maildomain)"