.PHONY: prep controlplane image destroy

prep:
	bash prep.sh

image:
	cd ./infra/proxmox-images && PROXMOX_USER=root PROXMOX_HOST=$(proxmox_host) bash make.sh

controlplane:
	cd ./infra/controlplane/terraform && bash run.sh
	cd ./infra/controlplane/ && bash wait.sh
	cd ./infra/controlplane/ansible && master_vmids="9010 9011 9012" IP_RANGE="10.127.222.20-10.127.222.50" PROXMOX_USER=root PROXMOX_HOST=$(proxmox_host) bash run.sh

destroy:
	PROXMOX_USER=root PROXMOX_HOST=$(proxmox_host) bash destroy.sh

workers:
	cd ./infra/workers && bash run.sh
