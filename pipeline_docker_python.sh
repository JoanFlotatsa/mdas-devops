#!/bin/bash
set -e

docker network create python_network || true

#Cleanup
docker rm -f myvotingapp || true

docker build -t joanflotatsa/votingapp ./python_test

docker run --network python_network --name myvotingapp -p 8080:80 -d joanflotatsa/votingapp

docker build -t joanflotatsa/python_test ./python_test/test

docker run --network python_network --rm -e VOTINGAPP_HOST="myvotingapp"  joanflotatsa/python_test python -m pytest test_pipeline.py

#Delivery
docker push joanflotatsa/votingapp