# Name: main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create MSK resources

# MSK Configuration

resource "aws_msk_configuration" "msk_bda_cluster_config" {
  kafka_versions = ["2.6.2"]
  name           = "msk-bda-cluster-config"

  server_properties = <<PROPERTIES
auto.create.topics.enable=true
default.replication.factor=3
min.insync.replicas=2
num.io.threads=8
num.network.threads=5
num.partitions=1
num.replica.fetchers=2
replica.lag.time.max.ms=30000
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
socket.send.buffer.bytes=102400
unclean.leader.election.enable=true
zookeeper.session.timeout.ms=18000
PROPERTIES
}


# MSK Cluster
resource "aws_msk_cluster" "msk_bda_cluster" {
  cluster_name           = "msk-bda-cluster"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.kafka_number_of_nodes

  configuration_info {
    arn      = aws_msk_configuration.msk_bda_cluster_config.arn
    revision = 1
  }

  broker_node_group_info {
    instance_type   = var.kafka_instance_type
    ebs_volume_size = var.kafka_ebs_volume_size
    client_subnets  = var.private_subnet_id
    security_groups = [var.kafka_sg_id]
  }

  # Unauthenticated access
  client_authentication {
    sasl {
      iam   = false
      scram = false
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
      in_cluster    = true
    }
    # encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
  }

  # open_monitoring {
  #   prometheus {
  #     jmx_exporter {
  #       enabled_in_broker = true
  #     }
  #     node_exporter {
  #       enabled_in_broker = true
  #     }
  #   }
  # }

  # logging_info {
  #   broker_logs {
  #     cloudwatch_logs {
  #       enabled   = true
  #       log_group = aws_cloudwatch_log_group.test.name
  #     }
  #     firehose {
  #       enabled         = true
  #       delivery_stream = aws_kinesis_firehose_delivery_stream.test_stream.name
  #     }
  #     s3 {
  #       enabled = true
  #       bucket  = aws_s3_bucket.bucket.id
  #       prefix  = "logs/msk-"
  #     }
  #   }
  # }

  tags = {
    Name    = "msk-bda-cluster"
    Owner   = var.owner
    Project = var.prefix
  }
}
