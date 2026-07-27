# Architecture Diagram and Component Description

This project uses a local Kubernetes cluster and a cost analytics stack for portfolio demonstration.

## Architecture overview

```
+----------------+       +----------------+       +----------------+
|                |       |                |       |                |
|  Kubernetes    |  ---> |  Prometheus    |  ---> |  Grafana       |
|  Cluster       |       |  Monitoring    |       |  Dashboard     |
|  (Minikube/Kind)|      |  (existing or  |       |  (cost +       |
|                |       |   bundled)     |       |   utilization) |
+----------------+       +----------------+       +----------------+
         |                                ^
         |                                |
         v                                |
+----------------+                       |
|                |                       |
|  Kubecost      |                       |
|  Cost Analyzer |-----------------------+
|  (cluster-level|   cost allocation,     |
|   cost + waste)|   utilization,         |
|                |   over-provisioning    |
+----------------+
```

## Components

- Kubernetes cluster: local Minikube or Kind cluster running microservices with HPA/KEDA.
- Prometheus: existing monitoring backend for metrics collection.
- Grafana: visualization layer for dashboards and alerting.
- Kubecost: cost analytics installed into the cluster to estimate resource cost and waste.
- VPA: Vertical Pod Autoscaler in recommendation-only mode to suggest optimized CPU/memory.

## What this architecture shows

- Cluster-level cost and utilization are captured in Kubecost.
- Prometheus metrics are used for actual CPU/memory usage and request comparisons.
- Grafana visualizes requested vs actual usage, namespace allocation, and savings.
- VPA produces recommendations that can be safely reviewed before applying.

## Notes for a portfolio project

- This architecture is strong for DevOps because it integrates monitoring, cost analytics, autoscaling, and optimization.
- The project focuses on visibility first, then recommendations, then safe change.
- In a local demo, the value is shown through measured before/after allocation and estimated savings.
