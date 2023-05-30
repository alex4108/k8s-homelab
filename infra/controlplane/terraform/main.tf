resource "proxmox_vm_qemu" "controlplane" {
  for_each    = local.controlplanes
  vmid        = each.value.id
  name        = "k8s-master-${local.timestamp}-${each.key}"
  target_node = each.value.target_node
  clone       = var.template_id
  onboot      = true # Start nodes on boot
  agent       = 1    # Qemu guest agent
  hastate     = each.value.hastate
  hagroup     = each.value.hagroup
  memory      = var.controlplane_memory
  cores       = var.controlplane_cpu
  scsihw      = "virtio-scsi-pci"
  cicustom    = "network=local:snippets/kube-cloudinit-network.yml,user=local:snippets/kube-cloudinit-user.yml"
  vga {
    type = "virtio"
  }
}