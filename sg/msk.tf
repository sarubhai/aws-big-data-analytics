# Name: msk.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Security Group for Kafka MSK Cluster

resource "aws_security_group" "msk_sg" {
  name        = "${var.prefix}_msk_sg"
  description = "Security Group for Kafka"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr_block]
  }

  tags = {
    Name  = "${var.prefix}-msk-sg"
    Owner = var.owner
  }
}
