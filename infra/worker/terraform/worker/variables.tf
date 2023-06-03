
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

variable "vmid" { 
    description = "vmid to use"
    type = number
}

variable "target_node" { 
    description = "node to deploy on"
    type = string
}

variable "index" {
    type = number
}

locals {
    timestamp = replace(replace(timestamp(), "-", ""), ":", "")
}

