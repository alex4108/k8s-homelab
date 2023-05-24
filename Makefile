.PHONY: prep coordinators

prep:
	sudo apt-get -y install python3 python3-pip
	python3 -m pip install --user ansible

coordinators:
	# ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user=$(user) infra/coordinator/prepare.yml -i infra/coordinator/hosts
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user=$(user) infra/coordinator/kube.yml -i infra/coordinator/hosts
