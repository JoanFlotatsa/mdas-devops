#!/bin/bash
set -e

docker network create votingapp || true

#Cleanup
docker rm -f myvotingapp || true

docker build -t joanflotatsa/votingapp ./src/votingapp
#-f src/votingapp/Dockerfile \
#Starts build on a specific dir

#--name Name of instance to kill it (Avoid pkill)
docker run --network votingapp --name myvotingapp -p 8080:80 -d joanflotatsa/votingapp

docker build -t joanflotatsa/votingapp-test ./test

#detach -d para servidores
docker run --network votingapp --rm -e VOTINGAPP_HOST="myvotingapp" joanflotatsa/votingapp-test 

#Delivery
docker push joanflotatsa/votingapp