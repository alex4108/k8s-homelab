#!/usr/bin/env bash

read -p "Plan OK? [Y/n]" input
if [[ "${input}" == "" || "${input}" == "Y" || "${input}" == "y" ]]; then
    echo "Approved"
    exit 0
else
    echo "Rejected"
    exit 1
fi