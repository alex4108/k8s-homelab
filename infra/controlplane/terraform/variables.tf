
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


locals {
  timestamp   = replace(replace(timestamp(), "-", ""), ":", "")
  target_node = "pve-1"
  controlplanes = {
    "1" = {
      target_node = "pve-1"
      hastate     = "" # no HA
      hagroup     = ""
      id          = 9010
    },
    "2" = {
      target_node = "pve-1"
      hastate     = "" # no HA
      hagroup     = ""
      id          = 9011
    },
    "3" = {
      target_node = "pve-1"
      hastate     = ""
      hagroup     = ""
      id          = 9012
    }
  }
}

