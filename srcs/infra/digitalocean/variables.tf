variable "ssh_key_name" {
  description = "Name of the SSH key"
  type        = string
  default     = "default"
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "droplet_name" {
  description = "Name of the Droplet"
  type        = string
  default     = "terraform-droplet"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "fra1"
}

variable "size" {
  description = "Droplet size slug"
  type        = string
  default     = "s-1vcpu-512mb-1gb"
}

variable "image" {
  description = "Droplet image slug"
  type        = string
  default     = "ubuntu-22-04-x64"
}