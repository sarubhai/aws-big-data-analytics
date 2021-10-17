# main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the S3 Buckets

resource "random_integer" "rid" {
  min = 100
  max = 900
}

locals {
  suffix                = random_integer.rid.result
  datagen_bucket_name   = "aws-bigdata-demo-datagen-${local.suffix}"
  resultset_bucket_name = "aws-bigdata-demo-resultset-${local.suffix}"
  emr_log_bucket_name   = "aws-bigdata-demo-emr-log-${local.suffix}"
}

resource "aws_s3_bucket" "datagen_bucket" {
  bucket        = local.datagen_bucket_name
  acl           = "private"
  force_destroy = true

  tags = {
    Name    = local.datagen_bucket_name
    Owner   = var.owner
    Project = var.prefix
  }
}

resource "aws_s3_bucket" "resultset_bucket" {
  bucket        = local.resultset_bucket_name
  acl           = "private"
  force_destroy = true

  tags = {
    Name    = local.resultset_bucket_name
    Owner   = var.owner
    Project = var.prefix
  }
}

resource "aws_s3_bucket" "emr_log_bucket" {
  bucket        = local.emr_log_bucket_name
  acl           = "private"
  force_destroy = true

  tags = {
    Name    = local.emr_log_bucket_name
    Owner   = var.owner
    Project = var.prefix
  }
}

# Upload Sample Dataset Files
resource "aws_s3_bucket_object" "dataset_files" {
  for_each = fileset(path.module, "**/*.psv")

  bucket = aws_s3_bucket.datagen_bucket.id
  acl    = "private"
  key    = each.value
  source = "${path.module}/${each.value}"
  etag   = filemd5("${path.module}/${each.value}")
}

# Upload Hive Script Files
resource "aws_s3_bucket_object" "hive_script_files" {
  for_each = fileset(path.module, "scripts/*.hql")

  bucket = aws_s3_bucket.datagen_bucket.id
  acl    = "private"
  key    = each.value
  source = "${path.module}/${each.value}"
  etag   = filemd5("${path.module}/${each.value}")
}

# Upload Pig Script Files
resource "aws_s3_bucket_object" "pig_script_files" {
  for_each = fileset(path.module, "scripts/*.pig")

  bucket = aws_s3_bucket.datagen_bucket.id
  acl    = "private"
  key    = each.value
  source = "${path.module}/${each.value}"
  etag   = filemd5("${path.module}/${each.value}")
}

# Upload Python Spark Files
resource "aws_s3_bucket_object" "spark_script_files" {
  for_each = fileset(path.module, "scripts/*.py")

  bucket = aws_s3_bucket.datagen_bucket.id
  acl    = "private"
  key    = each.value
  source = "${path.module}/${each.value}"
  etag   = filemd5("${path.module}/${each.value}")
}
