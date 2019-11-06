#!/bin/sh
test() {
    curl "http://${VOTINGAPP_HOST}/vote" \
        --request POST \
        --data '{"topics":["Dev","Ops"]}' \
        --header "Content-Type: application/json"

    curl "http://${VOTINGAPP_HOST}/vote" \
        --request PUT \
        --data '{"topic":"Dev"}' \
        --header "Content-Type: application/json"

    winner=$(curl "http://${VOTINGAPP_HOST}/vote" \
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
        n=$(($n+1))
        echo "Retrying...$n of $retries, wait for $interval seconds"
        sleep $interval
        $@ && return 0
    done

    return 1
}

retry test