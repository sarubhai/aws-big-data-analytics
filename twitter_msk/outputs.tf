# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the EC2 Instance IP

output "twitter_kafka_server_ip" {
  value       = aws_instance.twitter_kafka_server.private_ip
  description = "Twitter Kafka Server IP."
}
