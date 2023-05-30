
variable "template_id" { 
    description = "The VM ID of the template node to deploy from"
    default = "kube-ubuntu-2004-20230529-220351"
    type = string
}

variable "memory" { 
    description = "MB of RAM to allocate for workers"
    type = number
    default = 2048
}

variable "cpu" { 
    description = "CPU cores to allocate for workers"
    type = number
    default = 2
}

variable "workers" { 
    description = "count of worker nodes to deploy"
    type = number
    default = 2
}

locals {
    timestamp = replace(replace(timestamp(), "-", ""), ":", "")
    target_node = "pve-1"
    workers = range(1, var.workers)
    start_id = "920"
}

