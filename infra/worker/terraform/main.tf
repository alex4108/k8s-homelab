
resource "null_resource" "set_initial_state" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "echo \"1\" > counter"
  }
}



module "worker" {
  for_each = local.workers
  vmid    = tonumber("${var.start_id}${each.value}")
  index = each.value
  cpu = var.cpu
  memory = var.memory
  target_node = local.target_node
  template_id = var.template_id
  source   = "./worker"
}
