locals {
  instance_type = "t2.micro"
}

resource "aws_security_group" "allow_access" {
  vpc_id      = var.vpc_id
  name        = "allow-connection"
  description = "Allow public traffic to access the instance"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

data "aws_ami" "image" {
  most_recent = true

  # Ubuntu
  owners = ["099720109477"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "app" {
  name          = "${var.project_name}-template"
  image_id      = data.aws_ami.image.id
  instance_type = local.instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups             = [aws_security_group.allow_access.id]
    subnet_id                   = var.subnet_id
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      UsedForAnsible = "1"
    }
  }
}

resource "aws_instance" "app" {
  launch_template {
    id = aws_launch_template.app.id
  }

  tags = {
    Name           = "${var.project_name}-instance"
    UsedForAnsible = "1"
  }
}