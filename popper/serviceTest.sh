#!/bin/bash -ex
# Startup badge service and test it
./popper badge service &

myId=$!
sleep 2

if [ 'pgrep popper' >/dev/null ]
then
    echo "Badge service running. Starting curl tests:"
    curl -d --url http://127.0.0.1:9090/testOrg1/testRepo1/testExp1/testSha1/invalid
    sleep 2

    curl -d --url http://127.0.0.1:9090/testOrg1/testRepo1/testExp1/testSha2/failed
    sleep 2

    curl -d --url http://127.0.0.1:9090/testOrg1/testRepo1/testExp1/testSha3/ok
    sleep 2

    curl -d --url http://127.0.0.1:9090/testOrg1/testRepo1/testExp1/testSha4/gold
    sleep 2

    curl --url http://127.0.0.1:9090/testOrg1/testRepo1/testExp1/status.svg
    sleep 2

    curl --url http://127.0.0.1:9090/testOrg1/testRepo1/testExp1/status
    sleep 2

    curl --url http://127.0.0.1:9090/testOrg1/testRepo1/testExp1/history
    sleep 2

    curl --url http://127.0.0.1:9090/testOrg1/testRepo1/testExp1/testSha1/status.svg
    sleep 2

    curl -d --url http://127.0.0.1:9090/testOrg1/testRepo2/testExp1/testSha1/gold
    sleep 2

    curl -d --url http://127.0.0.1:9090/testOrg1/testRepo2/testExp1/testSha2/failed
    sleep 2

    curl --url http://127.0.0.1:9090/testOrg1/testRepo2/testExp1/history
    sleep 2

    echo "Curl tests complete. Shutting down badge service."

    kill "$myId"

    if [ -e status.db ]
    then
        echo "status.db found, continuing test."
    else
        echo "PROBLEM: status.db not found."
    fi

    ./popper badge service &
    myId=$!
    sleep 2

    curl --url http://127.0.0.1:9090/testOrg1/testRepo1/testExp1/history
    sleep 2

    curl --url http://127.0.0.1:9090/testOrg1/testRepo2/testExp1/history
    sleep 2

    echo "Tests complete, shutting down."
    pkill $myId
else
    echo "Popper not running!"
fi