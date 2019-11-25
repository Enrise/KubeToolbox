FROM google/cloud-sdk:alpine

# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v2.16.1"

# Copy over the connection helper script
COPY connect-kubernetes.sh /usr/local/bin/connect-kubernetes

# Install tools
RUN apk add --update --no-cache \
        bash \
        curl \
        docker \
        gettext \
        make \
        jq \
    && wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && gcloud components install beta kubectl \
    && chmod +x /usr/local/bin/*
