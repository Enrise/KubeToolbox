# ======================
# Build target
# ======================

FROM alpine:3.10 AS build

# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v2.14.1"

RUN apk add --update \
    bash \
    gcc \
    libffi-dev \
    openssl-dev \
    make \
    musl-dev \
    python3 \
    python3-dev \
    py3-pip

# Install AWS cli
RUN python3 -m venv /opt/aws \
    && source /opt/aws/bin/activate \
    && pip install awscli \
    && deactivate

# Install Azure cli
RUN python3 -m venv /opt/az \
    && source /opt/az/bin/activate \
    && pip install azure-cli \
    && deactivate

# Install Helm
RUN wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm

## ======================
## Production target
## ======================

FROM google/cloud-sdk:alpine as prod

# Copy over the connection helper scripts
COPY bin/* /usr/local/bin/

# Copy over the installed AWS and Azure cli's
COPY --from=build /opt /opt

# Copy over Helm
COPY --from=build /usr/local/bin/helm /usr/local/bin/helm

# Install tools.
# Note: groff and less are needed for aws.
RUN apk add --update --no-cache \
        bash \
        docker \
        gettext \
        groff \
        jq \
        less \
        python3 \
    # Make all binaries executable
    && chmod +x /usr/local/bin/* \
    # Install Gcloud components
    && gcloud components install beta kubectl \
    # Cleanup
    && rm -rf /var/cache/apk/* /google-cloud-sdk/bin/kubectl.*
