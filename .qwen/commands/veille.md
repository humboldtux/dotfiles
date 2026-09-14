---
description: Veille — analyse une URL (blog, projet GitHub, newsletter…) et suit les constats pertinents en issues GitLab du projet courant
---

# Veille sur {{args}}

## 1. Lecture de la page

- `web_fetch` sur `{{args}}` (format auto, prompt en français, extraire : ce que c'est, stack, licence, activité, fonctionnalités).
- Si `{{args}}` est un projet GitHub : récupérer aussi le `README.md` (raw) et l'activité du repo (dernier commit, stars, issues ouvertes).
- Au plus 2 pages supplémentaires si la première renvoie vers des sous-pages indispensables (docs, changelog, SECURITY.md).

## 2. Croiser avec le projet courant

1. Identifier le projet courant : `QWEN.md` / `README.md` du dossier courant + `git log -n 5`.
2. Identifier le GitLab associé : `git remote get-url origin`.
   - La remote pointe vers l'instance GitLab (ex. `iut-git.unice.fr`) → en extraire le projet `namespace/projet`.
   - Pas de remote git, autre instance, ou pas de repo git → **pas de création d'issue** : rapport d'analyse seulement.
3. Conventions issues du projet : `mcp__gitlab__list_issues` (scope=all, état opened, ~10) + `QWEN.md` — repérer le format titre/corps et les labels en usage.
4. Verdict : qu'est-ce qui est **actionnable ou utile pour ce projet** ? (fiche technique, sécurité, upgrade, outil compatible avec la stack, processus à adopter).
   - Rien d'intéressant → conclusion courte, pas de question, pas d'issue.

## 3. Décision — toujours via `ask_user_question`

Avant toute action GitLab, clore le tour avec `ask_user_question` (1 question : « Que faire de <nom> ? ») :

- « Suivre en issue » (recommandé si constat actionnable)
- « Mettre à jour l'issue existante #N » (si l'étape 2 a trouvé une issue ouverte qui couvre le sujet)
- « Sans suivi » (analyse seulement)
- « Exclu » (si un issue de veille existe déjà pour cet outil → la fermer comme trace de l'analyse, sinon rien)

**Jamais de création/mise à jour d'issue avant le verdict.**

## 4. Créer / mettre à jour l'issue (uniquement si le verdict le justifie)

- Suivre les conventions du projet détectées à l'étape 2. À défaut de convention :
  - Titre : `Veille : <nom> — <description en 1 ligne>` (cible(s) concernée(s) en préfixe `[CIBLE]` si le projet le fait).
  - Corps : ligne `**Cibles** : …` + `**Source** : <url>` + sections **Ce que c'est** / **Où ça colle pour le projet** / **Limites** / **Décision (<date>)** avec le choix de Benoit.
- Labels `criticite:*` s'ils existent dans le projet (défaut `criticite:basse`, plus élevé si le constat est sérieux).
- Issue existante qui couvre le sujet → la **mettre à jour** (section ou note), pas de doublon.
- Remonter le lien GitLab dans la réponse finale.

## 5. Mémoire (si applicable)

Si le projet tient des mémoires de veille (index `MEMORY.md` + un fichier par outil), enregistrer/mettre à jour la fiche : nom, date, décision, n° d'issue + ligne d'index.

## Règles

- Lecture seule avant la décision : `web_fetch`, `git remote`, `git log`, `mcp__gitlab__list_issues` uniquement — aucune écriture.
- GitLab MCP indisponible → présenter l'analyse complète + le contenu d'issue prêt à coller.
- Rapport final concis : ce que c'est, ce que ça change pour le projet courant, décision, lien(s) d'issue.
