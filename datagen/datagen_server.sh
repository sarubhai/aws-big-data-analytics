#!/bin/bash
# Name: datagen_server.sh
# Owner: Saurav Mitra
# Description: Big Data Generator using TPCH

sudo yum -y update                                      >> /dev/null
sudo yum -y install git make gcc                        >> /dev/null

# Generate Big Dataset
mkdir /root/bigdata
export DSS_PATH=/root/bigdata
cd /root
git clone https://github.com/gregrahn/tpch-kit.git      >> /dev/null
cd /root/tpch-kit/dbgen
make OS=LINUX                                           >> /dev/null
./dbgen -q -s ${data_volume_gb}                         >> /dev/null


# Compress & Upload Files to S3
cd /root/bigdata
gzip -c /root/bigdata/region.tbl | aws s3 cp - s3://${s3_datagen_bucket_name}/bigdata/region/region.psv.gz
gzip -c /root/bigdata/nation.tbl | aws s3 cp - s3://${s3_datagen_bucket_name}/bigdata/nation/nation.psv.gz
gzip -c /root/bigdata/supplier.tbl | aws s3 cp - s3://${s3_datagen_bucket_name}/bigdata/supplier/supplier.psv.gz
gzip -c /root/bigdata/customer.tbl | aws s3 cp - s3://${s3_datagen_bucket_name}/bigdata/customer/customer.psv.gz
gzip -c /root/bigdata/part.tbl | aws s3 cp - s3://${s3_datagen_bucket_name}/bigdata/part/part.psv.gz
gzip -c /root/bigdata/partsupp.tbl | aws s3 cp - s3://${s3_datagen_bucket_name}/bigdata/partsupp/partsupp.psv.gz
gzip -c /root/bigdata/orders.tbl | aws s3 cp - s3://${s3_datagen_bucket_name}/bigdata/orders/orders.psv.gz
gzip -c /root/bigdata/lineitem.tbl | aws s3 cp - s3://${s3_datagen_bucket_name}/bigdata/lineitem/lineitem.psv.gz


# Self Terminate Instance
instanceId=$(curl http://169.254.169.254/latest/meta-data/instance-id/)
region=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk '{print $3}' | sed  's/"//g'|sed 's/,//g')
aws ec2 terminate-instances --instance-ids $instanceId --region $region
