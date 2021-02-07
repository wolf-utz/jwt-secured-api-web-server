#!/bin/bash

read -p "Please enter docker hub username: " username
read -s -p "Please enter docker hub password: " password

echo ""
echo  "Try to login to docker hub..."
docker login -u "$username" -p "$password" &> /dev/null || (echo "Login failed!" && exit 1)

read -p "Please enter the tag name of the new release: " tag

echo "Building image with tag \"$tag\"..."
docker build -t omegacode/jwt-secured-api-web-server:"$tag" . &> /dev/null || (echo "Build failed"! && exit 1)

echo "Pushing image to hub..."
docker push omegacode/jwt-secured-api-web-server:"$tag" &> /dev/null || (echo "Push failed!" && exit 1)

echo "Tag \"$tag\" has been released successfully. Finally logging out..."
docker logout &> /dev/null || (echo "Logout failed!" && exit 1)
