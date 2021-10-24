# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the EC2 Instance IP

output "twitter_server_ip" {
  value       = aws_instance.twitter_server.private_ip
  description = "Twitter Server IP."
}
