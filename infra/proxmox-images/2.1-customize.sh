#!/usr/bin/env bash

set -ex
img="focal-server-cloudimg-amd64-big.img"
virt_sysprep="sudo virt-sysprep -a $img"
virt_customize="sudo virt-customize -a $img"
virt_copy_in="sudo virt-copy-in -a $img"

# TODO install systemd unit to set hostname
# Like this https://forums.kali.org/showthread.php?33179-UPDATED-HOWTO-Start-Kali-with-a-new-hostname-on-every-boot

${virt_copy_in} vm-prep.sh /tmp

${virt_customize} --run-command "bash /tmp/vm-prep.sh"
${virt_customize} --run-command "rm -rf /tmp/vm-prep.sh"
${virt_customize} --ssh-inject kubeuser:file:/home/$USER/.ssh/id_rsa.pub

# set root password
password=$(echo $RANDOM | md5sum | head -c 20)
echo "The root user password for this image is: $password"
echo "$password" > .root_password
${virt_customize} --root-password password:$password

${virt_sysprep} --operations "machine-id,udev-persistent-net,dhcp-client-state,dhcp-server-state,-cron-spool,-firewall-rules,-pam-data,-passwd-backups,-ssh-userdir,-user-account"


echo "Finished customize"

