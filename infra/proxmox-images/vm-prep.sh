#!/usr/bin/env bash

set -ex

# This script runs inside the VM during virt-customize
# This script runs as root, no need for sudo

# install stage 1 pkgs
apt-get -y update
apt-get -y install wget curl vim git gnupg2 software-properties-common apt-transport-https ca-certificates qemu-guest-agent

# enable qemu-guest-agent
systemctl enable qemu-guest-agent

# add docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# add kube repo
curl -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg| gpg --dearmor -o /etc/apt/trusted.gpg.d/k8s.gpg
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# install stage 2 pkgs
apt-get -y update
apt-get -y install containerd.io kubelet kubeadm kubectl

# hold kubeadm, kubectl, kubelet
apt-mark hold kubeadm
apt-mark hold kubelet
apt-mark hold kubectl

# add non-root user for login
useradd kubeuser
mkdir -p /home/kubeuser/.ssh
chown -R kubeuser:kubeuser /home/kubeuser

# disable password for kubeuser sudo
echo 'kubeuser  ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers

# configure sysctl
echo 'net.bridge.bridge-nf-call-ip6tables = 1' >> /etc/sysctl.d/kubernetes.conf && echo 'net.bridge.bridge-nf-call-iptables = 1' >> /etc/sysctl.d/kubernetes.conf && echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.d/kubernetes.conf

# config containerd
mkdir -p /etc/containerd && containerd config default>/etc/containerd/config.toml

# enable containerd
systemctl restart containerd && systemctl enable containerd

# install democratic-csi requirements
apt-get install -y open-iscsi lsscsi sg3-utils multipath-tools scsitools nfs-common cifs-utils libnfs-utils
echo -e \"defaults {\n    user_friendly_names yes\n    find_multipaths yes\n}\" > /etc/multipath.conf