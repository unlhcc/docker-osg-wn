#!/bin/sh
set -ex

BRANCH=$(git rev-parse --abbrev-ref HEAD)
REV=$(git rev-parse --short HEAD)
NOW=$(date +%Y%m%d%H%M%S)

TAG=$BRANCH-$NOW-git$REV

# Build docker image
docker build -t image:$TAG .

# Convert to apptainer SIF
apptainer build $TAG.sif docker-daemon://image:$TAG

# Remove image
docker rmi image:$TAG
