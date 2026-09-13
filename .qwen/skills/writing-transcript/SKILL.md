---
name: writing-transcript
description: À partir d'une vidéo YouTube (URL ou ID), produit un transcript complet en français avec horodatages, plus un résumé structuré orienté auteur : livres, auteurs, ressources et références citées, citations marquantes, conseils et principes, techniques d'écriture (craft), exercices. À utiliser systématiquement quand l'utilisateur fournit une URL ou vidéo YouTube et veut un transcript en français, un résumé d'un cours, conférence ou atelier d'écriture, ou l'extraction de ressources, citations, conseils et techniques pour son travail d'auteur — même s'il ne dit pas explicitement « transcript » ou « résumé ». S'appuie sur le skill baoyu-youtube-transcript pour le téléchargement ; si l'utilisateur veut seulement le sous-titre brut sans résumé, c'est baoyu-youtube-transcript qui suffit.
---

# Writing Transcript

À partir d'une vidéo YouTube, produit deux livrables côte à côte dans le cache du skill `baoyu-youtube-transcript` (dossier `youtube-transcript/` du projet courant) :

1. **`transcript.md`** — le transcript complet **en français**, paragraphes horodatés.
2. **`resume.md`** — un résumé dense « pour un auteur » : ressources et références, citations, conseils, techniques d'écriture, exercices, points de vue.

## Prérequis

- Le skill `baoyu-youtube-transcript` doit être installé. `{baoyuDir}` = `{baseDir}/../baoyu-youtube-transcript` (dossier voisin). S'il n'y est pas, chercher le skill ailleurs sur la machine, et en dernier recours demander son chemin à l'utilisateur.
- Runtime : `bun` installé → `${BUN_X}` = `bun` ; sinon `npx` disponible → `${BUN_X}` = `npx -y bun` ; sinon installer bun.
- Script : `${BUN_X} {baoyuDir}/scripts/main.ts <url-or-id> [options]`

## Workflow

### 1. Langues disponibles

```bash
${BUN_X} {baoyuDir}/scripts/main.ts '<url>' --list
```

Toujours mettre l'URL entre guillemets simples (`?` est interprété comme joker par le shell). Retenir : `fr` est-il disponible ? Sinon, quelle langue d'origine (généralement `en`) ?

### 2. Télécharger le(s) transcript(s)

Le script affiche le chemin du fichier produit à chaque exécution — s'en servir plutôt que de reconstruire le chemin à la main.

**Cas A — `fr` disponible (vidéo nativement française)** : une seule passe.

```bash
${BUN_X} {baoyuDir}/scripts/main.ts '<url>' --languages fr --chapters
```

Le fichier produit (`transcript.md`) est déjà en français : il sert à la fois de livrable et de source du résumé.

**Cas B — pas de `fr` (vidéo en anglais ou autre)** : deux passes, une par langue. Le cache de baoyu ne stocke qu'une seule langue à la fois, donc chaque langue demandée déclenche un re-téléchargement ; c'est normal.

```bash
# Passe 1 : langue d'origine (ex. en), sortie par défaut → transcript.md
${BUN_X} {baoyuDir}/scripts/main.ts '<url>' --languages en --chapters

# Renommer la sortie de la passe 1 pour la conserver
mv '<chemin-affiché>/transcript.md' '<chemin-affiché>/transcript-original.md'

# Passe 2 : traduction française (machine translation de YouTube) → transcript.md
${BUN_X} {baoyuDir}/scripts/main.ts '<url>' --translate fr --chapters
```

Pourquoi deux passes : `transcript.md` est le livrable français (traduction automatique de YouTube, gratuite et immédiate), tandis que `transcript-original.md` conserve le texte source. Le résumé sera écrit d'après l'**original** — c'est là que la nuance d'un cours d'écriture est la plus fidèle — et les citations resteront verbatim dans la langue de la vidéo. Si `--translate fr` échoue (transcript non translatable), dire à l'utilisateur que la traduction française devra être faite par l'IA par blocs (plus long, plus coûteux) et ne continuer qu'avec son accord.

**Plusieurs vidéos** : en traiter une par une, séquentiellement — vérifier le résultat de chaque passe avant de passer à la suivante. Un échec partiel dans un lot est difficile à isoler, et l'utilisateur préfère voir les erreurs au fur et à mesure.

### 3. Lire et rédiger le résumé

1. Lire `meta.json` du dossier vidéo (titre, chaîne, date, durée, description, chapitres) puis le transcript. En cas B, lire **les deux** transcripts. Pour un transcript long, lire par morceaux (`read_file` avec `offset`/`limit`) : le résumé doit couvrir **toute** la vidéo, aucun passage ne doit être sauté.
2. Rédiger `resume.md` dans le même dossier que `transcript.md`, entièrement en français, selon le modèle ci-dessous.

### 4. Signaler au user

Chemins des deux fichiers, titre et chaîne de la vidéo, langue(s) utilisée(s), et 2-3 éléments marquants du résumé (une ressource, une citation, un conseil).

## Modèle de `resume.md`

```markdown
---
title: {titre de la vidéo}
channel: {chaîne}
url: {url}
date: {date de publication}
source: {chemin relatif du dossier, ex. youtube-transcript/auteur/titre-video}
---

# {titre de la vidéo} — Résumé pour l'auteur

## Vue d'ensemble
3 à 6 paragraphes : ce que la vidéo enseigne, sa structure (si chapitres), les idées portantes.

## Ressources & références
Chaque livre, film, œuvre, auteur, site, podcast, outil cité : nom complet (langue originale), auteur, en quoi il est cité dans la vidéo, [MM:SS]. Si une ressource est nommée sans être décrite, l'indiquer honnêtement (« cité sans développement »).

## Citations marquantes
> "Quote verbatim en langue originale" — *traduction française* [MM:SS]

Uniquement les phrases réellement réutilisables (percutantes, formulables) — pas un résumé déguisé en citation.

## Conseils & principes
Conseils concrets et actionnables, un par ligne, [MM:SS]. Reformulés de façon dense plutôt que paraphrasés longuement.

## Techniques d'écriture (craft)
Techniques nommées ou explicables (structure, point de vue, dialogue, révision, style, ton…) avec l'explication donnée dans la vidéo, [MM:SS].

## Exercices & pratiques
Exercices proposés ou pratiques décrites, avec leurs étapes, [MM:SS].

## Points de vue & anecdotes
Affirmations contre-intuitives, anecdotes d'auteurs, « wisdom » réutilisable — ce qui fait l'originalité de l'intervenant, [MM:SS].
```

Règles du résumé :

- Ne créer que les sections qui ont du contenu — jamais de section vide, jamais de remplissage.
- Horodater chaque entrée (temps de la vidéo) pour que l'auteur puisse y revenir.
- Rien d'inventé : le résumé est dense et factuel, chaque élément doit être traçable dans le transcript.
- Garder les titres d'œuvres, noms d'auteurs et citations verbatim dans leur langue originale ; le reste s'écrit en français.

## Erreurs

Cas d'erreurs du script (voir le SKILL.md de baoyu) : pas de sous-titres, langue indisponible, vidéo supprimée/privée/region-locked, IP bloquée, age-restricted. En cas de blocage anti-bot, le script retente avec d'autres clients puis bascule sur `yt-dlp` ; si cet outil manque, le rendre disponible (l'installer) plutôt que de demander à l'utilisateur quoi faire.
