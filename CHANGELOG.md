# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Project configuration: DVC pipeline definition (prepare, split, train, evaluate, register), `params.yaml`, Dockerfile, docker-compose, Kubernetes manifests, Prometheus rules.
- Open source governance: MIT license, contributing guide, code of conduct, security policy, issue templates (bug, feature, documentation) and pull request template.
- Quality tooling: pre-commit (Black, Ruff with NumPy docstring rules), coverage configuration, Makefile targets `hooks`, `format`, `check`, `package`.
- CI workflow: mandatory issue link on pull requests, pre-commit checks, tests on Ubuntu and macOS with Python 3.11 and 3.12, smoke training run.
- Release workflow: build, wheel smoke test and PyPI Trusted Publishing on GitHub Release.
- Technical documentation in `docs/`.
