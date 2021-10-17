# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the S3 Bucket ID, Name & ARN

output "s3_datagen_bucket_id" {
  value       = aws_s3_bucket.datagen_bucket.id
  description = "The S3 Bucket ID for Generated Datasets."
}

output "s3_datagen_bucket_name" {
  value       = local.datagen_bucket_name
  description = "The S3 Bucket Name for Generated Datasets."
}

output "s3_datagen_bucket_arn" {
  value       = aws_s3_bucket.datagen_bucket.arn
  description = "The S3 Bucket ARN for Generated Datasets."
}

output "s3_resultset_bucket_id" {
  value       = aws_s3_bucket.resultset_bucket.id
  description = "The S3 Bucket ID for Resultset Datasets."
}

output "s3_resultset_bucket_name" {
  value       = local.resultset_bucket_name
  description = "The S3 Bucket Name for Resultset Datasets."
}

output "s3_resultset_bucket_arn" {
  value       = aws_s3_bucket.resultset_bucket.arn
  description = "The S3 Bucket ARN for Resultset Datasets."
}

output "s3_emr_log_bucket_id" {
  value       = aws_s3_bucket.emr_log_bucket.id
  description = "The S3 Bucket ID for EMR Logs."
}

output "s3_emr_log_bucket_name" {
  value       = local.emr_log_bucket_name
  description = "The S3 Bucket Name for EMR Logs."
}

output "s3_emr_log_bucket_arn" {
  value       = aws_s3_bucket.emr_log_bucket.arn
  description = "The S3 Bucket ARN for EMR Logs."
}
