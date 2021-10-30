import json
import os
import tweepy
from kafka import KafkaProducer

consumer_key = os.environ['CONSUMER_KEY']
consumer_secret = os.environ['CONSUMER_SECRET']
access_token = os.environ['ACCESS_TOKEN']
access_token_secret = os.environ['ACCESS_TOKEN_SECRET']
twitter_filter_tag = os.environ['TWITTER_FILTER_TAG']

bootstrap_servers = os.environ['BOOTSTRAP_SERVERS']
kafka_topic_name = os.environ['KAFKA_TOPIC_NAME']


class StreamingTweets(tweepy.Stream):
    def on_status(self, status):
        data = {
            'tweet_text': status.text,
            'created_at': str(status.created_at),
            'user_id': status.user.id,
            'user_name': status.user.name,
            'user_screen_name': status.user.screen_name,
            'user_description': status.user.description,
            'user_location': status.user.location,
            'user_followers_count': status.user.followers_count,
            'tweet_body': json.dumps(status._json)
        }

        response = producer.send(
            kafka_topic_name, json.dumps(data).encode('utf-8'))

        print((response))

    def on_error(self, status):
        print(status)


producer = KafkaProducer(bootstrap_servers=bootstrap_servers)

stream = StreamingTweets(
    consumer_key, consumer_secret,
    access_token, access_token_secret
)

stream.filter(track=[twitter_filter_tag])
