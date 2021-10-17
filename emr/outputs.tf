# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the EMR Cluster ARN, Endpoint

output "emr_name" {
  value       = aws_emr_cluster.bda_emr_cluster.name
  description = "EMR Cluster Name."
}

output "emr_arn" {
  value       = aws_emr_cluster.bda_emr_cluster.arn
  description = "EMR Cluster ARN."
}

output "emr_id" {
  value       = aws_emr_cluster.bda_emr_cluster.id
  description = "EMR Cluster ID."
}

output "emr_master_public_dns" {
  value       = aws_emr_cluster.bda_emr_cluster.master_public_dns
  description = "EMR Cluster Master Node DNS."
}
