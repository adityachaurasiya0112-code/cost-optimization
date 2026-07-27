# Before / After Tracking Template

Use this template to capture your optimization results in a reproducible way.

## Baseline (Before optimization)

- Total allocated CPU: `____` cores
- Total allocated memory: `____` GiB
- Total requested CPU: `____` cores
- Total requested memory: `____` GiB
- Estimated monthly cluster cost: `____` USD
- Kubecost waste CPU: `____` cores
- Kubecost waste memory: `____` GiB

### Example commands to capture baseline

```bash
kubectl top pods --all-namespaces
kubectl top nodes
kubectl get deploy -A -o jsonpath='{range .items[*]}{.metadata.namespace}/{.metadata.name}: {.spec.template.spec.containers[*].resources.requests}\n{end}'
```

## Recommendations and target values

For each deployment:

- Deployment: `namespace/name`
- Current CPU request: `____`m
- Current CPU limit: `____`m
- Current memory request: `____`Mi
- Current memory limit: `____`Mi
- Observed CPU usage: `____`m average
- Observed memory usage: `____`Mi average
- Suggested CPU request: `____`m
- Suggested memory request: `____`Mi
- Notes: `____`

## After optimization

- Total allocated CPU: `____` cores
- Total allocated memory: `____` GiB
- Total requested CPU: `____` cores
- Total requested memory: `____` GiB
- Estimated monthly cluster cost: `____` USD
- Kubecost waste CPU: `____` cores
- Kubecost waste memory: `____` GiB

## Savings summary

- CPU reduction: `____`% or `____` cores
- Memory reduction: `____`% or `____` GiB
- Estimated cost savings: `____` USD/month
- Before/after ratio: `____`

## Notes

- Data source for actual usage: `kubectl top`, Prometheus queries, Kubecost allocation metrics
- Data source for cost estimate: `Kubecost dashboard`, generated PromQL cost metrics
- Important: keep HPA/KEDA active after resource tune-up to preserve autoscaling.
