resource "proxmox_vm_qemu" "worker" {
  for_each = local.workers
  vmid = tonumber("${local.start_id}${each.key}")
  name        = "k8s-worker-${local.timestamp}-${each.key}"
  target_node = local.target_node
  clone = var.template_id 
  onboot = true # Start nodes on boot
  agent = 1 # Qemu guest agent
  memory = var.memory
  cores = var.cpu
  scsihw = "virtio-scsi-pci"
  cicustom = "network=local:snippets/kube-cloudinit-network.yml,user=local:snippets/kube-worker-cloudinit-user.yml"
  vga {
    type = "virtio"
  }
}
