.PHONY: prep controlplane image destroy

prep:
	bash prep.sh

image:
	cd ./infra/proxmox-images && PROXMOX_USER=root PROXMOX_HOST=$(proxmox_host) bash make.sh

controlplane:
	cd ./infra/controlplane/terraform && bash run.sh
	cd ./infra/controlplane/ansible && master_vmids="9010 9011 9012" PROXMOX_USER=root PROXMOX_HOST=$(proxmox_host) bash run.sh

destroy:
	PROXMOX_USER=root PROXMOX_HOST=$(proxmox_host) bash destroy.sh

workers:
# take input # of workers
# spin them
# run playbook or use cloud-init to join nodes?

# controlplanes:
# 	# ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user=$(user) infra/controlplane/prepare.yml -i infra/controlplane/hosts
# 	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user=$(user) infra/controlplane/kube.yml -i infra/controlplane/hosts
