# main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Redshift cluster resources for AWS Big Data Analytics

# Subnet Group
resource "aws_redshift_subnet_group" "edw_subnet_group" {
  name        = "edw-subnet-group"
  description = "edw subnet group for redshift"
  subnet_ids  = var.private_subnet_id

  tags = {
    Name  = "${var.prefix}-redshift-subnet-group"
    Owner = var.owner
  }
}

# Parameter Group
resource "aws_redshift_parameter_group" "edw_parameter_group" {
  name        = "edw-parameter-group"
  description = "edw parameter group for redshift"
  family      = "redshift-1.0"

  parameter {
    name  = "query_group"
    value = "edw-qg"
  }

  parameter {
    name  = "require_ssl"
    value = "false"
  }

  parameter {
    name  = "enable_user_activity_logging"
    value = "false"
  }
}

# Redshift Cluster
resource "aws_redshift_cluster" "edw_cluster" {
  cluster_identifier                  = "edw-cluster"
  cluster_type                        = var.redshift_cluster_type
  node_type                           = var.redshift_node_type
  number_of_nodes                     = var.redshift_number_of_nodes
  master_username                     = var.redshift_master_username
  master_password                     = var.redshift_master_password
  iam_roles                           = [var.redshift_cluster_role_arn]
  vpc_security_group_ids              = [var.redshift_sg_id]
  cluster_subnet_group_name           = aws_redshift_subnet_group.edw_subnet_group.name
  availability_zone                   = "ap-southeast-1a"
  enhanced_vpc_routing                = false
  publicly_accessible                 = false
  database_name                       = "dev"
  port                                = 5439
  cluster_parameter_group_name        = aws_redshift_parameter_group.edw_parameter_group.name
  encrypted                           = false
  preferred_maintenance_window        = "sun:01:30-sun:02:30"
  automated_snapshot_retention_period = 0
  skip_final_snapshot                 = true

  tags = {
    Name    = "edw-cluster"
    Owner   = var.owner
    Project = var.prefix
  }
}
