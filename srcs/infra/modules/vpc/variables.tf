variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "subnet_cidr_block" {
  description = "The CIDR block of the Subnet"
  type        = string
}