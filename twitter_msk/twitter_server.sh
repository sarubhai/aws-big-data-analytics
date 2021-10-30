#!/bin/bash
# Name: twitter_server.sh
# Owner: Saurav Mitra
# Description: Twitter Server to push tweets to Kinesis Data Stream

sudo yum -y update                                      >> /dev/null

# Download tweets_kafka.py
mkdir /root/twitter
sudo aws s3 cp s3://${s3_datagen_bucket_name}/twitter/tweets_kafka.py /root/twitter
sudo aws s3 cp s3://${s3_datagen_bucket_name}/twitter/requirements_kafka.txt /root/twitter/requirements.txt
sudo chmod +x /root/twitter/tweets_kafka.py
cd /root/twitter

# Twitter
export CONSUMER_KEY='${consumer_key}'
export CONSUMER_SECRET='${consumer_secret}'
export ACCESS_TOKEN='${access_token}'
export ACCESS_TOKEN_SECRET='${access_token_secret}'
export TWITTER_FILTER_TAG='${twitter_filter_tag}'
export BOOTSTRAP_SERVERS='${bootstrap_servers}'
export KAFKA_TOPIC_NAME='${kafka_topic_name}'

pip3 install -r requirements.txt -t ./

nohup python3 tweets_kafka.py & > tweets_kafka.out

# KAFKA
cd /root/
sudo yum -y install java >> /dev/null
sudo wget https://archive.apache.org/dist/kafka/2.6.0/kafka_2.12-2.6.0.tgz
sudo tar -xzf kafka_2.12-2.6.0.tgz
export kafka='${bootstrap_servers}'
echo "${bootstrap_servers}" > bootstrap_servers.txt
# /root/kafka_2.12-2.6.0/bin/kafka-topics.sh --bootstrap-server $kafka --list
# /root/kafka_2.12-2.6.0/bin/kafka-console-consumer.sh --bootstrap-server $kafka --topic tweets --from-beginning
