#!/usr/bin/env bash
set -ex

#sudo apt update -y && sudo apt install libguestfs-tools linux-image-generic -y
if [[ ! -f "focal-server-cloudimg-amd64.img" ]]; then
    wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
fi

# Grow the disk
# We need a bigger disk for container cache, packages, etc.
rm -rf focal-server-cloudimg-amd64-big.img
qemu-img create -f qcow2 -o preallocation=metadata focal-server-cloudimg-amd64-big.img 50G
sudo virt-resize --expand /dev/sda1 focal-server-cloudimg-amd64.img focal-server-cloudimg-amd64-big.img
sudo virt-customize -a focal-server-cloudimg-amd64-big.img --run-command "grub-install /dev/sda"

# Rescue it:
# sudo virt-rescue focal-server-cloudimg-amd64-big.img  <<_EOF_
# mkdir /mnt
# mount /dev/sda3 /mnt
# mount --bind /dev /mnt/dev
# mount --bind /proc /mnt/proc
# mount --bind /sys /mnt/sys
# chroot /mnt
# grub-install /dev/sda
# _EOF_

echo "Finished bootstrap"