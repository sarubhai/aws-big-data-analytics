# Name: security_groups.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Security Group for Redshift Cluster

resource "aws_security_group" "redshift_sg" {
  name        = "${var.prefix}_redshift_sg"
  description = "Security Group for Redshift"
  vpc_id      = var.vpc_id

  ingress {
    description = "Redshift"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = {
    Name  = "${var.prefix}-redshift-sg"
    Owner = var.owner
  }
}
