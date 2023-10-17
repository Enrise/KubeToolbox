FROM google/cloud-sdk:alpine

# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.13.1"

# Copy over the connection helper script
COPY connect-kubernetes.sh /usr/local/bin/connect-kubernetes

# Install tools
RUN apk add --update --no-cache \
        bash \
        curl \
        docker \
        gettext \
        git \
        make \
        jq \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && gcloud components install gke-gcloud-auth-plugin kubectl \
    && chmod +x /usr/local/bin/*
