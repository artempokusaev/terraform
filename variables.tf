variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  sensitive   = true
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  sensitive   = true
}

variable "zone" {
  description = "Default zone"
  type        = string
  default     = "ru-central1-a"
}

variable "image_id" {
  description = "Default image ID for VMs"
  type        = string
  default     = "fd8hjrk74m4jvmvl5gi6" # Ubuntu 22.04
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "servers_subnet" {
  description = "CIDR block for network Servers"
  type        = string
}

variable "home_subnet" {
  description = "CIDR block for home network"
  type        = string
}

variable "home_ext_ip" {
  description = "CIDR block for home real IP"
  type        = string
}

variable "dev_ip" {
  description = "CIDR block for dev real IP"
  type        = string
}
