import requests
import pytest
import json
import os

def voteResponse():

    host = os.environ['VOTINGAPP_HOST']

    requests.post('http://' + host + '/vote', data='{"topics":["Dev","Ops"]}', headers={"Content-Type":"application/json"})
    requests.put('http://' + host + '/vote', data='{"topic":"Dev"}',  headers={"Content-Type":"application/json"})
    result = requests.delete('http://' + host + '/vote',  headers={"Content-Type":"application/json"})
    return result

def retry():
    
    for i in range(0, 3): 
        print("Try " + str(i) + ": ")
        response = voteResponse()
        if response.status_code == 200: 
            winner = json.loads(response.text)
            print("Connection successful")
            return winner['winner']
        print("Connection failed")
    print("Fatal error: Connection failed")
    return "Fail"

def test_response():

    assert retry() == "Dev"

