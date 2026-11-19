# Python API

Status: **planned**. The package code will be rewritten following the contribution rules. Signatures below are the target interface and may change before `1.0.0`.

The authoritative reference is the NumPy-style docstring of each public object (`help(planesnet.data.split_by_scene)`). This page gives the overview.

## Conventions

- Import from subpackages only: `from planesnet.data import split_by_scene`.
- Modules prefixed with `_` are internal.
- Every public function documents `Parameters`, `Returns` and `Raises`.
- Version: `planesnet.__version__`.

## `planesnet.data`

| Object | Description |
|---|---|
| `load_planesnet(path)` | Read `planesnet.json`, return images as an `(N, 20, 20, 3)` array and labels |
| `build_manifest(raw)` | Return a DataFrame `chip_id, scene_id, label, location` |
| `split_by_scene(manifest, test_size, val_size, seed)` | Leakage-free train/val/test indices grouped by `scene_id` |
| `split_random(manifest, test_size, val_size, seed)` | Random stratified split, for comparison only |
| `get_transforms(train)` | Normalization, plus augmentation when `train=True` |

## `planesnet.models`

| Object | Description |
|---|---|
| `build_resnet18(pretrained)` | ResNet18 adapted to 20×20 inputs, single-logit output |
| `save_checkpoint(model, path)` / `load_checkpoint(path)` | Persist and restore weights with metadata |

## `planesnet.training`

| Object | Description |
|---|---|
| `train(params, splits)` | Training loop with early stopping, logs to MLflow |
| `evaluate(model, split)` | AP, AUC, confusion matrix, ROC and PR curves |
| `select_threshold(scores, labels, metric)` | Threshold chosen on validation data |

## `planesnet.serving`

| Object | Description |
|---|---|
| `load_production_model(uri)` | Load `models:/planesnet@production` from MLflow |
| `Predictor` | Single and batch inference, applies threshold and abstention |
| `PredictRequest`, `PredictResponse` | Pydantic schemas shared with the HTTP API |

## `planesnet.monitoring`

| Object | Description |
|---|---|
| `build_reference(images, scores)` | Reference statistics used for drift detection |
| `drift_report(reference, current)` | Evidently report on image statistics and score distribution |
