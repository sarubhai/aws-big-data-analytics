# Name: kinesis.tf
# Owner: Saurav Mitra
# Description: This terraform config will create Kinesis resources

# Kinesis Data Stream
resource "aws_kinesis_stream" "twitter_kds" {
  name                      = "kds-twitter-sda"
  shard_count               = 1
  retention_period          = 24
  enforce_consumer_deletion = true
  encryption_type           = "NONE"

  tags = {
    Name  = "kds-twitter-sda"
    Owner = var.owner
  }
}

# Kinesis Data Firehose
resource "aws_kinesis_firehose_delivery_stream" "twitter_kdf_kds" {
  name        = "kdf-twitter-sda-kds-s3"
  destination = "s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.twitter_kds.arn
    role_arn           = var.kinesis_firehose_role_arn
  }

  s3_configuration {
    role_arn   = var.kinesis_firehose_role_arn
    bucket_arn = var.s3_resultset_bucket_arn
    prefix     = "kinesis/raw_staging/"
  }

  tags = {
    Name  = "kdf-twitter-sda-kds-s3"
    Owner = var.owner
  }
}

# Kinesis Data Firehose
resource "aws_kinesis_firehose_delivery_stream" "twitter_kdf_kda" {
  name        = "kdf-twitter-sda-kda-s3"
  destination = "s3"

  s3_configuration {
    role_arn   = var.kinesis_firehose_role_arn
    bucket_arn = var.s3_resultset_bucket_arn
    prefix     = "kinesis/analysis/"
  }

  tags = {
    Name  = "kdf-twitter-sda-kda-s3"
    Owner = var.owner
  }
}

# Kinesis Data Analytics
resource "aws_kinesis_analytics_application" "twitter_kda" {
  name        = "kda-twitter-sda"
  description = "Twitter Streaming Data Analytics"
  code        = <<EOT
  
  CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (
    tweet_text VARCHAR(5000),
    created_at TIMESTAMP,
    user_id BIGINT,
    user_name VARCHAR(256),
    user_screen_name VARCHAR(256),
    user_description VARCHAR(500),
    user_location VARCHAR(256),
    user_followers_count INTEGER
  );

  CREATE OR REPLACE PUMP "STREAM_PUMP" AS INSERT INTO "DESTINATION_SQL_STREAM"
  SELECT "tweet_text", "created_at", "user_id", "user_name", "user_screen_name", "user_description", "user_location", "user_followers_count"
  FROM "SOURCE_SQL_STREAM_001"
  WHERE "user_followers_count" > 5000;
  EOT

  inputs {
    name_prefix = "SOURCE_SQL_STREAM"

    kinesis_stream {
      resource_arn = aws_kinesis_stream.twitter_kds.arn
      role_arn     = var.kinesis_analytics_role_arn
    }

    parallelism {
      count = 1
    }

    schema {
      record_columns {
        name     = "tweet_text"
        sql_type = "VARCHAR(5000)"
        mapping  = "$.tweet_text"
      }

      record_columns {
        name     = "created_at"
        sql_type = "TIMESTAMP"
        mapping  = "$.created_at"
      }

      record_columns {
        name     = "user_id"
        sql_type = "BIGINT"
        mapping  = "$.user_id"
      }

      record_columns {
        name     = "user_name"
        sql_type = "VARCHAR(256)"
        mapping  = "$.user_name"
      }

      record_columns {
        name     = "user_screen_name"
        sql_type = "VARCHAR(256)"
        mapping  = "$.user_screen_name"
      }

      record_columns {
        name     = "user_followers_count"
        sql_type = "INTEGER"
        mapping  = "$.user_followers_count"
      }

      record_columns {
        name     = "tweet_body"
        sql_type = "VARCHAR(40000)"
        mapping  = "$.tweet_body"
      }

      record_columns {
        name     = "user_description"
        sql_type = "VARCHAR(256)"
        mapping  = "$.user_description"
      }

      record_columns {
        name     = "user_location"
        sql_type = "VARCHAR(256)"
        mapping  = "$.user_location"
      }

      record_encoding = "UTF-8"

      record_format {
        mapping_parameters {
          json {
            record_row_path = "$"
          }
        }
      }
    }

    starting_position_configuration {
      starting_position = "NOW"
    }
  }

  outputs {
    name = "DESTINATION_SQL_STREAM"

    schema {
      record_format_type = "CSV"
    }

    kinesis_firehose {
      resource_arn = aws_kinesis_firehose_delivery_stream.twitter_kdf_kda.arn
      role_arn     = var.kinesis_analytics_role_arn
    }
  }

  start_application = true

  tags = {
    Name  = "kda-twitter-sda"
    Owner = var.owner
  }
}
