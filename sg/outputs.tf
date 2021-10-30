# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the Securtiy Group IDs

output "datagen_sg_id" {
  value       = aws_security_group.datagen_sg.id
  description = "Security Group for Datagen Server."
}

output "redshift_sg_id" {
  value       = aws_security_group.redshift_sg.id
  description = "Security Group for Redshift Cluster."
}

output "emr_master_sg_id" {
  value       = aws_security_group.emr_master_sg.id
  description = "Security Group for EMR Master."
}

output "emr_slave_sg_id" {
  value       = aws_security_group.emr_slave_sg.id
  description = "Security Group for EMR Slave."
}

output "emr_service_access_sg_id" {
  value       = aws_security_group.emr_service_access_sg.id
  description = "Security Group for EMR Service Access."
}

output "metabase_sg_id" {
  value       = aws_security_group.metabase_sg.id
  description = "Security Group for Metabase Server."
}

output "twitter_sg_id" {
  value       = aws_security_group.twitter_sg.id
  description = "Security Group for Twitter Server."
}

output "msk_sg_id" {
  value       = aws_security_group.msk_sg.id
  description = "Security Group for MSK Cluster."
}
