#!/usr/bin/env bash

set -euo pipefail

NAMESPACE=${NAMESPACE:-default}
DEPLOYMENT=${DEPLOYMENT:-demo-app}
VPA_NAME=${VPA_NAME:-demo-app-vpa}

cat <<EOF | kubectl apply -f -
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: ${VPA_NAME}
  namespace: ${NAMESPACE}
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ${DEPLOYMENT}
  updatePolicy:
    updateMode: "Off"
  resourcePolicy:
    containerPolicies:
      - containerName: "*"
        minAllowed:
          cpu: "50m"
          memory: "64Mi"
        maxAllowed:
          cpu: "2000m"
          memory: "4Gi"
  recommendation:
    controlledResources:
      - cpu
      - memory
EOF

echo "Applied VPA recommendation-only for deployment '${DEPLOYMENT}' in namespace '${NAMESPACE}'."

echo "Inspect recommendations with:"
echo "  kubectl describe vpa ${VPA_NAME} -n ${NAMESPACE}"
