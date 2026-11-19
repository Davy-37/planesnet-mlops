## Linked issue

<!-- Required. Every pull request must close an issue. CI fails without it. -->
Closes #

## Summary

<!-- What does this PR change, and why? -->

## Type of change

- [ ] Bug fix (`fix/...`)
- [ ] New feature (`feature/...`)
- [ ] Documentation (`docs/...`)
- [ ] Refactoring / tests / CI

## Notes for reviewers

<!-- Design choices, open questions, what to look at first. -->

## Checklist

- [ ] The branch name follows `feature/`, `fix/`, `docs/` or `experiment/`
- [ ] `pre-commit run --all-files` passes (Black, Ruff)
- [ ] `make test` passes
- [ ] Tests added or updated (normal cases, edge cases, expected exceptions)
- [ ] A bug fix comes with a regression test
- [ ] Public functions and classes have NumPy-style docstrings
- [ ] Technical documentation in `docs/` updated if behavior or API changed
- [ ] `CHANGELOG.md` updated under `[Unreleased]`
- [ ] `tests/test_split_leakage.py` still passes (no `scene_id` shared across splits)
- [ ] No data, model weights, or secrets committed
