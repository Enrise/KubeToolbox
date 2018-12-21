# GCloud box with kubectl and extras

Available commands in this box:

- `gcloud`: google cloud commands
- `kubectl`: kubernetes commands
- `helm`: [helm kubernetes recipes](https://github.com/helm/helm)
- `envsubst '${ENV_VAR_1} ${ENV_VAR_2}' > dev/kube/production.yml < production.yml`: Replaces given environment variables in a file, into a new file

# What should your .gitlab-ci.yml look like?

```yml
# ======================
# CI Stages
# ======================

stages:
  - deploy

# ======================
# Production
# ======================

deploy to production:
  stage: deploy
  image: enrise/gcloudtoolbox:latest
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
