#!/bin/bash

BUILDFLAGS="$@"

echo "Building rails image"
# IMAGE="inquicker/rails-dev:latest"
IMAGE="mrinterweb/iq-rails:latest"

docker build $BUILDFLAGS -t $IMAGE .
docker push $IMAGE

