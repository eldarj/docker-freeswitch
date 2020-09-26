#!/bin/bash
#
# This is the init script for this repo, we'll build the image, run a container and hook into it
# PARAM -i image name
# PARAM -c container name
#

# Prepare image and container name
imageName=
containerName=

while getopts ":i:c:" opt; do
    case $opt in
	i) imageName="$OPTARG" ;;
	c) containerName="$OPTARG" ;;
	\?) echo "Passed invalid param -$OPTARG" >&2 ;;
    esac
done

if [ -z "$imageName" ]; then imageName='freeswitch:eja'; fi
if [ -z "$containerName" ]; then containerName='freeswitcheja'; fi

echo "Removing existing container/images with same name..."
docker stop "$containerName"
docker rm "$containerName"
docker rmi "$imageName"
docker volume rm etcfs
docker volume rm sharefs
sudo rm -rf mounts #TODO: avoid sudo

echo "Docker build $imageName..."
docker build -t "$imageName" .

echo "Docker run $containerName..."
# Mounts - on docker run, create certain mounts for easier development
mkdir -p "$(pwd)/mounts/etc/freeswitch"
mkdir -p "$(pwd)/mounts/usr/share/freeswitch"

sudo docker volume create etcfs

sudo docker volume create sharefs

sudo docker run -d \
  --network host \
  --name "$containerName" \
  --mount type=volume,dst=/etc/freeswitch,src=etcfs,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device="$(pwd)/mounts/etc/freeswitch" \
  --mount type=volume,dst=/usr/share/freeswitch,src=sharefs,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device="$(pwd)/mounts/usr/share/freeswitch" \
    "$imageName"

docker inspect "$containerName"

docker exec -it "$containerName" bash
