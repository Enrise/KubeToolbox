FROM alpine:3.22

# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.18.3"

# Copy over the connection helper script
COPY connect-kubernetes.sh /usr/local/bin/connect-kubernetes

# Install tools
RUN apk add --update --no-cache \
    bash \
    curl \
    docker \
    gettext \
    git \
    groff \
    make \
    jq \
    less \
    python3 \
    python3-dev \
    py3-pip \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && pip3 install --break-system-packages awscli --upgrade \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/*
