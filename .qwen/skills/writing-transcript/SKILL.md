---
name: writing-transcript
description: À partir d'une vidéo YouTube (URL ou ID), produit un transcript complet en français avec horodatages, plus un résumé structuré orienté auteur : livres, auteurs, ressources et références citées, citations marquantes, conseils et principes, techniques d'écriture (craft), exercices. À utiliser systématiquement quand l'utilisateur fournit une URL ou vidéo YouTube et veut un transcript en français, un résumé d'un cours, conférence ou atelier d'écriture, ou l'extraction de ressources, citations, conseils et techniques pour son travail d'auteur — même s'il ne dit pas explicitement « transcript » ou « résumé ». S'appuie sur le skill baoyu-youtube-transcript pour le téléchargement ; si l'utilisateur veut seulement le sous-titre brut sans résumé, c'est baoyu-youtube-transcript qui suffit. Avant tout traitement, vérifie si la vidéo est déjà dans la hiérarchie Notion de l'utilisateur : si elle y est complète, la commande s'arrête ; sinon, publie le résultat dans Notion (Transcripts / Chaîne / Vidéo, sous-pages Transcript et Résumé).
---

# Writing Transcript

À partir d'une vidéo YouTube, produit deux livrables côte à côte dans le cache du skill `baoyu-youtube-transcript` (dossier `youtube-transcript/` du projet courant) :

1. **`transcript.md`** — le transcript complet **en français**, paragraphes horodatés.
2. **`resume.md`** — un résumé dense « pour un auteur » : ressources et références, citations, conseils, techniques d'écriture, exercices, points de vue.

Puis le tout est publié dans la hiérarchie Notion de l'utilisateur (étape 4), après vérification de doublon (étape 0).

## Prérequis

- Le skill `baoyu-youtube-transcript` (source : `jimliu/baoyu-skills`). `{baoyuDir}` = `{baseDir}/../baoyu-youtube-transcript` (dossier voisin, soit `~/.qwen/skills/baoyu-youtube-transcript` quand ce skill est installé au niveau utilisateur). Le critère d'installation : `{baoyuDir}/scripts/main.ts` existe.
- S'il n'est pas au dossier voisin, d'abord vérifier si une copie existe déjà ailleurs sur la machine (ex. `~/.agents/skills/baoyu-youtube-transcript`) et, dans ce cas, l'utiliser comme `{baoyuDir}`. Sinon, l'installer soi-même au niveau utilisateur global avant de poursuivre — sans demander à l'utilisateur : l'installation est déterministe et son résultat vérifiable au fichier `scripts/main.ts`.
  ```bash
  npx -y skills add jimliu/baoyu-skills --skill baoyu-youtube-transcript --agent qwen-code -g -y
  ```
  Le CLI `skills` copie le skill dans `~/.qwen/skills/baoyu-youtube-transcript`, exactement le dossier voisin visé ci-dessus. Si le CLI échoue (réseau, npm), repli manuel :
  ```bash
  git clone --depth 1 https://github.com/jimliu/baoyu-skills /tmp/baoyu-skills \
    && cp -r /tmp/baoyu-skills/skills/baoyu-youtube-transcript ~/.qwen/skills/ \
    && rm -rf /tmp/baoyu-skills
  ```
  puis re-vérifier la présence de `scripts/main.ts`.
- Runtime : `bun` installé → `${BUN_X}` = `bun` ; sinon `npx` disponible → `${BUN_X}` = `npx -y bun` ; sinon installer bun.
- Script : `${BUN_X} {baoyuDir}/scripts/main.ts <url-or-id> [options]`

## Workflow

### 0. État initial — vérifier avant de tout faire

Dès la réception de l'URL/ID de la vidéo, avant tout téléchargement :

1. **Notion — la vidéo y est-elle déjà ?** Extraire l'ID vidéo (segment `v=` de l'URL, ou ID brut donné) et le chercher dans Notion. Les outils Notion MCP sont différés : les charger d'abord via `tool_search` (ex. `select:mcp__notion__notion-ai-search,mcp__notion__notion-fetch`). Utiliser `notion-ai-search` si `notion-get-tool-access` le signale disponible, sinon `notion-search` ; en l'absence de résultat fiable, chercher le titre exact de la vidéo. Un résultat ne compte comme « déjà faite » que s'il s'agit de la page de cette vidéo dans la hiérarchie (elle contient le lien exact `https://www.youtube.com/watch?v={id}`) — pas une simple mention de l'ID ailleurs.
   - **Page vidéo + sous-pages Transcript et Résumé présentes** → **arrêter la commande** : dire à l'utilisateur que la vidéo est déjà dans Notion et lui renvoyer le lien de la page vidéo.
   - **Page vidéo présente, sous-page(s) manquante(s)** → compléter : réutiliser le livrable local s'il existe (point 2), sinon le produire (étapes 1-3), puis créer **uniquement** les sous-pages manquantes (étape 4).
   - **Vidéo absente de Notion** → point 2.
2. **Cache local** : si `transcript.md` et `resume.md` existent déjà dans le dossier de la vidéo (cache baoyu), ne rien re-télécharger ni réécrire — passer directement à l'étape 4.

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

### 4. Import Notion (systématique)

Créer — ou compléter si des pages existent déjà — la hiérarchie suivante dans l'espace Notion de l'utilisateur :

```
Perso / Writing / Transcripts (📝)
└── {Chaîne YouTube} (✍️)
    └── {Titre de la vidéo} (🎥)
        ├── Transcript (📄)
        └── Résumé (📋)
```

**Ancrage** : la page `Writing` = https://app.notion.com/p/982ce841bc1b4434bf28419fb073f4d9 (chemin `Perso / Writing`). Ne jamais dupliquer : chercher d'abord `Transcripts` sous `Writing` (fetch), puis la page chaîne sous `Transcripts` (fetch ou recherche) ; ne créer que ce qui manque. La page chaîne porte le nom de la chaîne YouTube (`meta.json`), icône ✍️.

**Page vidéo** (🎥, sous la page chaîne) :
- En tête, la couverture `imgs/cover.jpg` du cache si présente : `notion-create-file-upload` (filename `cover.jpg`) → POST multipart avec le champ `file` vers `upload_url` (en joignant les `upload_headers` retournés) → insérer le `suggested_markdown` de la réponse en tête de page (`notion-update-page`, `insert_content`, position `start`).
- Callout 🎬 : `Vidéo YouTube : [watch?v={id}](https://www.youtube.com/watch?v={id})`.
- Puces de métadonnées : **Chaîne** (podcast si identifiable), **Invité(e)** si interview, **Date de publication**, **Durée** (+ chapitres), **Langue originale** (noter la traduction française en cas B), **Sponsor** si identifiable.
- Une citation courte et représentative (bloc de citation), si pertinente.

**Sous-pages** `Transcript` (📄) et `Résumé` (📋) : le contenu **intégral** de `transcript.md` et `resume.md`.

**Mécanique** : `notion-create-pages` en `allow_async: false`, appels **séquentiels** — une seule création regroupe toujours des pages de même parent, et chaque niveau a besoin de l'ID du niveau supérieur. Ne créer que les pages effectivement manquantes.

**Conversions Markdown → Notion** (appliquer à tout contenu envoyé) :
- Format de référence : la ressource `notion://docs/enhanced-markdown-spec` (à lire en cas de doute).
- Échapper les caractères littéraux : `[` → `\[`, `]` → `\]`, `$` → `\$`, `>` → `\>` (les marqueurs de parole `>>` deviennent donc `\>\>`).
- Les `> ` en début de ligne restent des blocs de citation (les citations du résumé).
- Gras-italique imbriqué : écrire `***Titre***` — jamais `**Titre *italique***`, que Notion rend avec des astérisques littéraux.
- Supprimer le frontmatter YAML et le H1 (le titre de page remplace le H1) ; aucune image à chemin local (l'importer, pas la copier).

**Vérification** : après création, fetch de chaque page — sections et sous-pages présentes, horodatages et marqueurs `>>` intacts (les compter), aucun astérisque littéral résiduel, parent correct dans l'`<ancestor-path>`.

### 5. Signaler au user

Chemins des deux fichiers, titre et chaîne de la vidéo, langue(s) utilisée(s), 2-3 éléments marquants du résumé (une ressource, une citation, un conseil), et les liens des pages Notion (existantes ou créées) : page vidéo + sous-pages.

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
