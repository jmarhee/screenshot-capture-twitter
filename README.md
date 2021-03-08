# Capture and Tweet Periodic Screenshots

This repo creates two containerized processes:

1. Captures screenshots from a source directory of videos from a random location.
2. Tweets that Screenshot (i.e. @WalkerScreens or @ScreenshotsVice on Twitter)
3. Does this every 30 minutes.

## Requirements

For the screencapture process, your system must have [`ffmpeg`](https://ffmpeg.org/download.html) installed.

Optionally, to run these tasks in containers, you must have `docker` installed. 

For the sample `CronJob`, a Kubernetes cluster must be available-- you can run this using `hostPath` volumes on tools like `minikube` using the `minikube mount` option for local use. 

To post any of these captures to twitter using `post.py`, you must have a [Twitter Developer Account](https://developer.twitter.com/en/docs/apps/overview) with an app configured. You will need the `consumer_token`, `consumer_secret`, `access_token`, and `access_token_secret` for your Twitter app. 

## Setup

To create the container for a `Job` to generate the screenshots:

```bash
docker build --file Dockerfiles/Dockerfile.capture-create -t capture-create .
```
and then run:

```bash
docker run -it \
-v /VideoSourceOnHost:/media \
-v /ScreenshotDestonHost:/captures \
-e LNVC_DATA_PATH=/media \
-e LNVC_PREV_PATH=/captures \
capture-create:latest
```

or follow the template in `examples/` for a sample `CronJob`.

To create a container for a job to randomly select a capture to tweet:

```bash
docker build --file Dockerfiles/Dockerfile.capture-post -t capture-post .
```

and then run:

```bash
docker run -it \
-v /ScreenshotDestonHost:/captures \
-e SCREEN_SOURCE=/captures \
-e twitter_consumer_key="" \
-e twitter_consumer_secret="" \
-e twitter_access_token="" \
-e twitter_access_token_secret="" \
capture-post:latest
```

This will require a [Twitter Developer API token](developer.twitter.com). 
