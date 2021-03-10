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

## Configuration

These jobs are largely controlled by environment variables. 

### Required Variables

`LNVC_DATA_PATH`: The path that will contain your video file(s); if run in a container, this should refer to the mounted path in the container, not on your host system.

`LNVC_PREV_PATH`: The path that the screenshots will be written to; if run in a container, this should refer to the mounted path in the container, not on your host system.

### Optional Variables

Keep in mind that to produce screenshots, you will need to set, either, `DUMP_RANDOM` to `1` or `DUMP_INTERVAL` to the number of seconds between screenshots from a given video (i.e. `30` for one every seconds 30s). 

`RANDOMIZE_NAMES` can be used with `DUMP_INTERVAL` to randomize the filenames (with the interval shots of the videos serialized by default-- i.e. `video1prefix-001`, `video2prefix-001`) if you want them shuffled in the directory rather than ordered.

`REFRESH_SCREENS`: When set to any value, it will purge `LNVC_PREV_PATH` of `.jpg` files; this is useful if `DUMP_RANDOM` is producing a lot of shots from one cluster of timecodes across files, or if you need to clean-up the volume. It can be run alone with `DUMP_RANDOM` or `DUMP_INTERVAL` left unset. If set along with either `DUMP_RANDOM` or `DUMP_INTERVAL`, it will simply clear the directory before creating new screenshots.

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
-e DUMP_RANDOM=1 \
-e REFRESH_SCREENS=1 \
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
