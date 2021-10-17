# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the EC2 Instance IP

output "datagen_server_ip" {
  value       = aws_instance.datagen_server.private_ip
  description = "Datagen Server IP."
}
