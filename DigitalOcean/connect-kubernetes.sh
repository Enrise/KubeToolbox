#!/bin/sh

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 \"<api_personal_access_token>\" \"<cluster_name>\""
    exit 1
fi

doctl auth init -t "$1"
doctl kubernetes cluster kubeconfig save "$2"
