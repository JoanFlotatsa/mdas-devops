#!/bin/bash
set -e

docker-compose rm -f && docker-compose up --build -d && docker-compose run --rm mytest && docker-compose push

#deploy
kubectl apply -f votingapp.yaml

#test
kubectl run mytests \
--generator=run-pod/v1 \
--image=joanflotatsa/myvotingapp-test \
--env VOTINGAPP_HOST=myvotingapp.votingapp \
--rm --attach --restart=Never


echo "GREEN" || echo "RED"
