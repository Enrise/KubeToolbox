#!/bin/sh

if [[ $# -ne 4 ]]; then
    echo "Usage: connect-google-cloud \"<gcp_service_account_key_file>\" \"<zone>\" \"<project>\" \"<cluster_name>\""
    exit 1
fi

gcloud auth activate-service-account --key-file "$1"
gcloud container clusters get-credentials "$4" --project "$3" --zone "$2"
