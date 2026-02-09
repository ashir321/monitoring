# Monitoring Stack

A complete Kubernetes monitoring stack with Prometheus, Grafana, Loki, Fluent Bit, Node Exporter, and Kube State Metrics.

## Prerequisites

- A running Kubernetes cluster (v1.20+)
- `kubectl` installed and configured to communicate with your cluster
- Cluster admin permissions (required for RBAC and DaemonSet resources)
- Sufficient cluster resources (at least 2 CPU cores and 4 GB RAM available)

## Project Structure

| File | Description |
|------|-------------|
| `Prometheus_RBAC.yml` | ServiceAccount, ClusterRole, and ClusterRoleBinding for Prometheus |
| `Prometheus_ConfigMap.yml` | Prometheus scrape configuration |
| `Prometheus_Persistent-Storage.yml` | PersistentVolumeClaim for Prometheus data |
| `Prometheus_Deployment-Service.yml` | Prometheus Deployment and Service |
| `Grafana_ConfigMap-Datasources.yml` | Grafana datasource configuration (Prometheus & Loki) |
| `Grafana_ConfigMap-DashboardProviders.yml` | Grafana dashboard provider configuration |
| `Grafana_ConfigMap-KubernetesDashboard.yml` | Pre-built Kubernetes dashboard for Grafana |
| `Grafana_Deployment-Service.yml` | Grafana Deployment and Service |
| `Loki_ConfigMap.yml` | Loki configuration |
| `Loki_Deployment-Service.yml` | Loki Deployment and Service |
| `FluentBit.yml` | Fluent Bit DaemonSet for log collection |
| `FluentBit.yml-NW` | Fluent Bit DaemonSet (alternate/network config) |
| `NodeExporter_DaemonSet.yml` | Node Exporter DaemonSet for host metrics |
| `Kube-State-Metrics.yml` | Kube State Metrics Deployment for cluster-level metrics |

## Steps to Run

### 1. Create Namespace (optional)

```bash
kubectl create namespace monitoring
```

> If you use a custom namespace, update the namespace field in all YAML files accordingly.

### 2. Deploy Prometheus

```bash
# Set up RBAC permissions
kubectl apply -f Prometheus_RBAC.yml

# Create Prometheus configuration
kubectl apply -f Prometheus_ConfigMap.yml

# Create persistent storage for Prometheus data
kubectl apply -f Prometheus_Persistent-Storage.yml

# Deploy Prometheus
kubectl apply -f Prometheus_Deployment-Service.yml
```

### 3. Deploy Kube State Metrics and Node Exporter

```bash
# Deploy Kube State Metrics
kubectl apply -f Kube-State-Metrics.yml

# Deploy Node Exporter
kubectl apply -f NodeExporter_DaemonSet.yml
```

### 4. Deploy Loki (Log Aggregation)

```bash
# Create Loki configuration
kubectl apply -f Loki_ConfigMap.yml

# Deploy Loki
kubectl apply -f Loki_Deployment-Service.yml
```

### 5. Deploy Fluent Bit (Log Collector)

```bash
kubectl apply -f FluentBit.yml
```

### 6. Deploy Grafana

```bash
# Create Grafana configurations
kubectl apply -f Grafana_ConfigMap-Datasources.yml
kubectl apply -f Grafana_ConfigMap-DashboardProviders.yml
kubectl apply -f Grafana_ConfigMap-KubernetesDashboard.yml

# Deploy Grafana
kubectl apply -f Grafana_Deployment-Service.yml
```

### 7. Verify Deployment

```bash
# Check all pods are running
kubectl get pods

# Check all services
kubectl get svc
```

### 8. Access the Dashboards

- **Grafana**: Access via the Grafana service (default credentials: `admin` / `admin`)
- **Prometheus**: Access via the Prometheus service UI

Use `kubectl port-forward` to access locally:

```bash
# Grafana
kubectl port-forward svc/grafana 3000:3000

# Prometheus
kubectl port-forward svc/prometheus-service 9090:9090
```

## Tear Down

To remove all monitoring resources:

```bash
kubectl delete -f Grafana_Deployment-Service.yml
kubectl delete -f Grafana_ConfigMap-KubernetesDashboard.yml
kubectl delete -f Grafana_ConfigMap-DashboardProviders.yml
kubectl delete -f Grafana_ConfigMap-Datasources.yml
kubectl delete -f FluentBit.yml
kubectl delete -f Loki_Deployment-Service.yml
kubectl delete -f Loki_ConfigMap.yml
kubectl delete -f NodeExporter_DaemonSet.yml
kubectl delete -f Kube-State-Metrics.yml
kubectl delete -f Prometheus_Deployment-Service.yml
kubectl delete -f Prometheus_Persistent-Storage.yml
kubectl delete -f Prometheus_ConfigMap.yml
kubectl delete -f Prometheus_RBAC.yml
```
