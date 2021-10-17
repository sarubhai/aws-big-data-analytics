# Name: security_groups.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Security Group for EMR Cluster

resource "aws_security_group" "emr_master_sg" {
  name        = "${var.prefix}_emr_master_sg"
  description = "Security Group for EMR Master"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.internet_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr_block]
  }

  tags = {
    Name  = "${var.prefix}-emr-master-sg"
    Owner = var.owner
  }
}

resource "aws_security_group" "emr_slave_sg" {
  name        = "${var.prefix}_emr_slave_sg"
  description = "Security Group for EMR Slave"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.internet_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr_block]
  }

  tags = {
    Name  = "${var.prefix}-emr-slave-sg"
    Owner = var.owner
  }
}

resource "aws_security_group" "emr_service_access_sg" {
  name        = "${var.prefix}_emr_service_access_sg"
  description = "Security Group for EMR Service Access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.internet_cidr_block]
  }

  ingress {
    from_port       = 9443
    to_port         = 9443
    protocol        = "tcp"
    security_groups = [aws_security_group.emr_master_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr_block]
  }

  tags = {
    Name  = "${var.prefix}-emr-service-access-sg"
    Owner = var.owner
  }
}

