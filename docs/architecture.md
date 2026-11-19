# Architecture

## Purpose

PlanesNet MLOps turns a university image classifier (aircraft vs. no aircraft in 20×20 px satellite chips) into a versioned, served and monitored system. The model is intentionally frozen; the value is in the pipeline.

The project has one methodological goal on top of the engineering one: measure how much the original results were inflated by **scene leakage** (chips from the same satellite scene in both train and test), by comparing a random split with a split grouped by `scene_id`.

## Components

```
                 ┌────────────── training side ──────────────┐
planesnet.json → DVC: prepare → split → train → evaluate → register
                                         │                    │
                                         ▼                    ▼
                                  MLflow tracking     MLflow Model Registry
                                                      (alias @production)
                 ┌────────────── serving side ───────────────┐ │
   client ──HTTP──▶ FastAPI (api/) ◀── loads model at startup ─┘
                       │
                       ├── /metrics ──▶ Prometheus ──▶ Grafana, alerts
                       └── logged inputs/scores ──▶ Evidently drift reports
```

| Component | Technology | Location |
|---|---|---|
| Data versioning and pipeline | DVC | `dvc.yaml`, `params.yaml`, `scripts/` |
| Library code | Python package `planesnet` | `src/planesnet/` |
| Experiment tracking and registry | MLflow (PostgreSQL backend) | `docker-compose.yml` |
| Serving | FastAPI + Uvicorn | `api/` |
| Packaging | Docker multi-stage, CPU-only PyTorch | `Dockerfile` |
| Orchestration | Kubernetes (k3s on a single VM) | `k8s/` |
| Metrics and alerts | Prometheus, Grafana | `monitoring/` |
| Drift | Evidently | `src/planesnet/monitoring/` |
| Automation | GitHub Actions, pre-commit | `.github/workflows/`, `.pre-commit-config.yaml` |

## Repository layout

```
src/planesnet/        library (public API in each __init__.py, internals in _*.py)
  data/               loading, manifest, splits, transforms
  models/             ResNet18, checkpoints
  training/           training loop, evaluation, threshold selection
  serving/            registry loading, predictor, Pydantic schemas
  monitoring/         reference set, drift reports
api/                  FastAPI application (main, routes, metrics)
scripts/              one entry point per DVC stage
tests/                pytest suite
docs/                 technical documentation (this folder)
k8s/  monitoring/     deployment and observability configuration
```

### Public and internal modules

Each subpackage exposes its public API in `__init__.py`. Implementation lives in modules prefixed with `_`, which are internal and may change without a major version bump:

```python
from planesnet.data import split_by_scene        # supported
from planesnet.data._splitter import ...         # internal, not supported
```

## Key design decisions

| Topic | Decision | Reason |
|---|---|---|
| Split | `StratifiedGroupKFold` on `scene_id` | Only way to get an honest number; the random split is kept only for comparison |
| Model | ResNet18 fine-tuned, frozen after the baseline | The project optimizes the pipeline, not the metric |
| Model loading | From the MLflow registry at API startup, not baked into the image | Change or roll back the model without rebuilding the image |
| Promotion | Automatic only above `params.yaml` thresholds; `staging → production` stays manual | Avoid unreviewed auto-promotion |
| Threshold | Chosen on validation, never on test, with an abstention margin | Prevent test-set tuning |
| Drift | Image statistics + score distribution | Dataset too small for meaningful embeddings |
| Infrastructure | One VM + k3s | Public demo without the cost of a managed cluster |
| Image | `python:3.11-slim` + CPU-only torch | Image size reduced by an order of magnitude compared to CUDA |
