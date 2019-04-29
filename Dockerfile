FROM google/cloud-sdk:alpine

# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v2.12.1"

# Set workdir
WORKDIR /opt/Enrise/GCloudToolBox

# Install additions
RUN gcloud components install beta kubectl \
    && apk add --update --no-cache \
    gettext \
    make \
    jq \
    && wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /bin/helm \
    && chmod +x /bin/helm

# Wait for rollout script
COPY wait-for-rollout.sh /bin/wait-for-rollout
