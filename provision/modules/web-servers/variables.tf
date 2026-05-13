variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "subnet_id" {
  description = "The Subnet ID to launch the instance in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "key_name" {
  description = "The key name used for connecting to the instance"
  type        = string
}