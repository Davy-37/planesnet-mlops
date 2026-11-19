# Operations

Status: configuration files **present**; end-to-end deployment **planned**.

## Local stack

```bash
cp .env.example .env      # then set real passwords
make up                   # docker compose: postgres, mlflow, api, prometheus, grafana
```

| Service | Port |
|---|---|
| MLflow | 5000 |
| API | 8000 |
| Prometheus | 9090 |
| Grafana | 3000 |

## Kubernetes

Manifests in [`k8s/`](../k8s/), applied with `make deploy` (`kubectl apply -k k8s/`):

- `deployment.yaml`: 2 replicas, CPU/memory requests and limits, readiness and liveness probes on `/healthz`;
- `service.yaml`, `ingress.yaml`: exposure of the API;
- `hpa.yaml`: 2 to 6 replicas, target 70 % CPU.

The target environment is a single VM running k3s. The image is pulled from GitHub Container Registry.

## Model lifecycle

1. `dvc repro` trains and evaluates; `register` creates a registry version if the promotion gates pass.
2. A maintainer moves the `@production` alias to the new version in MLflow.
3. API pods load the alias at startup: a rollout restart serves the new model.

### Rollback

Move `@production` back to the previous version, then `kubectl rollout restart deployment/planesnet-api`. No image rebuild is needed. The measured rollback time is reported in [METRICS.md](../METRICS.md).

## Monitoring

The API exposes Prometheus metrics on `/metrics`: request latency, throughput, score distribution, abstention count.

Alert rules ([`monitoring/prometheus/alerts.yml`](../monitoring/prometheus/alerts.yml)):

| Alert | Condition | Severity |
|---|---|---|
| `LatenceP95Elevee` | p95 latency > 0.5 s for 5 min | warning |
| `TauxAbstentionAnormal` | abstention rate > 20 % for 15 min | critical (probable input drift) |

The Grafana dashboard is versioned as JSON in [`monitoring/grafana/`](../monitoring/grafana/).

## Drift detection

Evidently compares production inputs and scores with a reference set built from the training data: per-channel image statistics and the score distribution. Drift is validated by feeding deliberately degraded images (noise, blur, brightness shift) and checking that the report flags them.
