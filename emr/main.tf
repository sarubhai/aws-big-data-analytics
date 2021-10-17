# main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the EMR cluster resources for AWS Big Data Analytics

resource "aws_emr_cluster" "bda_emr_cluster" {
  name                              = "emr-test-arn"
  release_label                     = var.emr_release_label
  applications                      = var.emr_applications
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true
  log_uri                           = "s3://${var.s3_emr_log_bucket_name}/logs/"
  service_role                      = var.emr_service_role_arn
  autoscaling_role                  = var.emr_auto_scaling_role_arn

  ec2_attributes {
    subnet_id                         = var.private_subnet_id.0
    emr_managed_master_security_group = var.emr_master_sg_id
    emr_managed_slave_security_group  = var.emr_slave_sg_id
    service_access_security_group     = var.emr_service_access_sg_id
    instance_profile                  = var.emr_ec2_instance_profile_arn
    key_name                          = var.keypair_name
  }

  master_instance_group {
    instance_type  = var.emr_master_instance_type
    instance_count = var.emr_master_number_of_nodes
  }

  core_instance_group {
    instance_type  = var.emr_core_instance_type
    instance_count = var.emr_core_number_of_nodes

    ebs_config {
      size                 = var.emr_core_ebs_volume_size
      type                 = "gp2"
      volumes_per_instance = 1
    }

    # bid_price = "0.30"
  }

  ebs_root_volume_size = var.emr_ebs_root_volume_size

  bootstrap_action {
    path = "s3://elasticmapreduce/bootstrap-actions/run-if"
    name = "runif"
    args = ["instance.isMaster=true", "echo running on master node"]
  }

  # configurations_json = <<EOF
  #   [
  #     {
  #       "Classification": "hive",
  #       "Configurations": [],
  #       "Properties": {
  #         "hive.llap.enabled": "true",
  #         "hive.merge.mapfiles": "true"
  #       }
  #     },
  #     {
  #       "Classification": "presto-connector-hive",
  #       "Configurations": [],
  #       "Properties": {
  #         "hive.s3select-pushdown.enabled": "true",
  #         "hive.s3select-pushdown.max-connections": "5"
  #       }
  #     }
  #   ]
  # EOF

  step = [
    {
      action_on_failure = "CONTINUE"
      name              = "Enable Hadoop Debugging"

      hadoop_jar_step = [
        {
          jar        = "command-runner.jar"
          args       = ["state-pusher-script"]
          main_class = ""
          properties = {}
        }
      ]
    },
    {
      action_on_failure = "CONTINUE"
      name              = "Copy Data from S3 to HDFS using S3DistCp"

      hadoop_jar_step = [
        {
          jar        = "command-runner.jar"
          args       = ["s3-dist-cp", "--s3Endpoint=s3.${var.region}.amazonaws.com", "--src=s3://${var.s3_datagen_bucket_name}/datasets/", "--dest=hdfs:///datasets"]
          main_class = ""
          properties = {}
        }
      ]
    },
    {
      action_on_failure = "CONTINUE"
      name              = "Create & Load Hive Dimension Tables; Create Hive Fact Tables"

      hadoop_jar_step = [
        {
          jar        = "command-runner.jar"
          args       = ["hive-script", "--run-hive-script", "--args", "-f", "s3://${var.s3_datagen_bucket_name}/scripts/tables.hql"]
          main_class = ""
          properties = {}
        }
      ]
    },
    {
      action_on_failure = "CONTINUE"
      name              = "Pig ETL Hive Fact Tables"

      hadoop_jar_step = [
        {
          jar        = "command-runner.jar"
          args       = ["pig-script", "--run-pig-script", "--args", "-useHCatalog", "-f", "s3://${var.s3_datagen_bucket_name}/scripts/etl.pig"]
          main_class = ""
          properties = {}
        }
      ]
    },
    {
      action_on_failure = "CONTINUE"
      name              = "PySpark Create Sales View"

      hadoop_jar_step = [
        {
          jar        = "command-runner.jar"
          args       = ["spark-submit", "s3://${var.s3_datagen_bucket_name}/scripts/etl.py"]
          main_class = ""
          properties = {}
        }
      ]
    }
  ]

  tags = {
    Name    = "bda-emr-cluster"
    Owner   = var.owner
    Project = var.prefix
  }

  lifecycle {
    # ignore_changes = [step]
  }
}

# Scaling Policy
resource "aws_emr_managed_scaling_policy" "bda_emr_scaling_policy" {
  cluster_id = aws_emr_cluster.bda_emr_cluster.id
  compute_limits {
    unit_type                       = "Instances"
    minimum_capacity_units          = var.emr_core_number_of_nodes
    maximum_capacity_units          = var.emr_core_number_of_nodes + 1
    maximum_ondemand_capacity_units = var.emr_core_number_of_nodes + 1
    maximum_core_capacity_units     = var.emr_core_number_of_nodes + 1
  }
}
