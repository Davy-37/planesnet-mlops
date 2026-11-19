# CI/CD

## Local checks: pre-commit

Configured in [`.pre-commit-config.yaml`](../.pre-commit-config.yaml), installed once with `pre-commit install` (or `make hooks`). On every commit it runs:

- file hygiene: trailing whitespace, end of file, YAML/TOML syntax, large files, merge conflicts, private keys;
- **Black** (formatting);
- **Ruff** (linting, imports, NumPy docstring rules), with safe automatic fixes.

Run on the whole repository with `pre-commit run --all-files`. `make check` runs exactly what CI runs.

## Continuous integration: `ci.yaml`

Triggered on pull requests to `main` and on pushes to `main`.

| Job | What it does |
|---|---|
| `issue-link` | Fails if the PR description has no closing keyword (`Closes #N`, `Fixes #N`, `Resolves #N`) |
| `quality` | Runs all pre-commit hooks |
| `tests` | mypy + pytest with branch coverage, matrix **Ubuntu / macOS × Python 3.11 / 3.12** (4 jobs) |
| `smoke-train` | `dvc repro --dry` and a one-epoch training run on 500 chips |

## Release: `release.yml`

Triggered when a GitHub Release is published.

1. Checks that the tag (`vX.Y.Z`) matches `planesnet.__version__`.
2. Builds the wheel and sdist with `python -m build`.
3. Installs the wheel in a clean virtual environment and imports it.
4. Publishes to PyPI with **Trusted Publishing** (`id-token: write`, environment `pypi`). No PyPI token is stored in GitHub.

PyPI setup (once): add a trusted publisher (pending publisher for the first release) with the repository, the workflow file name `release.yml` and the environment name `pypi`.

## Deployment: `cd.yaml`

Triggered by a `v*` tag or manually. Builds the Docker image, pushes it to GitHub Container Registry, and updates the Kubernetes deployment through the `production` environment (kubeconfig stored as a secret).

## Repository settings (maintainers)

- Branch protection on `main`: pull request required, 1 approval, required status checks (`issue-link`, `quality`, the 4 `tests` jobs), no direct push.
- Merge method: **squash merge** only; delete branches after merge.
- Labels: `bug`, `enhancement`, `documentation`, `good first issue`, `help wanted`.
- Milestones group issues by release (e.g. `v0.2.0`).
