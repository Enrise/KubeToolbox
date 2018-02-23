FROM google/cloud-sdk:alpine

WORKDIR /www

EXPOSE 80

# Pack project
COPY . /www/

# Ningx
RUN gcloud components install kubectl \
    && apk add --update gettext

# Wait for rollout script
COPY wait-for-rollout.sh /bin/wait-for-rollout