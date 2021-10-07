# Outputs file
output "catapp_url" {
  value = "http://${aws_eip.demo-eip.public_dns}"
}

output "catapp_ip" {
  value = "http://${aws_eip.demo-eip.public_ip}"
}

output "ssh_priv_key" {
  value     = tls_private_key.demo-tls-key.private_key_pem
  sensitive = true
}