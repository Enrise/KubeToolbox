FROM google/cloud-sdk:alpine

# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v2.14.1"

# Copy over the connection helper scripts
COPY bin/connect-aws.sh /usr/local/bin/connect-aws
COPY bin/connect-google-cloud.sh /usr/local/bin/connect-google-cloud

# Install tools.
# Note: groff and less are needed for aws.
RUN apk add --update --no-cache \
        gettext \
        groff \
        make \
        jq \
        less \
        py2-pip \
    && wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /bin/helm \
    && chmod +x /bin/helm \
    && pip install awscli --upgrade --user \
    && apk del py2-pip \
    && mv /root/.local/bin/aws /usr/local/bin \
    && gcloud components install beta kubectl \
    && chmod +x /usr/local/bin/*
