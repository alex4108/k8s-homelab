resource "null_resource" "wait" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "while [[ $(cat counter) != \"${var.index}\" ]]; do sleep 5; done; sleep 3;"
  }
}

resource "proxmox_vm_qemu" "worker" {
  depends_on = [null_resource.wait]
  vmid = var.vmid
  name        = "k8s-worker-${local.timestamp}-${var.vmid}"
  target_node = var.target_node
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

resource "null_resource" "inc" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "sleep 180 && echo \"${var.index + 1}\" > counter"
  }
  depends_on = [proxmox_vm_qemu.worker]
}