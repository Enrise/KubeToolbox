FROM google/cloud-sdk:alpine

# Install additions
RUN gcloud components install kubectl \
    && apk add --update --no-cache gettext

# Wait for rollout script
COPY wait-for-rollout.sh /bin/wait-for-rollout