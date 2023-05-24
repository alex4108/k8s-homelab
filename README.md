# K8S Homelab

This is a repo holding scripts I used to deploy a kubernetes cluster on Proxmox at home using 8 cores and 32GB RAM.

Needs `make`, `python3`

## Get Started

```
make prep
```

## Infrastructure

This dir contains ansible code to get master nodes off the ground.
We'll try to configure workers using cloud-init so they're not long-lived and can be easily recycled.

Do this on your nodes first

```
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
```


```
username=THE-SAME-USERNAME-YOU-RAN-AS-ABOVE make coordinators
```