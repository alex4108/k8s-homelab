resource "proxmox_vm_qemu" "controlplane_1" {
  vmid        = 9010
  name        = var.cp1_hostname
  target_node = local.target_node
  clone       = var.template_id
  onboot      = true # Start nodes on boot
  agent       = 1    # Qemu guest agent
  memory      = var.controlplane_memory
  cores       = var.controlplane_cpu
  scsihw      = "virtio-scsi-pci"
  cicustom    = "network=local:snippets/kube-cloudinit-network.yml,user=local:snippets/cp-1.yml"
  vga {
    type = "virtio"
  }
}

resource "time_sleep" "wait_1" {
  depends_on = [ proxmox_vm_qemu.controlplane_1 ]
  create_duration = "3m"
}

resource "proxmox_vm_qemu" "controlplane_2" {
  depends_on  = [time_sleep.wait_1]
  vmid        = 9011
  name        = var.cp2_hostname
  target_node = local.target_node
  clone       = var.template_id
  onboot      = true # Start nodes on boot
  agent       = 1    # Qemu guest agent
  memory      = var.controlplane_memory
  cores       = var.controlplane_cpu
  scsihw      = "virtio-scsi-pci"
  cicustom    = "network=local:snippets/kube-cloudinit-network.yml,user=local:snippets/cp-2.yml"
  vga {
    type = "virtio"
  }
}


resource "time_sleep" "wait_2" {
  depends_on = [proxmox_vm_qemu.controlplane_2]
  create_duration = "3m"
}

resource "proxmox_vm_qemu" "controlplane_3" {
  depends_on  = [time_sleep.wait_2]
  vmid        = 9012
  name        = var.cp3_hostname
  target_node = local.target_node
  clone       = var.template_id
  onboot      = true # Start nodes on boot
  agent       = 1    # Qemu guest agent
  memory      = var.controlplane_memory
  cores       = var.controlplane_cpu
  scsihw      = "virtio-scsi-pci"
  cicustom    = "network=local:snippets/kube-cloudinit-network.yml,user=local:snippets/cp-3.yml"
  vga {
    type = "virtio"
  }
}

