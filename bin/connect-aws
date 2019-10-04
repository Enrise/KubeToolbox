#!/bin/sh

if [[ $# -ne 4 ]]; then
    echo "Usage: connect-aws \"<aws_access_key_id>\" \"<aws_secret_access_key>\" \"<region>\" \"<cluster_name>\""
    exit 1
fi

mkdir -p ~/.aws
echo -e "[default]\naws_access_key_id = $1\naws_secret_access_key = $2" > ~/.aws/credentials
aws eks --region $3 update-kubeconfig --name $4