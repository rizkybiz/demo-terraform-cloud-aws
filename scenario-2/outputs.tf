# Outputs file
output "catapp_url" {
  value = "http://${aws_eip.demo-eip.public_dns}"
}

output "catapp_ip" {
  value = "http://${aws_eip.demo-eip.public_ip}"
}