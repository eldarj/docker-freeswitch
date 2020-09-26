#!/bin/bash
#
# This is the init script for this repo, we'll build the image, run a container and hook into it
# PARAM -i image name
# PARAM -c container name
#
# Note: If you see error logs, this is due to trying to stop, rm and rmi container/image with same name
#

imageName=
containerName=

# Get passed params
while getopts ":i:c:" opt; do
    case $opt in
	i) imageName="$OPTARG" ;;
	c) containerName="$OPTARG" ;;
	\?) echo "Passed invalid param -$OPTARG" >&2 ;;
    esac
done

# Set default image and container name
if [ -z "$imageName" ]; then imageName='freeswitch:ping'; fi
if [ -z "$containerName" ]; then containerName='freeswitchping'; fi

echo "Removing existing container/images with same name..."
docker stop "$containerName"
docker rm "$containerName"
docker rmi "$imageName"

echo "Building and running $imageName & $containerName..."

docker build -t "$imageName" .

docker run -d --network host --name "$containerName" "$imageName"

docker exec -it "$containerName" bash
