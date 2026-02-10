#!/bin/bash
# Script to update the GitHub token for actions-runner-controller
# Usage: ./update-github-token.sh <your-github-token>

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <github-token>"
    echo "Example: $0 ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    exit 1
fi

GITHUB_TOKEN="$1"
SECRET_NAME="${SECRET_NAME:-actions-runner-controller-secret}"
NAMESPACE="${NAMESPACE:-actions-runner-system}"

echo "Updating GitHub token in secret '$SECRET_NAME' in namespace '$NAMESPACE'..."

# Check if secret exists
if kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" >/dev/null 2>&1; then
    echo "Secret exists, updating..."
    kubectl delete secret "$SECRET_NAME" -n "$NAMESPACE"
fi

# Create or recreate the secret
kubectl create secret generic "$SECRET_NAME" \
    --from-literal=github_token="$GITHUB_TOKEN" \
    -n "$NAMESPACE"

echo "Secret updated successfully!"
echo ""
echo "Note: You may need to restart the actions-runner-controller pods for the change to take effect:"
echo "  kubectl rollout restart deployment -n $NAMESPACE -l app.kubernetes.io/name=actions-runner-controller"
