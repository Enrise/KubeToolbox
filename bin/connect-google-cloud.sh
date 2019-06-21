#!/bin/sh

if [[ $# -ne 4 ]]; then
    echo "Usage: connect-google-cloud \"<gcp_service_account_key>\" \"<zone>\" \"<project>\" \"<cluster_name>\""
    exit 1
fi

echo "$1" > /tmp/.gcloud_private_key
gcloud auth activate-service-account --key-file /tmp/.gcloud_private_key
gcloud container clusters get-credentials "$4" --project "$3" --zone "$2"
