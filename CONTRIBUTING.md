# Contributing to PlanesNet MLOps

Thanks for your interest in this project. Contributions of all sizes are welcome: bug reports, documentation fixes, tests, and code.

By participating, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Scope

This project is about the **pipeline**, not the model score. The model (fine-tuned ResNet18) is intentionally frozen. Pull requests that only aim to improve accuracy are out of scope. Good contributions improve reproducibility, data-leakage protection, serving, CI/CD, monitoring, or documentation. See the [technical documentation](docs/) for the design decisions.

## The workflow in one line

**Issue → branch → commits → pull request (`Closes #N`) → CI → review → squash merge.**

No change reaches `main` without an issue and a reviewed pull request. `main` is protected: direct pushes are blocked.

## 1. Start from an issue

Every change starts with an issue, even a small one. Use the [issue templates](.github/ISSUE_TEMPLATE):

- **Bug report**: a descriptive title, steps to reproduce, expected behavior, actual behavior.
- **Feature request**: description, motivation, expected behavior, examples.
- **Documentation**: location and what is missing or wrong.

Comment on the issue to say you are working on it, so a maintainer can assign it to you. Issues marked `good first issue` are a good place to start.

For security issues, **do not open a public issue**: follow [SECURITY.md](SECURITY.md).

## 2. Set up your fork

External contributors work from a fork:

```bash
# 1. Fork the repository on GitHub, then clone your fork
git clone <your-fork-url>
cd planesnet-mlops

# 2. Add the original project as upstream
git remote add upstream <original-repo-url>

# 3. Install the project and the pre-commit hooks
python -m venv .venv && source .venv/bin/activate
pip install -e ".[training,serving,monitoring,dev]" \
    --extra-index-url https://download.pytorch.org/whl/cpu
pre-commit install
```

`origin` is your fork (you push there). `upstream` is the original project (you fetch from there).

The dataset is not part of the repository. Download `planesnet.json` from the [PlanesNet Kaggle dataset](https://www.kaggle.com/datasets/rhammell/planesnet) into `data/raw/`, then run `make repro`.

## 3. Create a branch

Keep your `main` in sync, then branch from it:

```bash
git fetch upstream
git switch main
git merge upstream/main
git push origin main
git switch -c feature/scene-split
```

Branch names are short, lowercase, hyphenated, and say what the branch contains:

| Prefix | Use | Example |
|---|---|---|
| `feature/` | new functionality | `feature/scene-split` |
| `fix/` | bug fix | `fix/empty-manifest` |
| `docs/` | documentation only | `docs/api-reference` |
| `experiment/` | exploratory work, not meant to be merged as is | `experiment/onnx-export` |

## 4. Write the change

### Code standards

- Python 3.11+.
- **Formatting**: [Black](https://black.readthedocs.io/). **Linting**: [Ruff](https://docs.astral.sh/ruff/). **Types**: mypy. All three are configured in `pyproject.toml` and run by pre-commit and CI.
- **Package layout**: implementation lives in internal modules prefixed with `_` (e.g. `planesnet/data/_splitter.py`). The public API is exposed by each subpackage's `__init__.py`. Users import `from planesnet.data import split_by_scene`, never from a `_` module.
- Do not commit data, model weights, or secrets. Data goes through DVC, configuration through `.env` (based on `.env.example`).

### Docstrings (required)

Every public module, class, function and method has a [NumPy-style docstring](https://numpydoc.readthedocs.io/en/latest/format.html). Ruff enforces it (`D` rules, `numpy` convention).

```python
def split_by_scene(manifest: pd.DataFrame, test_size: float, seed: int) -> SplitIndices:
    """Split chips into train/val/test without sharing any scene between splits.

    Parameters
    ----------
    manifest : pandas.DataFrame
        One row per chip with at least ``scene_id`` and ``label`` columns.
    test_size : float
        Fraction of chips assigned to the test split, in ``(0, 1)``.
    seed : int
        Random seed for reproducibility.

    Returns
    -------
    SplitIndices
        Row indices of the train, validation and test splits.

    Raises
    ------
    ValueError
        If ``test_size`` is not in ``(0, 1)`` or a required column is missing.
    """
```

- Class docstrings document the constructor parameters (`Parameters`) and public attributes (`Attributes`); `__init__` is not documented separately.
- Private helpers (`_name`) need a short one-line docstring at least.

### Technical documentation

If your change modifies behavior, the public API, the pipeline or the deployment, update the matching page in [`docs/`](docs/) in the same pull request.

### Tests

- Tests use `pytest` and live in `tests/`, in files named `test_*.py`.
- Cover **normal cases**, **edge cases** (empty input, boundaries, single class, single scene) and **expected exceptions** (`pytest.raises`).
- Use `@pytest.mark.parametrize` instead of copying the same test.
- **Every bug fix comes with a regression test** that fails before the fix and passes after.
- Check coverage with `make test` and look at the missing lines. Coverage is a guide, not a target: a meaningful assertion beats a covered line.
- Any change to data splitting must keep `tests/test_split_leakage.py` green: no `scene_id` may appear in more than one split.

### Methodology rules

- Experiments go through `params.yaml` and `dvc exp run -S key=value`, never through ad hoc CLI flags.
- The decision threshold is chosen on the validation set, never on the test set.
- A value in `METRICS.md` is only added when it was measured, with its date and protocol.

## 5. Commit

Use [Conventional Commits](https://www.conventionalcommits.org/), in English, in the imperative mood:

```
<type>(<optional scope>): <short summary, 72 characters max>

<optional body: why the change was needed>
```

Types: `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `build`, `ci`, `chore`.
Scopes: `data`, `split`, `train`, `eval`, `registry`, `api`, `docker`, `k8s`, `ci`, `monitoring`, `docs`.

Good: `feat(split): add StratifiedGroupKFold on scene_id`, `fix(api): reject images with wrong shape`.
Bad: `update`, `fix`, `changes`, `final version`.

One commit is one logical change. Stage only the related files (`git add <files>`), not everything.

pre-commit runs Black and Ruff on every commit. If a hook modifies a file, review the change, `git add` it again and commit again.

## 6. Open a pull request

```bash
git push -u origin feature/scene-split
```

Then open a pull request from your branch to `main` and fill in the [template](.github/PULL_REQUEST_TEMPLATE.md):

- a clear title (Conventional Commits format, it becomes the squash commit message);
- **`Closes #N`** referencing the issue. **CI rejects a pull request without a linked issue**;
- what changed, why, and notes for reviewers.

### CI

On every pull request, GitHub Actions runs:

1. the issue-link check;
2. pre-commit (Black, Ruff, file checks);
3. mypy and the test suite with coverage on **Ubuntu and macOS**, with **Python 3.11 and 3.12**;
4. a short smoke training run.

All checks must pass before merging. If a job fails, open it, read the failed step's log, reproduce locally (`make check`), fix, and push again: the pull request updates automatically.

### Review

At least one maintainer approval is required. Reviewers comment, approve, or request changes. Answer every comment, push new commits to the same branch, and do not open a new pull request for the same change.

### Merge

Maintainers merge with **Squash and Merge**: one pull request becomes one commit on `main`. The branch is then deleted (`git push origin --delete <branch>`).

## Releases (maintainers)

The project follows [Semantic Versioning](https://semver.org/) (`MAJOR.MINOR.PATCH`):

- **PATCH**: backward-compatible bug fix;
- **MINOR**: new backward-compatible functionality;
- **MAJOR**: breaking change of the public API.

Release steps:

1. Update `__version__` in `src/planesnet/__init__.py` (single source of the version).
2. Move the `[Unreleased]` section of `CHANGELOG.md` under the new version and date.
3. Merge these changes through a pull request.
4. Tag the release commit and push the tag: `git tag -a v0.2.0 -m "v0.2.0"` then `git push origin v0.2.0`.
5. Create a GitHub Release from the tag, with the changelog section as release notes.
6. The [release workflow](.github/workflows/release.yml) checks that the tag matches the version, builds the wheel and sdist, tests the wheel, and publishes to PyPI through Trusted Publishing.

A public function is never removed directly: it is first deprecated (it keeps working, emits a `DeprecationWarning`, and the docstring names the replacement), then removed in the next major version.

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
