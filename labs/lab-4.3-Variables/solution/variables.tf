variable "region" {
  type = string
}

variable "vm_keypair_name" {
  description = "Name of the key pair for access to EC2 VMs."
  type = string

  validation {
    condition = var.vm_keypair_name != null && length(var.vm_keypair_name) > 0
    error_message = "Key pair name cannot be null or empty string."
  }
}

variable "db_name" {
  description = "Name of database to be created."
  type = string
  default = "appdb"
}
