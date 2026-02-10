I use [ARC - Actions Runner Controller](https://github.com/actions/actions-runner-controller/blob/master/docs/quickstart.md), installed with Helm. Their CRDs makes it quite easy to manage self-hosted runners.

# To install ARC

```sh
helm upgrade --install --namespace actions-runner-system --create-namespace \
-f values.yaml \
--wait actions-runner-controller actions-runner-controller/actions-runner-controller
```

# Update the token

[Generate a token](https://github.com/settings/tokens) and replace it in the `values.yaml`. You might have to change the regcred secret in the `actions-runner-system` namesapce also.

# Add a runner for a new repo

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: name of runner
spec:
  replicas: 1
  template:
    spec:
      image: runner image
      repository: repository URI
```

Exemple for me :

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: runner-cacao
  namespace: actions-runner-system
spec:
  replicas: 1
  template:
    spec:
      image: ghcr.io/neito-s-den/actions-runner:latest
      repository: NeitoFR/association-cacao
```
