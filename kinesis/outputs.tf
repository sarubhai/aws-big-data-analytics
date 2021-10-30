# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the Kinesis Stream Name

output "twitter_kinesis_stream_name" {
  value       = aws_kinesis_stream.twitter_kds.name
  description = "Kinesis Stream Name."
}
