resource "tls_private_key" "demo-tls-key" {
  algorithm = "RSA"
}

locals {
  private_key_filename = "${var.prefix}-ssh-key.pem"
}

resource "aws_key_pair" "demo-key-pair" {
  key_name   = local.private_key_filename
  public_key = tls_private_key.demo-tls-key.public_key_openssh
}