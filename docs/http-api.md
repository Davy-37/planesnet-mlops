# HTTP API

Status: **planned**. The service is a FastAPI application in [`api/`](../api/), started with `uvicorn api.main:app` (or `make serve`). FastAPI also serves an interactive OpenAPI page at `/docs`.

At startup the service loads the model referenced by `MODEL_URI` (default `models:/planesnet@production`) from `MLFLOW_TRACKING_URI`. The model is not embedded in the Docker image.

## Endpoints

| Method | Path | Description |
|---|---|---|
| `POST` | `/predict` | Classify one 20×20 RGB chip |
| `POST` | `/predict-batch` | Classify a list of chips |
| `GET` | `/healthz` | Liveness/readiness: returns 200 once the model is loaded |
| `GET` | `/model-info` | Served model name, version, threshold, training run ID |
| `GET` | `/metrics` | Prometheus metrics |

## Prediction contract

Request (`PredictRequest`): one image as a nested list or base64-encoded array of shape `20×20×3`, values in `[0, 255]`.

Response (`PredictResponse`):

| Field | Type | Meaning |
|---|---|---|
| `score` | float in `[0, 1]` | Model probability of "aircraft" |
| `label` | `"plane"`, `"no_plane"` or `"abstain"` | Decision after threshold and abstention margin |
| `model_version` | string | Registry version that produced the prediction |

## Errors

| Status | When |
|---|---|
| `422` | Invalid payload (wrong shape, wrong type, values out of range) |
| `503` | Model not loaded yet or registry unreachable |

## Configuration

| Variable | Default | Meaning |
|---|---|---|
| `MLFLOW_TRACKING_URI` | `http://mlflow:5000` | MLflow server |
| `MODEL_URI` | `models:/planesnet@production` | Model to serve |

See [`.env.example`](../.env.example). Never commit a real `.env`.
