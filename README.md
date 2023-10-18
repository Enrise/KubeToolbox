# KubeToolbox

This container makes it super easy for you to connect to kubernetes and apply the manifests you desire.

We have kube-toolboxes for:

- [Amazon Web Services](https://aws.amazon.com/) (see [Amazon](#amazon))
- [Microsoft Azure](https://azure.microsoft.com/) (see [Azure](#azure))
- [Digital Ocean](https://www.digitalocean.com/products/kubernetes/) (see [Digital Ocean](#digital-ocean))
- [Google Cloud Platform](https://cloud.google.com/) (see [Google Cloud](#google-cloud))

Every kube-toolbox contains:

- `bash`: the commonly used command line interface that's more advanced than `sh` itself
- `connect-kubernetes`: Check below how this command should be used for your cloud provider
- `curl`: Allows you to easily fire http requests
- `docker`: The docker client and server
- `envsubst '${ENV_VAR_1} ${ENV_VAR_2}' < dev/kube/production.yml > production.yml`: Replaces given environment
  variables in a file, into a new file
- `helm`: [Helm kubernetes recipes](https://github.com/helm/helm)
- `jq`: Tool to format json strings
- `kubectl`: Kubernetes command line interface

# Cloud providers

For every cloud provider we have an example of how to connect to your kubernetes cluster via a GitLab CI file.

## Amazon

The kube-toolbox for Azure is available with docker tag `enrise/kube-toolbox:amazon`.

The following additional packages are available:

- `aws`: this cli allows you to connect and interact with your AWS account.
- `connect-kubernetes "<aws_access_key_id>" "<aws_secret_access_key>" "<region>" "<cluster_name>"`:
  connects you with your Kubernetes cluster on AWS directly

```yml
deploy to amazon web services:
  stage: deploy
  image: enrise/kube-toolbox:amazon
  environment:
    name: production
    url: https://example.com
  only:
    - master
  before_script:
    - connect-kubernetes "<aws_access_key_id>" "<aws_secret_access_key>" "<region>" "<cluster_name>"
  script:
    - envsubst < kubernetes/manifest.yml > manifest.yml
    - kubectl apply -f manifest.yml
    - kubectl rollout status deployment -n "<namespace>" "<deployment-name>"
```

## Azure

The kube-toolbox for Azure is available with docker tag `enrise/kube-toolbox:azure`.

The following additional packages are available:

- `az`: this cli allows you to connect and interact with your Azure account.
- `connect-kubernetes "<azure_account_username>" <azure_account_password>" "<resource_group>" "<cluster_name>"`:
  connects you with your Kubernetes cluster on Azure directly

```yml
deploy to azure:
  stage: deploy
  image: enrise/kube-toolbox:azure
  environment:
    name: production
    url: https://example.com
  only:
    - master
  before_script:
    - connect-kubernetes "<azure_account_username>" <azure_account_password>" "<resource_group>" "<cluster_name>"
  script:
    - envsubst < kubernetes/manifest.yml > manifest.yml
    - kubectl apply -f manifest.yml
    - kubectl rollout status deployment -n "<namespace>" "<deployment-name>"
```

## Digital Ocean

The kube-toolbox for Digital Ocean is available with docker tag `enrise/kube-toolbox:digital-ocean`.

The following additional packages are available:

- `doctl`: this cli allows you to connect and interact with your Digital Ocean account.
- `connect-kubernetes "<api_personal_access_token>" "<cluster_name>"`: connects you with your
  Kubernetes cluster on Digital Ocean directly

```yml
deploy to digital ocean kubernetes:
  stage: deploy
  image: enrise/kube-toolbox:digital-ocean
  environment:
    name: production
    url: https://example.com
  only:
    - master
  before_script:
    - connect-kubernetes "<api_personal_access_token>" "<cluster_name>"
  script:
    - envsubst < kubernetes/manifest.yml > manifest.yml
    - kubectl apply -f manifest.yml
    - kubectl rollout status deployment -n "<namespace>" "<deployment-name>"
```

## Google Cloud

The kube-toolbox for Google Cloud is available with docker tag `enrise/kube-toolbox:google`.

The following additional packages are available:

- `gcloud`: this cli allows you to connect and interact with your Google Cloud account.
- `connect-kubernetes "<service_account_file>" <region>" "<project>" "<cluster_name>"`: connects you with your
  Kubernetes cluster on the Google Cloud directly

```yml
deploy to google cloud platform:
  stage: deploy
  image: enrise/kube-toolbox:google
  environment:
    name: production
    url: https://example.com
  only:
    - master
  before_script:
    - connect-kubernetes $SERVICE_ACCOUNT_KEY_FILE "<region>" "<project>" "<cluster_name>"
  script:
    - envsubst < kubernetes/manifest.yml > manifest.yml
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
    - connect-kubernetes /tmp/.gcloud_private_key "<region>" "<project>" "<cluster_name>"
```

# Tips

Some tips that might be helpful to you

## Recursive envsubst

With the following magic line, you can replace all environment variables in the `*.yml` files, recursively:

```shell
find . -iname \*.yml -type f -exec sh -c 'envsubst < $0 > $0.tmp && mv $0.tmp $0' {} \;
```

Another trick to make it more readable in your CI file:

```yaml
.replace-environment-variables-recursively: &replace-environment-variables-recursively |
    find . -iname \*.yml -type f -exec sh -c 'envsubst < $0 > $0.tmp && mv $0.tmp $0' {} \;

deploy to kubernetes:
  script:
    - cd kubernetes/
    - *replace-environment-variables-recursively
    - kubectl apply -f manifest.yml
    - kubectl rollout status deployment -n "<namespace>" "<deployment-name>"
```
