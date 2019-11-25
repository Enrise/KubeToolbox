#!/bin/sh

if [[ $# -ne 4 ]]; then
    echo "Usage: $0 \"<azure_username>\" \"<azure_password>\" \"<resource_group>\" \"<cluster_name>\""
    exit 1
fi

az login -u "$1" -p "$2"
az aks get-credentials --resource-group "$3" --name "$4"
