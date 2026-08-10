# Projet 1 — PlanesNet en pipeline MLOps complet

> Conception détaillée : [CONCEPTION.md](CONCEPTION.md). Démarrage après le 5 octobre 2026 — [05-actadoc](../05-actadoc/) est prioritaire d'ici là.

**Objectif :** transformer le projet universitaire PlanesNet en un système ML déployé et opéré en production.

**Ce que ça prouve :** capacité à déployer, versionner et surveiller un modèle en production — le tier *ingénieur*, défendable face à l'automatisation.

**Angle différenciant :** imagerie satellite → aéronautique / spatial / défense.

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

**Priorité : absolue (à réaliser en premier).**
