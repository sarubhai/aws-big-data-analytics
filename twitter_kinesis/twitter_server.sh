#!/bin/bash
# Name: twitter_server.sh
# Owner: Saurav Mitra
# Description: Twitter Server to push tweets to Kinesis Data Stream

sudo yum -y update                                      >> /dev/null

# Download tweets_kinesis.py
mkdir /root/twitter
sudo aws s3 cp s3://${s3_datagen_bucket_name}/twitter/tweets_kinesis.py /root/twitter
sudo aws s3 cp s3://${s3_datagen_bucket_name}/twitter/requirements_kinesis.txt /root/twitter/requirements.txt
sudo chmod +x /root/twitter/tweets_kinesis.py
cd /root/twitter

# Twitter
export CONSUMER_KEY='${consumer_key}'
export CONSUMER_SECRET='${consumer_secret}'
export ACCESS_TOKEN='${access_token}'
export ACCESS_TOKEN_SECRET='${access_token_secret}'
export TWITTER_FILTER_TAG='${twitter_filter_tag}'
export KINESIS_REGION='${kinesis_region}'
export KINESIS_STREAM_NAME='${kinesis_stream_name}'

pip3 install -r requirements.txt -t ./

nohup python3 tweets_kinesis.py & > tweets_kinesis.out
