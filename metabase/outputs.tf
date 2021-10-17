# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the EC2 Instance IP

output "metabase_server_ip" {
  value       = aws_instance.metabase_server.private_ip
  description = "Metabase Server IP."
}
