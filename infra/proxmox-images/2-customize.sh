#!/usr/bin/env bash

set -ex
img="focal-server-cloudimg-amd64-big.img"
virt_sysprep="sudo virt-sysprep -a $img"
virt_customize="sudo virt-customize -a $img"

# TODO install systemd unit to set hostname
# Like this https://forums.kali.org/showthread.php?33179-UPDATED-HOWTO-Start-Kali-with-a-new-hostname-on-every-boot


# install stage 1 pkgs
${virt_customize} --install wget,curl,vim,git,gnupg2,software-properties-common,apt-transport-https,ca-certificates,qemu-guest-agent

# enable qemu-guest-agent
${virt_customize} --run-command "systemctl enable qemu-guest-agent"

# add docker repo
${virt_customize} --run-command 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -'
${virt_customize} --run-command 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"'

# add kube repo
${virt_customize} --run-command 'curl -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/k8s.gpg'
${virt_customize} --run-command 'curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -'
${virt_customize} --run-command 'echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list'
${virt_customize} --run-command "sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab"
# install stage 2 pkgs
${virt_customize} --install containerd.io,kubelet,kubeadm,kubectl

# hold kubeadm, kubectl, kubelet
${virt_customize} --run-command 'apt-mark hold kubeadm'
${virt_customize} --run-command 'apt-mark hold kubelet'
${virt_customize} --run-command 'apt-mark hold kubectl'

# add non-root user for login
${virt_customize} --run-command 'useradd kubeuser'
${virt_customize} --run-command 'mkdir -p /home/kubeuser/.ssh'
${virt_customize} --ssh-inject kubeuser:file:/home/$USER/.ssh/id_rsa.pub
${virt_customize} --run-command 'chown -R kubeuser:kubeuser /home/kubeuser'

# disable password for kubeuser sudo
${virt_customize} --run-command "echo 'kubeuser  ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers"

# set root password
password=$(echo $RANDOM | md5sum | head -c 20)
echo "The root user password for this image is: $password"
echo "$password" > .root_password
${virt_customize} --root-password password:$password

# enable kernel modules
### I Think this can be skipped - the image is built offline and booted fresh in the hypervisor, which should load them!?
#${virt_customize} --run-command "modprobe overlay && modprobe br_netfilter"

# configure sysctl
${virt_customize} --run-command "echo 'net.bridge.bridge-nf-call-ip6tables = 1' >> /etc/sysctl.d/kubernetes.conf && echo 'net.bridge.bridge-nf-call-iptables = 1' >> /etc/sysctl.d/kubernetes.conf && echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.d/kubernetes.conf"

# reload sysctl
### I Think this can be skipped - the image is built offline and booted fresh in the hypervisor, which should load them!?
#${virt_customize} --run-command "sysctl --system"

# config containerd
${virt_customize} --run-command "mkdir -p /etc/containerd && containerd config default>/etc/containerd/config.toml"

# enable containerd
${virt_customize} --run-command "systemctl restart containerd && systemctl enable containerd"

# install democratic-csi requirements
${virt_customize} --run-command "apt-get install -y open-iscsi lsscsi sg3-utils multipath-tools scsitools"
${virt_customize} --run-command "echo -e \"defaults {\n    user_friendly_names yes\n    find_multipaths yes\n}\" > /etc/multipath.conf"

${virt_sysprep} --operations "-cron-spool,-firewall-rules,-pam-data,-passwd-backups,-ssh-userdir,-user-account"

echo "Finished customize"