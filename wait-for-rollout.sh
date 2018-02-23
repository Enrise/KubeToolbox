#!/bin/sh

COUNT=0
STARTED=false
while [ $STARTED = false ]; do
    COUNT=$((COUNT+1))
    if [ $COUNT -ge 10 ]; then
        echo "Could not find a rollout within $COUNT/10 tries, continuing..."
        break
    fi
    kubectl -n $1 get pods | grep $2 | grep -v Running > /dev/null && STARTED=true
    echo "Waiting for container roll-out start $COUNT/10..."
    sleep 1
done

COUNT=0
COMPLETED=false
while [ $COMPLETED = false ]; do
    COUNT=$((COUNT+1))
    if [ $COUNT -ge 120 ]; then
        echo "Could not find a completed rollout within $COUNT/120 tries. Terminating."
        exit 1
    fi
    echo "Waiting for the container roll-out to complete $COUNT/120..."
    kubectl -n $1 get pods | grep $2
    kubectl -n $1 get pods | grep $2 | grep -v Running > /dev/null || COMPLETED=true
    sleep 1
done

echo "The container roll-out is complete, waiting 5 seconds to be extra sure...";
sleep 5
echo "Done!"
