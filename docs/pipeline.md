# Data and training pipeline

Status: DVC stages and parameters are **defined**; stage implementations are **planned**.

## Dataset

- Source: [PlanesNet on Kaggle](https://www.kaggle.com/datasets/rhammell/planesnet), file `planesnet.json`, placed in `data/raw/`.
- Content: 20×20 RGB chips extracted from Planet imagery over California, labeled `1` (aircraft) or `0` (no aircraft).
- Each chip carries a `scene_id` and a location. The `scene_id` is what makes a leakage-free split possible.
- Data is versioned with DVC and never committed to Git.

## Pipeline stages

Defined in [`dvc.yaml`](../dvc.yaml). Run everything with `dvc repro` (or `make repro`).

| Stage | Script | Inputs | Outputs |
|---|---|---|---|
| `prepare` | `scripts/prepare.py` | `data/raw/planesnet.json`, `params.data` | `data/processed/images.npy`, `data/processed/manifest.csv` |
| `split` | `scripts/split.py` | manifest, `params.seed`, `params.split` | `data/processed/splits/` (train/val/test indices) |
| `train` | `scripts/train.py` | images, splits, `params.train` | `artifacts/model.pt`, `artifacts/train_metrics.json`, MLflow run |
| `evaluate` | `scripts/evaluate.py` | model, `params.evaluate` | `artifacts/test_metrics.json`, ROC/PR/confusion plots |
| `register` | `scripts/register.py` | model, test metrics, `params.register` | model version in the MLflow registry |

### The manifest

`manifest.csv` has one row per chip: `chip_id`, `scene_id`, `label`, `location`. It is the single source of truth for every split.

### Split protocols

`params.split.protocol` selects the protocol:

- `scene` (default): `StratifiedGroupKFold` grouped by `scene_id`. No scene appears in two splits. Enforced by `tests/test_split_leakage.py`.
- `random`: `StratifiedShuffleSplit`, the original university protocol, kept only to measure the leakage effect.

Compare both with:

```bash
make compare     # dvc exp run -S split.protocol=random / scene, then dvc exp show
```

The resulting gap is reported in [METRICS.md](../METRICS.md).

### Threshold and abstention

The decision threshold maximizes `params.evaluate.threshold_metric` (F1 by default) **on the validation split only**. Scores within `abstention_margin` of the threshold are returned as "abstain" by the API.

### Promotion

`register` promotes a model only if `average_precision >= min_average_precision` and `recall >= min_recall`. Moving the `@production` alias remains a manual decision.

## Parameters

All experiment parameters live in [`params.yaml`](../params.yaml). An experiment is always run with `dvc exp run -S key=value`, never with ad hoc command-line flags, so that every result can be reproduced.

| Key | Meaning |
|---|---|
| `seed` | Global random seed |
| `data.*` | Source path, image size, channels |
| `split.protocol`, `n_folds`, `test_size`, `val_size` | Split configuration |
| `train.*` | Architecture, epochs, batch size, learning rate, weight decay, AMP, early stopping |
| `evaluate.threshold_metric`, `abstention_margin` | Threshold selection |
| `register.min_average_precision`, `min_recall` | Promotion gates |
