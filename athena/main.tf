# main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Athena resources for AWS Big Data Analytics

# Workgroup
resource "aws_athena_workgroup" "bigdata_wg" {
  name          = "bigdata-wg"
  description   = "bigdata-wg"
  force_destroy = true

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${var.s3_resultset_bucket_name}/athena/"
    }
  }

  tags = {
    Name    = "bigdata-wg"
    Owner   = var.owner
    Project = var.prefix
  }
}

# Database
resource "aws_athena_database" "bigdata_db" {
  name          = "bigdatagen"
  bucket        = var.s3_resultset_bucket_name
  force_destroy = true
}

# Named Query
resource "aws_athena_named_query" "query1" {
  name      = "tpch-query1"
  workgroup = aws_athena_workgroup.bigdata_wg.id
  database  = aws_athena_database.bigdata_db.name
  query     = <<EOF
SELECT
  l_returnflag,
  l_linestatus,
  sum(l_quantity) as sum_qty,
  sum(l_extendedprice) as sum_base_price,
  sum(l_extendedprice * (1 - l_discount)) as sum_disc_price,
  sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,
  avg(l_quantity) as avg_qty,
  avg(l_extendedprice) as avg_price,
  avg(l_discount) as avg_disc,
  count(*) as count_order
FROM
  ${aws_athena_database.bigdata_db.name}.lineitem
WHERE
  l_shipdate <= date '1998-12-01' - interval '90' day
GROUP BY
  l_returnflag,
  l_linestatus
ORDER BY
  l_returnflag,
  l_linestatus;
  EOF
}
