
variable "template_id" {
  description = "The VM ID of the template node to deploy from"
  default     = "kube-ubuntu-2004-20230529-220351"
  type        = string
}

variable "controlplane_memory" {
  description = "MB of RAM to allocate for control planes"
  type        = number
  default     = 2048
}

variable "controlplane_cpu" {
  description = "CPU cores to allocate for control planes"
  type        = number
  default     = 2
}

variable "cp1_hostname" { 
  type = string
}

variable "cp2_hostname" { 
  type = string
}

variable "cp3_hostname" { 
  type = string
}



locals {
  timestamp   = replace(replace(timestamp(), "-", ""), ":", "")
  target_node = "pve-1"
}

