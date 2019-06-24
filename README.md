# Kubernetes toolbox for various cloud providers

Available commands in this box:

- `aws`: Amazon web services commands
- `gcloud`: Google Cloud commands
- `kubectl`: Kubernetes commands
- `helm`: [Helm kubernetes recipes](https://github.com/helm/helm)
- `envsubst '${ENV_VAR_1} ${ENV_VAR_2}' < dev/kube/production.yml > production.yml`: Replaces given environment variables in a file, into a new file
- `jq`: Tool to format json strings

Currently the following cloud providers are supported:

- [Google Cloud Platform](https://cloud.google.com/) (see [Google Cloud deployment](#google-cloud-deployment))
- [Amazon Web Services](https://aws.amazon.com/) (see [Amazon deployment](#amazon-deployment))

In the future new cloud providers such as Microsoft Azure can be easily added.

# .gitlab-ci.yml example

## Stages

A deployment stage needs to be added to your pipeline

```yml
stages:
  - deploy
```

## Google Cloud deployment

```yml
deploy to google cloud platform:
  stage: deploy
  image: enrise/kube-toolbox:latest
  environment:
    name: production
    url: https://example.com
  only:
    - master
  before_script:
    - connect-google-cloud $SERVICE_ACCOUNT_KEY_FILE "<region>" "<project>" "<cluster_name>"
  script:
    - envsubst < dev/kube/manifest.yml > manifest.yml
    - kubectl apply -f manifest.yml
    - kubectl rollout status deployment -n "<namespace>" "<deployment-name>"
```

Make sure the `$SERVICE_ACCOUNT_KEY_FILE` is a path to the service account json file, containing all
secrets to properly connect to your account. In GitLab project settings you can configure a secret variable
to be served as a file directly.

If you only have the contents of the file available, create the
key file manually first as follows:

```yaml
  before_script:
    - echo $SERVICE_ACCOUNT_JSON_KEY > /tmp/.gcloud_private_key
    - connect-google-cloud /tmp/.gcloud_private_key "<region>" "<project>" "<cluster_name>"
```

## Amazon deployment

```yml
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
    - envsubst < dev/kube/manifest.yml > manifest.yml
    - kubectl apply -f manifest.yml
    - kubectl rollout status deployment -n "<namespace>" "<deployment-name>"
```

# GCloudToolbox migration

The enrise/kube-toolbox container is fully backwards compatible with the old enrise/gcloudtoolbox container, with the
exception of the old `wait-for-rollout` script which has been removed. Simply update your deployment so it uses
`kubectl rollout status deployment` instead, as shown in the examples above.

If you migrated from enrise/gcloudtoolbox you can still use the original commands:

```yml
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
