#!/bin/bash

#Install Deps
go get github.com/labstack/echo
go get github.com/gorilla/websocket

#Cleanup
rm -rf build

#Build
mkdir build
go build -o ./build ./src/votingapp  #|| exit 1 Exit if error (1)
cp -r ./src/votingapp/ui ./build

#echo $?
#./pipeline.sh  && echo “GREN exitCode: $?” || echo “RED exitCode: $?”
#if go build -o ./build ./src/votingapp; then 
#   cp -r ./src/votingapp/ui ./build
#else 
#   exit 1
#fi

set -e #Stops when there's a error