#!/bin/bash

# Load .env data
export $(echo $(cat .env | sed 's/#.*//g' | sed 's/\r//g' | xargs) | envsubst)

echo  "Try to login to docker hub..."
docker login -u "$DOCKERHUB_USERNAME" -p "$DOCKERHUB_PASSWORD" &> /dev/null || (echo "Login failed!" && exit 1)

read -p "Please enter the tag name of the new release: " tag

echo "Building image with tag \"$tag\"..."
docker build -t "$DOCKERHUB_REPOSITORY":"$tag" . &> /dev/null || (echo "Build failed"! && exit 1)

echo "Pushing image to hub..."
docker push "$DOCKERHUB_REPOSITORY":"$tag" &> /dev/null || (echo "Push failed!" && exit 1)

echo "Tag \"$tag\" has been released successfully. Finally logging out..."
docker logout &> /dev/null || (echo "Logout failed!" && exit 1)