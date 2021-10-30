# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the MSK ARN, Connection Strings

output "kafka_arn" {
  value       = aws_msk_cluster.msk_bda_cluster.arn
  description = "MSK cluster ARN."
}

output "zookeeper_connect_string" {
  value       = aws_msk_cluster.msk_bda_cluster.zookeeper_connect_string
  description = "Zookeeper connection string."
}

output "kafka_bootstrap_servers" {
  value       = aws_msk_cluster.msk_bda_cluster.bootstrap_brokers
  description = "Bootstrap server Plaintext connection string."
}
