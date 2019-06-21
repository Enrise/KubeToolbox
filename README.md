# Kubernetes box for Kubernetes deployment and management on various cloud providers

Available commands in this box:

- `aws`: Amazon web services commands
- `gcloud`: Google Cloud commands
- `kubectl`: Kubernetes commands
- `helm`: [Helm kubernetes recipes](https://github.com/helm/helm)
- `envsubst '${ENV_VAR_1} ${ENV_VAR_2}' < dev/kube/production.yml > production.yml`: Replaces given environment variables in a file, into a new file
- `jq`: Tool to format json strings

# What should your .gitlab-ci.yml look like?

Pick the right deployment job for you depending on what cloud platform you want to deploy to.

```yml
# ======================
# CI Stages
# ======================

stages:
  - deploy

# ======================
# Production
# ======================

deploy to amazon web services:
  stage: deploy
  image: enrise/kube-toolbox:latest
  environment:
    name: production
    url: https://example.com
  only:
    - master
  before_script:
    - connect-aws "<aws_access_key_id>" "<aws_secret_access_key>" "<region>" "<cluster_name>"
  script:
    - envsubst < dev/kube/example.yml > example.yml
    - kubectl apply -f example.yml
    - kubectl rollout status deployment -n example-namespace example-deployment-name

deploy to google cloud platform:
  stage: deploy
  image: enrise/kube-toolbox:latest
  environment:
    name: production
    url: https://example.com
  only:
    - master
  before_script:
    - connect-google-cloud "<gcp_service_account_key>" "<zone>" "<project>" "<cluster_name>"
  script:
    - envsubst < dev/kube/example.yml > example.yml
    - kubectl apply -f example.yml
    - kubectl rollout status deployment -n example-namespace example-deployment-name
```

... or if you migrated from enrise/gcloudtoolbox you can still use the original commands:

```
legacy deployment to google cloud platform:
  stage: deploy
  image: enrise/kube-toolbox:latest
  environment:
    name: production
    url: https://example.com
  only:
    - master
  before_script:
    - echo $GCLOUD_SERVICE_ACCOUNT_KEY > /tmp/.gcloud_private_key
    - gcloud auth activate-service-account --key-file /tmp/.gcloud_private_key
    - gcloud container clusters get-credentials example-gcloud-id --project example-project --zone europe-example
  script:
    - envsubst < dev/kube/example.yml > example.yml
    - kubectl apply -f example.yml
    - kubectl rollout status deployment -n example-namespace example-deployment-name
```

# Migration from enrise/gcloudtoolbox

The enrise/kube-toolbox container is fully backwards compatible with the old enrise/gcloudtoolbox container, with the
exception of the old `wait-for-rollout` script which has been removed. Simply update your deployment so it uses
`kubectl rollout status deployment` instead, as shown in the examples above.
