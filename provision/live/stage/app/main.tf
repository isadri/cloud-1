provider "aws" {
  region = "us-east-2"
}

locals {
  vpc_cidr_block    = "192.168.56.0/24"
  subnet_cidr_block = "192.168.56.0/28"
}

module "vpc" {
  source = "../../../modules/vpc"

  project_name      = var.project_name
  vpc_cidr_block    = local.vpc_cidr_block
  subnet_cidr_block = local.subnet_cidr_block
}

module "web_server" {
  source = "../../../modules/web-servers"

  project_name = var.project_name
  subnet_id    = module.vpc.subnet_id
  vpc_id       = module.vpc.vpc_id
  key_name     = var.key_name
}
