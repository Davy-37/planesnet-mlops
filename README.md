# Projet 1 — PlanesNet en pipeline MLOps complet

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Objectif :** transformer le projet universitaire PlanesNet en un système ML déployé et opéré en production.

**Contenu :** données et entraînement versionnés (DVC, MLflow), service FastAPI, déploiement Kubernetes et suivi de la dérive.

**Domaine :** imagerie satellite (aéronautique, spatial, défense).

## Stack
- **Modèle :** PyTorch (ResNet fine-tuné)
- **Serving :** FastAPI
- **Déploiement :** Docker + Kubernetes
- **Tracking & registry :** MLflow
- **Versioning des données :** DVC
- **CI/CD :** GitHub Actions
- **Monitoring & drift :** Evidently + Prometheus / Grafana
- **Cloud :** AWS ou GCP

## Livrables
- Repo GitHub propre + README détaillé
- Démo déployée avec URL publique
- Schéma d'architecture


## Documentation

La documentation technique (architecture, pipeline, API, exploitation, CI/CD) est dans [docs/](docs/).

## Contribuer

Les contributions sont les bienvenues : voir [CONTRIBUTING.md](CONTRIBUTING.md), le [code de conduite](CODE_OF_CONDUCT.md) et la [politique de sécurité](SECURITY.md). L'historique des versions est dans [CHANGELOG.md](CHANGELOG.md).

## Licence

Distribué sous licence [MIT](LICENSE).
