#!/usr/bin/env bash

set -euo pipefail

NAMESPACE=kubecost
RELEASE=kubecost
USE_EXISTING_PROMETHEUS=${USE_EXISTING_PROMETHEUS:-false}
PROMETHEUS_URL=${PROMETHEUS_URL:-http://prometheus-operated.monitoring.svc.cluster.local:9090}

echo "Installing Kubecost into namespace $NAMESPACE"

kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

helm repo add kubecost https://kubecost.github.io/cost-analyzer/
helm repo update

if [ "$USE_EXISTING_PROMETHEUS" = "true" ]; then
  echo "Using existing Prometheus at $PROMETHEUS_URL"
  helm upgrade --install "$RELEASE" kubecost/cost-analyzer \
    --namespace "$NAMESPACE" \
    --set prometheus.enabled=false \
    --set prometheus.server.url="$PROMETHEUS_URL" \
    --set global.prometheusScrape=true \
    --set global.clusterId="minikube-local" \
    --set prometheus.server.global.external_labels.cluster_id="minikube-local"
else
  echo "Installing Kubecost with bundled Prometheus"
  helm upgrade --install "$RELEASE" kubecost/cost-analyzer \
    --namespace "$NAMESPACE" \
    --set prometheus.enabled=true \
    --set grafana.enabled=false \
    --set global.prometheusScrape=true \
    --set global.clusterId="minikube-local" \
    --set prometheus.server.global.external_labels.cluster_id="minikube-local"
fi

echo "Kubecost install requested. Check status with: kubectl get pods -n $NAMESPACE"
