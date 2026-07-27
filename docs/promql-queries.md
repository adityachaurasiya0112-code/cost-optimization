# PromQL Queries for Cost Optimization Dashboard

These queries are designed for a Prometheus + Grafana setup and assume standard Kubernetes metrics.

## 1. CPU usage per deployment

```promql
sum by (namespace, deployment) (
  rate(container_cpu_usage_seconds_total{image!="",container!="POD"}[5m])
)
```

## 2. Memory usage per deployment

```promql
sum by (namespace, deployment) (
  container_memory_working_set_bytes{image!="",container!="POD"}
)
```

## 3. Requested CPU per deployment

This assumes request metrics are available via kube-state-metrics.

```promql
sum by (namespace, deployment) (
  kube_pod_container_resource_requests_cpu_cores{resource="cpu"}
)
```

## 4. Requested memory per deployment

```promql
sum by (namespace, deployment) (
  kube_pod_container_resource_requests_memory_bytes{resource="memory"}
)
```

## 5. Requested vs actual CPU gap

```promql
(sum by (namespace, deployment) (
  kube_pod_container_resource_requests_cpu_cores{resource="cpu"}
)
-
sum by (namespace, deployment) (
  rate(container_cpu_usage_seconds_total{image!="",container!="POD"}[5m])
))
```

## 6. Requested vs actual memory gap

```promql
(sum by (namespace, deployment) (
  kube_pod_container_resource_requests_memory_bytes{resource="memory"}
)
-
sum by (namespace, deployment) (
  container_memory_working_set_bytes{image!="",container!="POD"}
))
```

## 7. CPU wasted percentage by deployment

```promql
100 * (1 -
  sum by (namespace, deployment) (
    rate(container_cpu_usage_seconds_total{image!="",container!="POD"}[5m])
  ) /
  sum by (namespace, deployment) (
    kube_pod_container_resource_requests_cpu_cores{resource="cpu"}
  )
)
```

## 8. Memory wasted percentage by deployment

```promql
100 * (1 -
  sum by (namespace, deployment) (
    container_memory_working_set_bytes{image!="",container!="POD"}
  ) /
  sum by (namespace, deployment) (
    kube_pod_container_resource_requests_memory_bytes{resource="memory"}
  )
)
```

## 9. Estimated monthly savings example

If Kubecost exposes a cost metric like `kubecost_cpu_cost`, use a dashboard expression to estimate savings.

```promql
sum(kubecost_cpu_cost) + sum(kubecost_memory_cost)
```

Use the chart time range and an average-over-time function to estimate month-long cost.

## 10. Kubecost-specific recommendation metrics

If Kubecost is running, use:

```promql
kubecost_allocation_cpu_cores
kubecost_allocation_memory_bytes
kubecost_waste_cpu_cores
kubecost_waste_memory_bytes
```

These metrics are useful in Grafana panels for cluster-level waste and namespace cost.
