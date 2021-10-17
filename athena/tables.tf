# main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Athena resources for AWS Big Data Analytics

# Region Table
resource "aws_glue_catalog_table" "tbl_region" {
  name          = "region"
  database_name = aws_athena_database.bigdata_db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.s3_datagen_bucket_name}/bigdata/region/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = "|"
      }
    }

    columns {
      name = "r_regionkey"
      type = "int"
    }

    columns {
      name = "r_name"
      type = "char(25)"
    }

    columns {
      name = "r_comment"
      type = "varchar(152)"
    }
  }
}

# Nation Table
resource "aws_glue_catalog_table" "tbl_nation" {
  name          = "nation"
  database_name = aws_athena_database.bigdata_db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.s3_datagen_bucket_name}/bigdata/nation/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = "|"
      }
    }

    columns {
      name = "n_nationkey"
      type = "int"
    }

    columns {
      name = "n_name"
      type = "char(25)"
    }

    columns {
      name = "n_regionkey"
      type = "int"
    }

    columns {
      name = "n_comment"
      type = "varchar(152)"
    }
  }
}

# Customer Table
resource "aws_glue_catalog_table" "tbl_customer" {
  name          = "customer"
  database_name = aws_athena_database.bigdata_db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.s3_datagen_bucket_name}/bigdata/customer/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = "|"
      }
    }

    columns {
      name = "c_customerkey"
      type = "int"
    }

    columns {
      name = "c_name"
      type = "char(25)"
    }

    columns {
      name = "c_address"
      type = "varchar(40)"
    }

    columns {
      name = "c_nationkey"
      type = "int"
    }

    columns {
      name = "c_phone"
      type = "char(15)"
    }

    columns {
      name = "c_acctbal"
      type = "decimal(12,2)"
    }

    columns {
      name = "c_mktsegment"
      type = "char(10)"
    }

    columns {
      name = "n_comment"
      type = "varchar(117)"
    }
  }
}

# Supplier Table
resource "aws_glue_catalog_table" "tbl_supplier" {
  name          = "supplier"
  database_name = aws_athena_database.bigdata_db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.s3_datagen_bucket_name}/bigdata/supplier/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = "|"
      }
    }

    columns {
      name = "s_suppkey"
      type = "int"
    }

    columns {
      name = "s_name"
      type = "char(25)"
    }

    columns {
      name = "s_address"
      type = "varchar(40)"
    }

    columns {
      name = "s_nationkey"
      type = "int"
    }

    columns {
      name = "s_phone"
      type = "char(15)"
    }

    columns {
      name = "s_acctbal"
      type = "decimal(12,2)"
    }

    columns {
      name = "s_comment"
      type = "varchar(101)"
    }
  }
}

# Part Table
resource "aws_glue_catalog_table" "tbl_part" {
  name          = "part"
  database_name = aws_athena_database.bigdata_db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.s3_datagen_bucket_name}/bigdata/part/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = "|"
      }
    }

    columns {
      name = "p_partkey"
      type = "int"
    }

    columns {
      name = "p_name"
      type = "char(55)"
    }

    columns {
      name = "p_mfgr"
      type = "char(25)"
    }

    columns {
      name = "p_brand"
      type = "char(10)"
    }

    columns {
      name = "p_type"
      type = "varchar(25)"
    }

    columns {
      name = "p_size"
      type = "int"
    }

    columns {
      name = "p_container"
      type = "char(10)"
    }

    columns {
      name = "p_retailprice"
      type = "decimal(12,2)"
    }

    columns {
      name = "p_comment"
      type = "varchar(23)"
    }
  }
}

# PartSupplier Table
resource "aws_glue_catalog_table" "tbl_partsupp" {
  name          = "partsupp"
  database_name = aws_athena_database.bigdata_db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.s3_datagen_bucket_name}/bigdata/partsupp/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = "|"
      }
    }

    columns {
      name = "ps_partkey"
      type = "int"
    }

    columns {
      name = "ps_suppkey"
      type = "int"
    }

    columns {
      name = "ps_availqty"
      type = "int"
    }

    columns {
      name = "ps_supplycost"
      type = "decimal(12,2)"
    }

    columns {
      name = "ps_comment"
      type = "varchar(199)"
    }
  }
}

# Orders Table
resource "aws_glue_catalog_table" "tbl_orders" {
  name          = "orders"
  database_name = aws_athena_database.bigdata_db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.s3_datagen_bucket_name}/bigdata/orders/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = "|"
      }
    }

    columns {
      name = "o_orderkey"
      type = "int"
    }

    columns {
      name = "o_custkey"
      type = "int"
    }

    columns {
      name = "o_orderstatus"
      type = "char(1)"
    }

    columns {
      name = "o_totalprice"
      type = "decimal(12,2)"
    }

    columns {
      name = "o_orderdate"
      type = "date"
    }

    columns {
      name = "o_orderpriority"
      type = "char(15)"
    }

    columns {
      name = "o_clerk"
      type = "char(15)"
    }

    columns {
      name = "o_shippriority"
      type = "int"
    }

    columns {
      name = "o_comment"
      type = "varchar(79)"
    }
  }
}

# LineItem table
resource "aws_glue_catalog_table" "tbl_lineitem" {
  name          = "lineitem"
  database_name = aws_athena_database.bigdata_db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${var.s3_datagen_bucket_name}/bigdata/lineitem/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = "|"
      }
    }

    columns {
      name = "l_orderkey"
      type = "int"
    }

    columns {
      name = "l_partkey"
      type = "int"
    }

    columns {
      name = "l_suppkey"
      type = "int"
    }

    columns {
      name = "l_linenumber"
      type = "int"
    }

    columns {
      name = "l_quantity"
      type = "decimal(12,2)"
    }

    columns {
      name = "l_extendedprice"
      type = "decimal(12,2)"
    }

    columns {
      name = "l_discount"
      type = "decimal(12,2)"
    }

    columns {
      name = "l_tax"
      type = "decimal(12,2)"
    }

    columns {
      name = "l_returnflag"
      type = "char(1)"
    }

    columns {
      name = "l_linestatus"
      type = "char(1)"
    }

    columns {
      name = "l_shipdate"
      type = "date"
    }

    columns {
      name = "l_commitdate"
      type = "date"
    }

    columns {
      name = "l_receiptdate"
      type = "date"
    }

    columns {
      name = "l_shipinstruct"
      type = "char(25)"
    }

    columns {
      name = "l_shipmode"
      type = "char(10)"
    }

    columns {
      name = "l_comment"
      type = "varchar(44)"
    }
  }
}
