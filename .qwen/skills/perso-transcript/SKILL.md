---
name: perso-transcript
description: À partir d'une URL — vidéo YouTube (tout sujet : écriture, DevOps, veille info, conférence, cours) ou page web (blog, projet GitHub, newsletter, docs) —, produit une synthèse française : transcript complet horodaté + résumé structuré (vidéo), ou analyse de veille avec constats actionnables (page web). Puis l'utilisateur choisit le routage de la sortie à chaque URL : Notion, issues GitLab granulaires (projet du dossier courant ou projet donné), les deux ou rien. À utiliser systématiquement quand l'utilisateur fournit une URL/vidéo YouTube et veut un transcript en français, un résumé, ou une veille vidéo — même sans dire explicitement « transcript » ou « résumé » — et pour toute veille web qui produirait des constats actionnables. Pour le sous-titre YouTube brut sans résumé, c'est baoyu-youtube-transcript qui suffit. Absorbe l'ancienne commande /perso-veille (supprimée le 2026-09-21) et remplace le skill writing-transcript (renommé).
---

# Perso Transcript

Outil unique de synthèse et de veille sur URL. Deux branches selon l'URL :

- **Vidéo YouTube** → `transcript.md` (français, paragraphes horodatés) + `resume.md` (résumé dense, structure unique générique), dans le cache du skill `baoyu-youtube-transcript` (dossier `youtube-transcript/` du projet courant).
- **Page web** (blog, projet GitHub, newsletter, docs…) → `veille.md` (analyse de veille : ce que c'est, constats, ce qui est actionnable pour le projet courant).

Dans les deux cas, une fois le livrable produit et vérifié en local, le **routage de la sortie est demandé à l'utilisateur** (étape commune de routage) : **Notion**, **issues GitLab**, **les deux**, ou **rien**. Ne jamais écrire vers Notion ou GitLab avant ce verdict.

## 0. Identifier la branche

- URL contient `youtube.com/watch`, `youtu.be/`, `youtube.com/shorts` → **branche vidéo**.
- Sinon (http/https classique) → **branche web**.
- ID YouTube brut (11 caractères) → branche vidéo.

## Branche vidéo

### Prérequis

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

### V1. Langues disponibles

```bash
${BUN_X} {baoyuDir}/scripts/main.ts '<url>' --list
```

Toujours mettre l'URL entre guillemets simples (`?` est interprété comme joker par le shell). Retenir : `fr` est-il disponible ? Sinon, quelle langue d'origine (généralement `en`) ?

### V2. Télécharger le(s) transcript(s)

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

Pourquoi deux passes : `transcript.md` est le livrable français (traduction automatique de YouTube, gratuite et immédiate), tandis que `transcript-original.md` conserve le texte source. Le résumé est écrit d'après **l'original** — c'est là que la nuance est la plus fidèle — et les citations restent verbatim dans la langue de la vidéo. Si `--translate fr` échoue (transcript non translatable, HTTP 429 rate-limit…), **passer automatiquement à la traduction IA** — sans demander l'accord à l'utilisateur (instruction de Benoit du 2026-09-19) : traduire `transcript-original.md` en français, par blocs successifs, en écrivant le résultat dans `transcript.md` au format exact du transcript baoyu (frontmatter, `## Sommaire` avec chapitres horodatés, paragraphes `[MM:SS → MM:SS]`, marqueurs de locuteur `>>`), en conservant noms, titres et termes techniques en langue originale. Sur les pages/issue de destination, indiquer « traduction française par IA » à la place de « traduction automatique YouTube ».

#### Traduction IA — règles d'intégrité (bloc par bloc)

Appris sur la vidéo freeCodeCamp de 10 h 30 (2026-09-21) — sans ces règles, la dérive est quasi certaine au-delà de ~50 paragraphes :

1. **Horodatages copiés, jamais régénérés.** La consigne d'agent doit l'écrire explicitement : « copie chaque `[hh:mm:ss → hh:mm:ss]` caractère pour caractère depuis la source ; ne déduis jamais l'heure ». Les agents inventent des valeurs plausibles mais absentes de la source.
2. **Borne dure par appel d'agent** : ≤ ~250 paragraphes / ~600 lignes de source. Split proactif (pas « un chapitre » pour une vidéo sans chapitres). Au-delà : contexte qui déborde + dérive des horodatages.
3. **Diff TS obligatoire après chaque bloc** : extraire les listes d'horodatages source et traduction (ex. `grep -oE '\[[0-9:]+ → [0-9:]+\]'`), `diff` — identité requise (TS_OK). Un seul écart = bloc à rejeter.
4. **En cas de dérive** : ne pas re-traduire tout le bloc — tronquer le fichier de sortie au dernier timestamp fiable (vérifié présent dans la source) et relancer l'agent sur la partie restante.
5. **Registre imposé dans le prompt de traduction** (prévention) : « vouvoiement » ou « tutoiement » selon la nature de la vidéo, dès le premier prompt. **Jamais de normalisation post-hoc par regex** (casse les conjugaisons `-ez`, les impératifs, « je te l'ai dit ») : si le registre est mélangé (agents parallèles), déléguer à un agent de correction avec liste de substitutions ordonnées + relecture intégrale du diff avant/après.
6. **Agents parallèles** = OK pour la vitesse, mais vérification d'homogénéité obligatoire à l'assemblage (registre, format, TS) — les agents indépendants divergent.

### V2b. Assainissement du transcript EN (avant / sous la traduction)

Assainir `transcript-original.md` (EN) avant de traduire ; les corrections se propagent au FR.

**1. Reconstruction depuis les segments bruts (si baoyu a produit un output dégradé)**

Après la passe 1, sanity-check le transcript : nombre de paragraphes `[hh:mm:ss → hh:mm:ss]` vs nombre de chapitres, longueur des paragraphes, chapitres vides. Si l'output est **dégradé** — 2-3 blocs géants au lieu de dizaines de paragraphes, ou des chapitres vides — c'est le bug de baoyu `segmentIntoSentences` : les captions auto **sans ponctuation** `.?!…` font couler tout le texte en 1-2 phrases (le split se fait sur la ponctuation, pas sur le temps). Reconstruire depuis `transcript-raw.json` (segments bruts `text`/`start`/`duration`) :
- Filtrer les snippets vides / `[[…]]` / `[Applaussement]` / `[Musique]` / `[Voix off]`.
- Regrouper en paragraphes : couper sur **gap > 2 s** OU **longueur ≥ ~300 caractères** (les deux conditions).
- `[hh:mm:ss → hh:mm:ss]` = start du premier snippet → end du dernier snippet du paragraphe.
- Chaque paragraphe → son chapitre (dernier chapitre `c` tel que `c.start ≤ start < c.end`).
- Sortir le markdown baoyu standard (frontmatter, H1, description, sommaire, cover, chapitres) — **sans `>>`** (étape 3).

**2. Normalisation des noms propres / termes (liste de domaine)**

Les vidéos craft débordent de noms propres / titres / techniques que l'ASR massacre. Appliquer une **liste de correction de domaine** (nom correct ← variantes ASR observées) en post-passe sur l'EN avant traduction, et la compléter à chaque vidéo :
- *Moby-Dick* ← « Mobi dick », « M…oby Dick » (coupé entre 2 paragraphes)
- Stanislavski ← « stanislowski » · Don DeLillo ← « Don deil » · Anne Patchett ← « Anne patchet »
- *The Overstory* ← « the over story » · *Plowing in the Dark* ← « plowing in the dark » · *White Noise* ← « white noise »
- Write of Passage ← « write of passage » · writingexamples.com ← « writing exam exles »
Corriger l'EN puis laisser la traduction porter les noms corrigés ; noter encore les doutes résiduels au niveau de l'entrée.

**3. Diarisation — marqueurs `>>` (baoyu n'en génère aucun, c'est du post-processing)**

`>>` = change de locuteur, inséré **immédiatement avant** les mots du locuteur qui reprend la parole.
- **Podcast 2 voix** (hôte + invité, le format de David Perell) : hôte = questions, relances, transitions, blocs promo/sponsors ; invité = réponses, exemples, anecdotes. Un `>>` avant chaque nouvelle prise de parole.
- **1er pas du transcript sans `>>`** (le premier locuteur est implicite).
- **Plusieurs `>>` possibles dans un paragraphe** (alternance rapide).
- Diariser **une fois sur l'EN** (en lisant), puis **répliquer les mêmes positions sur le FR** après traduction. Vérifier que le **nombre total de `>>` EN == FR** (± 1 si le FR a un `>>` dans la note intro) et, en cas d'écart, faire un diff paragraphe par paragraphe pour réaligner (la traduction IA peut fusionner/scinder des prises de parole).

**Plusieurs vidéos** : en traiter une par une, séquentiellement — vérifier le résultat de chaque passe avant de passer à la suivante. Un échec partiel dans un lot est difficile à isoler, et l'utilisateur préfère voir les erreurs au fur et à mesure.

### V3. Lire et rédiger le résumé

1. Lire `meta.json` du dossier vidéo (titre, chaîne, date, durée, description, chapitres) puis le transcript. En cas B, lire **les deux** transcripts. Pour un transcript long, lire par morceaux (`read_file` avec `offset`/`limit`) : le résumé doit couvrir **toute** la vidéo, aucun passage ne doit être sauté.
2. Rédiger `resume.md` dans le même dossier que `transcript.md`, entièrement en français, selon le **modèle unique générique** ci-dessous (même structure pour toutes les vidéos, quel que soit le sujet).
3. **Vérifier le livrable local** avant le routage — checks binaires, pas à l'œil :
   - `resume.md` : toutes les sections prévues du modèle présentes et non vides, horodatages sur Points clés / Citations / Ressources / Conseils.
   - `transcript.md` : frontmatter + sommaire intacts ; **nombre de paragraphes FR == nombre de paragraphes source** ; **diff des listes d'horodatages extraits (FR vs source) = identité** ; registre cohérent (recherche des formes verbales `-ez` suspectes / mélanges tu-vous) ; nombre de `>>` FR == EN (étape V2b.3).
   - Un check qui échoue = livrable non terminé : corriger (troncature + reprise du bloc concerné), ne pas router.

## Branche web

### P1. Lecture de la page

- `web_fetch` sur l'URL (format auto, prompt en français, extraire : ce que c'est, stack, licence, activité, fonctionnalités, dates).
- Si l'URL est un projet GitHub : récupérer aussi le `README.md` (raw) et l'activité du repo (dernier commit, stars, issues ouvertes).
- Au plus 2 pages supplémentaires si la première renvoie vers des sous-pages indispensables (docs, changelog, SECURITY.md).

### P2. Croiser avec le projet courant

1. Identifier le projet courant : `QWEN.md` / `README.md` du dossier courant + `git log -n 5`.
2. Identifier le GitLab associé : `git remote get-url origin`.
   - La remote pointe vers une instance GitLab (ex. `iut-git.unice.fr`) → en extraire le projet `namespace/projet` : c'est le **projet cible par défaut** des issues. L'utilisateur peut en désigner un autre (le proposer dans la question de routage si l'URL vient d'un autre contexte que le dossier courant).
   - Pas de remote git, autre instance, ou pas de repo git → **pas de création d'issue** (l'option GitLab est écartée de la question de routage) : rapport d'analyse seulement.
3. Conventions issues du projet : `mcp__gitlab__list_issues` (scope=all, état opened, ~10) + `QW.md` — repérer le format titre/corps et les labels en usage.
4. Verdict : qu'est-ce qui est **actionnable ou utile pour ce projet** ? (fiche technique, sécurité, upgrade, outil compatible avec la stack, processus à adopter).
   - Rien d'intéressant → conclure avec un rapport d'analyse court ; **pas de question de routage, pas d'issue** — signaler simplement que la page n'offre rien d'actionnable pour le projet.

### P3. Rédiger l'analyse

Rédiger `veille.md` dans le dossier courant du projet (à la racine ou dans un sous-dossier `veille/` si le projet en a déjà un), entièrement en français, selon le modèle ci-dessous. Le livrable sert de base aux issues GitLab (1 issue / constat actionnable) et à la page Notion si choisis.

**Vérifier le livrable local** avant le routage : chaque constat est distinct, actionnable et sourcé (section de la page / URL).

**Vérifier les affirmations de comportement avant de déclarer « actionnable »** (leçon incident certbot, 2026-09-22 — une note traitée comme spec a fait écrire une erreur dans la KB) : quand un constat repose sur une **affirmation de comportement, de compatibilité ou de version** de l'outil (ex. « ce flag fait X », « compatible avec Y »), la vérifier contre la **doc officielle** et/ou le **binaire local** (`--help`/`man` — authoritatif pour la version installée) avant de le passer en issue. Noter dans le constat la version vérifiée et la date. Non vérifiable → le garder mais le placer en **Limites & réserves**, pas en Constat actionnable.

## Routage de la sortie — commun, demandé à chaque URL

Une fois le livrable produit et vérifié localement, **toujours** demander via `ask_user_question` où envoyer le résultat (choix multiples) :

- **Notion** — importe le résultat dans la hiérarchie Notion (étape R1).
- **Issues GitLab** — transforme les constats actionnables en issues granulaires du projet cible (étape R2).
- **Les deux**.
- **Rien** — le livrable reste en local ; passer directement à l'étape de signalement.

Branche web, en plus des 4 options ci-dessus, ajouter le cas particulier « **Exclu** » (constat déjà couvert par une issue de veille existante → la fermer comme trace de l'analyse). **Jamais d'écriture Notion ou GitLab avant ce verdict.**

### R1. Import Notion

#### R1.0 Vérification de doublon (avant toute création)

Vidéo : extraire l'ID vidéo (segment `v=` de l'URL, ou ID brut) et le chercher dans Notion. Un résultat ne compte comme « déjà fait » que s'il s'agit de la page de cette vidéo dans la hiérarchie (elle contient le lien exact `https://www.youtube.com/watch?v={id}`) — pas une simple mention de l'ID ailleurs. Web : chercher le titre exact / l'URL source dans la hiérarchie.

- **Page + sous-pages présentes** → ne rien recréer : signaler les liens existants.
- **Page présente, sous-pages manquantes** → créer uniquement les sous-pages manquantes.
- **Absent** → création complète.

#### R1.1 Hiérarchie

Vidéo :

```
{Racine — ex. Perso / Writing / Transcripts 📝}
└── {Chaîne YouTube}
    └── {Titre de la vidéo} (🎥)
        ├── Transcript (📄)
        └── Résumé (📋)
```

Web :

```
{Racine — à proposer et confirmer}
└── {Domaine ou source}
    └── {Titre de la page} (🌐)
        └── Analyse (📄)   [si le contenu est long ; sinon le contenu directement sur la page]
```

**Ancrage vidéo** : pour les vidéos writing, la racine = `Writing` (https://app.notion.com/p/982ce841bc1b4434bf28419fb073f4d9, chemin `Perso / Writing`) et la page `Transcripts` sous `Writing` ; icône de page chaîne ✍️. Pour les autres types de vidéos (DevOps, veille info…), proposer la racine/domaine le plus adapté et le **confirmer avec l'utilisateur** s'il existe plusieurs hiérarchies plausibles ; ne jamais dupliquer : chercher d'abord la page racine (fetch), puis la page chaîne/domaine (fetch ou recherche) ; ne créer que ce qui manque. La page chaîne porte le nom de la chaîne YouTube (`meta.json`).

**Ancrage web** : proposer la racine la plus adaptée à la nature de la veille (et la confirmer si plusieurs hiérarchies plausibles existent dans l'espace Notion) ; ne jamais dupliquer.

**Page vidéo** (🎥, sous la page chaîne) — tout le contenu s'envoie en **markdown PATCH** (mécanique ci-dessous), chaque bloc séparé par une ligne vide :
- Couverture **externe** (pas d'upload local du `imgs/cover.jpg`) en tête : `![cover](https://i.ytimg.com/vi/{id}/maxresdefault.jpg)`.
- 🎬 : Notion n'importe pas `> [!info]` en callout (devient une citation avec `[!info]` littéral) → **citation** `> 🎬 **Vidéo YouTube** : [watch?v={id}](https://www.youtube.com/watch?v={id})`.
- Puces de métadonnées : **Chaîne** (podcast si identifiable), **Invité(e)** si interview, **Date de publication**, **Durée** (+ chapitres), **Langue originale** (noter la traduction française en cas B), **Sponsor** si identifiable.
- Une citation courte et représentative (bloc de citation `> « … »`), si pertinente.

**Page web** (🌐) :
- Callout 🌐 : `Source : [titre](url)`.
- Puces de métadonnées : **Type** (projet GitHub / blog / newsletter / docs), **Date de la page** si identifiable, **Projet analysé** si applicable.

**Sous-pages** : le contenu **intégral** des livrables locaux (`transcript.md` + `resume.md` pour une vidéo ; `veille.md` pour une page).

**Mécanique — API markdown PATCH (méthode éprouvée #17–#19 ; l'API de blocs `POST /v1/blocks/{id}/children` renvoie 400 sur cet environnement)**

Helper persistant `/tmp/notion_api.py` : `N.api(method, path, body)` (Notion-Version 2022-06-28, pour `POST /v1/pages` + `GET /v1/search`) et `N.md(method, path, body)` (Notion-Version 2025-09-03, pour `GET`/`PATCH` markdown — **body requis, passer `{}` pour un GET**). Token : `mcpServers.notion.env.NOTION_TOKEN` dans `~/.qwen/settings.json` (**jamais l'imprimer**). Appel : `cd /tmp && python3 - <<'PYEOF' import notion_api as N …`.

Pour **chaque page** (🎥 / 📄 / 📋) :
1. `POST /v1/pages` sous le parent → `{"parent":{"page_id":<PARENT>},"properties":{"title":{"title":[{"text":{"content":"<TITRE>"}}]}}}` → récupérer l'`id`.
2. Préparer le markdown : **stripper le frontmatter YAML** (jusqu'au 2e `---`), **supprimer le H1** (le titre de page le remplace) et, pour Transcript/Résumé, **supprimer la ligne `![cover](…)`** (la cover est sur la page vidéo).
3. **Chunker ≤ 14000 code units, coupure sur `\n`** (une ligne = une unité, jamais couper au milieu d'une ligne). Via `PATCH /v1/pages/{id}/markdown` :
   - 1er chunk : `{"type":"replace_content","replace_content":{"new_str":"<md>"}}`
   - chunks suivants : `{"type":"insert_content","insert_content":{"content":"<md>","position":{"type":"end"}}}`
4. **Échappement `>>`** : une ligne **ouvrant** par `>> ` serait lue comme blockquote imbriqué → on perd le marqueur. Avant envoi, échapper le premier `>` des lignes ouvrant par `>>` → `\>\> `. Les `>>` **en milieu de ligne** restent bruts.
5. Gras-italique imbriqué : écrire `***Titre***` (jamais `**Titre *italique***`) — la forme qui rend proprement.

**Dédup** (avant création) : `N.api("GET","/v1/search",{"query":<Q>,"filter":{"property":"object","value":"page","in_trash":false},"page_size":10})` — schéma `property`/`object`/`in_trash` (PAS `object_type`).

**Vérification lossless** (après envoi de chaque page) : `GET /v1/pages/{id}/markdown` → normaliser les **deux** côtés puis comparer sur les **lignes non-vides** (Notion replie les lignes vides) via difflib. Normalisations bénignes à ignorer (pas de perte) : repli des lignes vides, URL nue auto-liée `[u](http://u)`, `$`→`\$`, `[`/`]`→`\[ \]`, puce `- `→`* `, re-sérialisation du gras-italique imbriqué. **Assert** : nombre total de `>>`, nombre de timestamps `[hh:mm:ss`, nombre de chapitres.

### R2. Issues GitLab

Méthode /perso-veille appliquée au livrable local, en **issues granulaires** : un constat actionnable = une issue.

1. **Projet cible** : par défaut le projet du dossier courant (`git remote get-url origin` → namespace/projet) ; l'utilisateur peut en désigner un autre (projet donné dans la question de routage).
2. **Conventions du projet** : `mcp__gitlab__list_issues` + `QWEN.md` — format titre/corps, labels en usage.
3. **Décision avant toute écriture** : `ask_user_question` récapitulant la liste des constats actionnables extraits du livrable et la destination de chacun (nouvelle issue / mise à jour de l'issue existante #N si elle couvre déjà le sujet / écarté). Jamais de création/mise à jour d'issue avant ce verdict.
4. **Créer / mettre à jour les issues**, en suivant les conventions du projet détectées. À défaut :
   - Titre : `Veille : <sujet du constat> (<source : titre de la vidéo ou de la page>)` — ou le format du projet.
   - Corps : ligne `**Cibles** : …` + `**Source** : <url>` (+ horodatage du constat si vidéo) + sections **Ce que c'est** / **Où ça s'applique au projet** / **Limites** / **Décision (<date>)** avec le choix de l'utilisateur.
   - Labels `criticite:*` s'ils existent dans le projet (défaut `criticite:basse`, plus élevé si le constat est sérieux).
   - Issue existante qui couvre le constat → la **mettre à jour** (section ou note), pas de doublon.
5. **Mémoire** (si applicable) : si le projet tient des mémoires de veille (index `MEMORY.md` + un fichier par outil), enregistrer/mettre à jour la fiche : nom, date, décision, n° d'issue + ligne d'index.

**GitLab MCP indisponible** → présenter l'analyse complète + le contenu d'issue prêt à coller.

## Signaler au user

Chemins des livrables locaux, titre et source (chaîne pour une vidéo, type pour une page), langue(s) utilisée(s) en cas de vidéo, 2-3 éléments marquants, puis le résultat du routage choisi : liens des pages Notion (existantes ou créées) et/ou liens des issues GitLab créées ou mises à jour.

## Modèle de `resume.md` (vidéo — structure unique générique)

Même gabarit pour **toute** vidéo, quel que soit le sujet :

```markdown
---
title: {titre de la vidéo}
channel: {chaîne}
url: {url}
date: {date de publication}
source: {chemin relatif du dossier, ex. youtube-transcript/auteur/titre-video}
---

# {titre de la vidéo} — Résumé

## Vue d'ensemble
3 à 6 paragraphes : de quoi parle la vidéo, sa structure (si chapitres), les idées portantes.

## Points clés
Les constats, faits et enseignements majeurs, horodatés [MM:SS], réformulés dense plutôt que paraphrasés longuement. C'est la section qui alimente le routage GitLab : chaque point doit être un constat distinct et actionnable.

## Citations marquantes
> "Quote verbatim en langue originale" — *traduction française* [MM:SS]

Uniquement les phrases réellement réutilisables (percutantes, formulables) — pas un résumé déguisé en citation.

## Ressources & outils cités
Chaque livre, outil, service, projet, commande, document, auteur, site cité : nom complet (langue originale), en quoi il est cité dans la vidéo, [MM:SS]. Si une ressource est nommée sans être décrite, l'indiquer honnêtement (« cité sans développement »).

## Conseils & bonnes pratiques
Conseils concrets et actionnables, un par ligne, [MM:SS].

## Points de vue, limites & anecdotes
Affirmations contre-intuitives, limites et avertissements des intervenants, anecdotes réutilisables — ce qui fait l'originalité de la vidéo, [MM:SS].
```

> **Vidéos craft / writing** : les deux sections les plus précieuses sont **Ressources & outils cités** (= liste de lecture — livres, auteurs, méthodes, sites) et **Conseils & bonnes pratiques** (actionnables, horodatés) — les soigner en priorité.

## Modèle de `veille.md` (page web)

```markdown
---
title: {titre de la page / du projet}
url: {url}
date: {date de consultation}
source: {chemin du projet courant}
---

# {titre} — Analyse de veille

## Ce que c'est
3 à 6 paragraphes : nature, stack, licence, activité du repo si GitHub, fonctionnalités, positionnement.

## Constats actionnables
Chaque constat distinct, actionnable pour le projet courant (sécurité, upgrade, compatibilité stack, processus à adopter, fiche technique utile), sourcé (section de la page / URL). C'est la section qui alimente le routage GitLab : 1 constat = 1 issue.

## Ressources & références
Tout élément cité utile hors contexte du projet (doc, article, projet apparenté), sans contexte.

## Limites & réserves
Ce qui est incertain, non vérifié, ou ne colle pas à la stack du projet.
```

## Règles communes

- Ne créer que les sections qui ont du contenu — jamais de section vide, jamais de remplissage.
- Rien d'inventé : chaque élément du livrable doit être traçable dans la source (transcript, page).
- Garder les titres d'œuvres, noms d'auteurs, noms d'outils et citations verbatim dans leur langue originale ; le reste s'écrit en français.
- Noter les doutes de transcription (ASR) au niveau de l'entrée concernée (ex. nom de livre incertain), jamais en silence.
- Lecture seule avant le verdict de routage : `web_fetch`, `git remote`, `git log`, `list_issues` uniquement — aucune écriture.
- Rapport final concis : livrables, éléments marquants, décision, liens.

## Erreurs (branche vidéo)

Cas d'erreurs du script (voir le SKILL.md de baoyu) : pas de sous-titres, langue indisponible, vidéo supprimée/privée/region-locked, IP bloquée, age-restricted. En cas de blocage anti-bot, le script retente avec d'autres clients puis bascule sur `yt-dlp` ; si cet outil manque, le rendre disponible (l'installer) plutôt que de demander à l'utilisateur quoi faire.
