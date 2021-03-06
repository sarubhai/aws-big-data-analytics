# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the EC2 Instance IP

output "twitter_kinesis_server_ip" {
  value       = aws_instance.twitter_kinesis_server.private_ip
  description = "Twitter Kinesis Server IP."
}
