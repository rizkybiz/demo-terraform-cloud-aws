terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.61.0"
    }
  }

  # This block within terraform configures
  # the "remote" backend; which is pushing
  # state to Terraform Cloud
  backend "remote" {
    organization = "jdefrank-org"
    workspaces {
      name = "terraform-cloud-demo-aws-1"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_eip" "demo-eip" {
  instance = aws_instance.demo-instance.id
  vpc      = true
}

resource "aws_eip_association" "demo-eip-assoc" {
  instance_id   = aws_instance.demo-instance.id
  allocation_id = aws_eip.demo-eip.id
}

resource "aws_instance" "demo-instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.demo-key-pair.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.demo-subnet.id
  vpc_security_group_ids      = [aws_security_group.demo-security-group.id]

  tags = {
    Name        = "${var.prefix}-hashicat-instance"
    environment = var.environment
  }
}