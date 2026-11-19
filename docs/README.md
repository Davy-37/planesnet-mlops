# Technical documentation

This folder documents how PlanesNet MLOps is built and operated. It is written for contributors and maintainers. For a quick introduction, start with the [project README](../README.md); for the contribution process, see [CONTRIBUTING.md](../CONTRIBUTING.md).

| Page | Content |
|---|---|
| [architecture.md](architecture.md) | Components, data flow, repository layout, key design decisions |
| [pipeline.md](pipeline.md) | Dataset, scene-based split, DVC stages, `params.yaml` |
| [python-api.md](python-api.md) | Public Python API of the `planesnet` package |
| [http-api.md](http-api.md) | REST endpoints of the serving API |
| [operations.md](operations.md) | Deployment, model registry, monitoring, drift, rollback |
| [ci-cd.md](ci-cd.md) | Pre-commit, CI, release and deployment workflows |

## Status convention

The project is under active development. Each page marks what exists:

- **Implemented**: present in the code and covered by tests.
- **Planned**: designed and documented, not implemented yet.

When a pull request implements a planned item, it updates the status in the same pull request.

## Keeping the documentation in sync

- API reference content comes from the NumPy-style docstrings in the code; the pages here describe the structure and link to modules.
- A pull request that changes behavior, the public API, the pipeline or the deployment updates the matching page.
- Measured numbers go to [METRICS.md](../METRICS.md), known limits to [LIMITATIONS.md](../LIMITATIONS.md). These pages do not duplicate them.
