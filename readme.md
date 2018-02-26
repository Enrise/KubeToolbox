# GCloud box with kubectl and extras

Available commands in this box:

- `gcloud`: google cloud commands
- `kubectl`: kubernetes commands
- `wait-for-rollout <namespace> <pod-name>`: waits for a rollout te be fully completed
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
        - wait-for-rollout example-namespace example-deployment-name
```
