#!/usr/bin/env bash

set -exu

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook keys.yml -i hosts