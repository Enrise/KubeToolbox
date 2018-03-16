#!/bin/sh

echo "Waiting for a rollout of $2 in namespace $1...";
COUNT=0
STARTED=false
while [ $STARTED = false ]; do
    COUNT=$((COUNT+1))
    kubectl -n "$1" get pods | grep "$2" | grep -v Running > /dev/null && STARTED=true
    if [ $STARTED = false ]; then
        if [ $COUNT -ge 10 ]; then
            echo "Could not find a rollout within 10 tries."
            echo "Did it already finish? Moving on..."
            break
        fi
        echo "Waiting for a roll-out start $COUNT/10..."
        sleep 1
    fi
done

if [ $STARTED = true ]; then
    echo "Found a $2 roll-out, waiting for completion..."
fi

COUNT=0
COMPLETED=false
while [ $COMPLETED = false ]; do
    COUNT=$((COUNT+1))
    kubectl -n "$1" get pods | grep "$2" | grep -v Running > /dev/null || COMPLETED=true
    kubectl -n "$1" get pods | grep "$2"
    if [ $COMPLETED = false ]; then
        if [ $COUNT -ge 180 ]; then
            echo "Could not find a completed rollout within 180 tries. Terminating."
            exit 1
        fi
        echo "Roll-out in progress ($COUNT/180)..."
        sleep 1
    fi
done

echo "The container roll-out is complete, waiting 5 seconds to be extra sure...";
sleep 5
echo "Done, $2 should be available!"
