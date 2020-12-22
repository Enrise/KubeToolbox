FROM alpine:3.12

# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.4.2"

# Copy over the connection helper script
COPY connect-kubernetes.sh /usr/local/bin/connect-kubernetes

# Install tools
RUN apk add --update --no-cache \
        bash \
        curl \
        docker \
        gcc \
        gettext \
        git \
        make \
        musl-dev \
        jq \
        libffi-dev \
        openssl-dev \
        python3 \
        python3-dev \
        py3-pip \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && pip3 install azure-cli --upgrade \
    && apk del gcc libffi-dev openssl-dev \
    && ln -s /usr/bin/python3 /usr/local/bin/python \
    && az aks install-cli \
    && chmod +x /usr/local/bin/*
