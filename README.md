# K8S Homelab

This is a repo holding scripts I used to deploy a kubernetes cluster on Proxmox at home using 8 cores and 32GB RAM.

Needs `make`, `python3`

## Get Started

```
make prep
```

## Infrastructure

### Make Images

This step creates an Ubuntu 20 template to be used for faster deployment of VMs.

* Ensure you can login as root using SSH to the proxmox host before running make image
* The current user's pubkey will be added to `kubeuser` on the image
* The root password of the image will be displayed on the console during creation!
* Review cloud-config-user.yml to ensure your desired username/ssh keys are set as well

`proxmox_host=proxmox_ip_or_dns make image` 

### Deploy control plane

* Ensure the local block target_node names are updated to reflect your environment
* Ensure the terraform.tf has your proxmox IP/domain
* Ensure the ansible playbook has the right loadbalancer endpoint for your deployment

```
export PM_USER="your proxmox username"
export PM_PASS="your proxmox password"
proxmox_host=proxmox_ip_or_dns make controlplane
```

This step might need some TLC because the proxmox provider is bugged - https://github.com/Telmate/terraform-provider-proxmox/issues/782

This step will yield a 3-node control plane

### Deploy workers via template

* Terraform?

### Destroy the environment

```make destroy```

* Deletes the VMs and templates

### Clean up local diskspace