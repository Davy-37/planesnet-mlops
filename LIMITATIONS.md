# Limites connues

Document public. Une faiblesse annoncée par l'auteur vaut mieux que la même faiblesse découverte par un recruteur.

## Par conception

- Le protocole universitaire d'origine découpait les données sans tenir compte des `scene_ids` : les vignettes d'une même scène satellite pouvaient se retrouver en entraînement et en test. Les résultats initiaux (98,2 % / AUC 0,998) sont invalidés. Le protocole corrigé et l'écart mesuré sont dans [METRICS.md](METRICS.md).
- Vignettes 20×20 pixels, deux classes, un seul capteur (Planet, Californie). Aucune conclusion transférable à d'autres résolutions ou zones géographiques.
- Modèle volontairement figé : le projet optimise le pipeline, pas la performance.
- Déploiement sur une VM unique avec k3s. Aucune mesure sous charge réelle.

## Non testé

_(à remplir)_

## Simplifications assumées

_(à remplir)_
