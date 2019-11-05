#!/bin/bash
set -e

#Install Deps
deps() {

    go get github.com/gorilla/websocket
    go get github.com/labstack/echo
    go get golang.org/x/sys/unix
    
}

#Cleanup
cleanup() {

    #pkill do not exist in git bash
    #Cross-platform if pkill --> Command not found then:
    #pkill votingapp || ps aux | grep votingapp | head -1 | awk {'print $1'} | head -1 | xargs kill -9
    docker rm -f myvotingapp || true
    rm -rf build  || true #If build does not exist the pipeline do not stops

}

#Build
build() {

    mkdir build
    go build -o ./build ./src/votingapp  #|| exit 1 Exit if error (1)
    cp -r ./src/votingapp/ui ./build

    #Change directory to buildn and background execution (&)
    #pushd build
    #./votingapp &
    docker build -f src/votingapp/Dockerfile -t joanflotatsa/votingapp .
    docker run --name myvotingapp -p 8080:80 -d joanflotatsa/votingapp
    #docker run --name myvotingapp -it -v /$(pwd)/build:/app -w //app -p 8080:80 - d ubuntu ./votingapp
    #popd
}

#echo $?
#./pipeline.sh  && echo “GREN exitCode: $?” || echo “RED exitCode: $?”
#if go build -o ./build ./src/votingapp; then 
#   cp -r ./src/votingapp/ui ./build
#else 
#   exit 1
#fi

#set -e Stops when there's a error

#Test
test() {
    curl http://localhost:8080/vote \
        --request POST \
        --data '{"topics":["Dev","Ops"]}' \
        --header "Content-Type: application/json"

    curl http://localhost:8080/vote \
        --request PUT \
        --data '{"topic":"Dev"}' \
        --header "Content-Type: application/json"

    winner=$(curl http://localhost:8080/vote \
        --request DELETE \
        --header "Content-Type: application/json" | jq -r '.winner')
    # | jq -r '.winner'
    echo "Winner IS "$winner

    expectedWinner="Dev"

    if [ $expectedWinner == $winner ]; then 
        echo "TEST PASSED"
        return 0 
    else
        echo "TEST FAILED"
        return 1
    fi
}

retry(){

    n=0
    interval=5
    retries=3

    #Reture 0 if there's no errors in test
    $@ && return 0
    until [ $n -ge $retries ]
    do
        n=$[$n+1]
        echo "Retrying...$n of $retries, wait for $interval seconds"
        sleep $interval
        $@ && return 0
    done

    return 1
}

deps
cleanup
GOOS=linux build 
retry test

#Delivery
docker push joanflotatsa/votingapp