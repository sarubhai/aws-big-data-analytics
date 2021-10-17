# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the Redshift Cluster ARN, Endpoint

output "redshift_arn" {
  value       = aws_redshift_cluster.edw_cluster.arn
  description = "Redshift Cluster ARN."
}

output "redshift_id" {
  value       = aws_redshift_cluster.edw_cluster.id
  description = "Redshift Cluster ID."
}

output "redshift_endpoint" {
  value       = aws_redshift_cluster.edw_cluster.endpoint
  description = "Redshift Cluster Endpoint."
}
