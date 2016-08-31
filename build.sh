#!/bin/bash

BUILDFLAGS="$@"

echo "Building rails image"
docker build $BUILDFLAGS -t "inquicker/rails-dev:latest" .

# docker push inquicker/rails-dev:latest
