# Kubernetes Cost Optimization Dashboard

This repo is a portfolio-ready local demo for a Kubernetes cost optimization project.
It guides a beginner DevOps engineer through installing Kubecost on a local cluster, analyzing resource waste, using VPA recommendation mode, and building Grafana dashboards with PromQL.

## Project Goal

- Add cost visibility and optimization on top of an existing Kubernetes + Prometheus + Grafana setup.
- Track cluster-level spend, identify over-provisioned CPU/memory, and suggest optimized requests/limits.
- Build dashboard panels for requested vs actual usage and estimated savings.

## What is included

- `scripts/install_kubecost.sh` - install Kubecost on Minikube/Kind with bundled or existing Prometheus.
- `scripts/apply_vpa.sh` - install VPA in recommendation-only mode for a sample deployment.
- `manifests/vpa-recommendation.yaml` - example VPA manifest template.
- `docs/promql-queries.md` - PromQL examples for utilization and cost panels.
- `docs/architecture.md` - architecture diagram and component explanation.
- `dashboards/kubecost-optimization-dashboard.json` - sample Grafana dashboard import.

## Prerequisites

- Local Kubernetes cluster: Minikube or Kind.
- `kubectl` configured to the active cluster.
- `helm` installed.
- Prometheus and Grafana already available in the cluster (preferred).
- Optional: `minikube` binary to open services.

## Step-by-step workflow

### 1. Select cluster context

Check current cluster:

```bash
kubectl config current-context
```

Switch context if needed:

```bash
kubectl config use-context minikube
# or
kubectl config use-context kind-kind
```

### 2. Install Kubecost

Run the install script:

```bash
bash scripts/install_kubecost.sh
```

If you have an existing Prometheus service, set:

```bash
USE_EXISTING_PROMETHEUS=true bash scripts/install_kubecost.sh
```

### 3. Verify Kubecost

```bash
kubectl get pods -n kubecost
kubectl get svc -n kubecost
```

Open the UI:

- Minikube: `minikube service kubecost-cost-analyzer --namespace kubecost`
- Kind: `kubectl -n kubecost port-forward deployment/kubecost-cost-analyzer 9090:9090`

### 4. Capture current usage and allocation

Use `kubectl top`:

```bash
kubectl top pods --all-namespaces
kubectl top nodes
```

Inspect deployment YAMLs for resources:

```bash
kubectl get deployment -A -o yaml | grep -nE "resources:|requests:|limits:" -n
```

Use PromQL from `docs/promql-queries.md` to compare actual usage against requests.

### 5. Identify over-provisioned deployments

- Look for deployments where actual usage is significantly below requests.
- Use Kubecost wasted resource charts and the PromQL gap panel.
- Document deployments with high request/usage mismatch.

### 6. Set up VPA recommendation mode

Use `scripts/apply_vpa.sh` to deploy VPA for one sample deployment.

```bash
bash scripts/apply_vpa.sh
```

Then inspect recommendations:

```bash
kubectl get vpa -n default
kubectl describe vpa vpa-recommender
```

### 7. Apply safe optimized resources

- Start with recommendation-only VPA suggestions.
- Update deployment resource requests/limits gradually.
- Keep HPA/KEDA active to avoid breaking autoscaling.

### 8. Build Grafana dashboard panels

Import `dashboards/kubecost-optimization-dashboard.json` or use the panel definitions from `docs/promql-queries.md`.

### 9. Record before/after metrics

Capture:

- Total allocated CPU/memory before optimization.
- Total requested CPU/memory after optimization.
- Estimated monthly cost before/after using Kubecost metrics.
- Percent improvement and savings estimate.

### 10. Project README content for your CV

Write the final project summary with:

- Architecture description
- Design decisions
- Before/after savings
- Tradeoffs and mitigation
- Lessons learned

Use the `docs/architecture.md` file as the basis for the architecture section.

## New files

- `docs/before_after_tracking.md` - template for capturing baseline and post-tuning metrics.
- `dashboards/kubecost-optimization-dashboard.json` - sample Grafana dashboard import.
- `scripts/apply_vpa.sh` - helper script to create VPA recommendation-only.

## Next actions

- Install Kubecost on your local cluster with `bash scripts/install_kubecost.sh`.
- If you want a demo workload, apply `manifests/demo-deployment.yaml`.
- Confirm whether you want bundled Prometheus or integration with your existing Prometheus.
- Then use `docs/promql-queries.md` to build the dashboard panels.
