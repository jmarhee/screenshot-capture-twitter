import tweepy
import os, random

if os.environ.get("SCREEN_SOURCE") is not None:
    SCREEN_SOURCE = os.environ['SCREEN_SOURCE']
else:
    exit(1)

def main():

    twitter_auth_keys = { 

        "consumer_key"        : os.environ['twitter_consumer_key'],

        "consumer_secret"     : os.environ['twitter_consumer_secret'],

        "access_token"        : os.environ['twitter_access_token'],

        "access_token_secret" : os.environ['twitter_access_token_secret'] 

    }

 

    auth = tweepy.OAuthHandler(

            twitter_auth_keys['consumer_key'],

            twitter_auth_keys['consumer_secret']

            )

    auth.set_access_token(

            twitter_auth_keys['access_token'],

            twitter_auth_keys['access_token_secret']

            )

    api = tweepy.API(auth)

   

    # Upload image
    path = SCREEN_SOURCE + random.choice(os.listdir(SCREEN_SOURCE))
    media = api.media_upload(path)

 

    # Post tweet with image

    tweet = ""

    post_result = api.update_status(status=tweet, media_ids=[media.media_id])

 

if __name__ == "__main__":

    main()