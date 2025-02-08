#!/bin/sh

# TODO: rename the image to match your Docker Hub username or the url of your private registry
docker build -t robrich/terraform-workshop-aws:latest .
# docker push robrich/terraform-workshop-aws:latest
# We've pushed to Docker Hub previously: https://hub.docker.com/r/robrich/terraform-workshop-aws
