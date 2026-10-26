# Cours SQL — PostgreSQL 17

> Apprendre le SQL pour de vrai : pas seulement **écrire** des requêtes,
> mais savoir les **lire**, les **comprendre** et repérer ce qui cloche.

Un cours complet et gratuit, module par module, sur PostgreSQL 17. Pour chaque
notion :

- **pourquoi** on l'utilise ;
- **quand** l'utiliser ;
- **quand ne pas** l'utiliser ;
- les **pièges** qui donnent un résultat faux sans message d'erreur ;
- les petits détails qui font la différence entre savoir et comprendre.

On pratique sur **Kaz Péi**, une enseigne fictive de produits réunionnais
(rhums arrangés, vanille, vannerie…). Les données sont volontairement
imparfaites, comme dans la vraie vie : NULL, doublons, fautes de saisie,
majuscules incohérentes.

Le cours inclut un **agent professeur** (pour [OpenCode](https://opencode.ai))
qui te guide par des questions et des indices, **sans jamais te donner la
solution**.

---

## Sommaire

- [À qui s'adresse ce cours ?](#à-qui-sadresse-ce-cours-)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Comment travailler](#comment-travailler)
- [L'agent professeur (optionnel)](#lagent-professeur-optionnel)
- [Programme](#programme)
- [Le dataset Kaz Péi](#le-dataset-kaz-péi)
- [Dépannage](#dépannage)
- [Organisation du dépôt](#organisation-du-dépôt)

---

## À qui s'adresse ce cours ?

- Aux **débutants complets** en SQL : le module 0 part de zéro.
- Aux profils techniques (dev, data analyst, data engineer) qui « se
  débrouillent » en SQL mais **bloquent dès qu'une requête devient longue**.
- À toute personne qui vise un poste où PostgreSQL est utilisé.

La lecture de requêtes complexes est le fil rouge du cours. Une méthode est
introduite dès le module 0, puis réutilisée dans chaque module.

---

## Prérequis

### Logiciels

| Outil | Obligatoire ? | Version | Pourquoi |
|---|---|---|---|
| **Git** | Oui | toute version récente | Cloner le dépôt et récupérer les nouveaux modules |
| **Docker** + **Docker Compose** | Oui | Docker Compose v2 (commande `docker compose`, sans tiret) | Faire tourner PostgreSQL 17 sans rien installer d'autre |
| Un **éditeur de texte** | Oui | VS Code, ou n'importe lequel | Lire les fiches et remplir les fichiers d'exercices |
| **OpenCode** | Non | v2 | L'agent professeur |
| Un client SQL graphique | Non | DBeaver, extension PostgreSQL de VS Code… | Confort d'affichage. Le cours utilise `psql` en ligne de commande |

Tu n'as **pas** besoin d'installer PostgreSQL sur ta machine : il tourne dans
Docker, et `psql` est déjà inclus dans le conteneur.

**Vérifie ton installation** :

```bash
git --version
docker --version
docker compose version     # doit afficher « Docker Compose version v2.x »
```

### Selon ton système

- **Windows** : installe [Docker Desktop](https://www.docker.com/products/docker-desktop/)
  avec le backend **WSL 2** (Windows Subsystem for Linux), puis travaille dans un
  terminal WSL (Ubuntu). Clone le dépôt **dans le système de fichiers Linux**
  (`~/cours-sql`), pas dans `C:\` : c'est beaucoup plus rapide.
- **macOS** : [Docker Desktop](https://www.docker.com/products/docker-desktop/)
  ou [OrbStack](https://orbstack.dev/).
- **Linux** : [Docker Engine](https://docs.docker.com/engine/install/) et le
  plugin Compose.

### Matériel

- Environ **1 Go d'espace disque** (image PostgreSQL et données).
- Le **port 5433** libre sur ta machine (modifiable, voir [Dépannage](#dépannage)).
- Une connexion internet pour le premier téléchargement de l'image Docker.

### Connaissances

Aucune connaissance en SQL n'est nécessaire. Il faut seulement savoir ouvrir un
terminal et taper des commandes.

---

## Installation

```bash
# 1. Cloner le dépôt
git clone https://github.com/<ton-compte>/cours-sql.git
cd cours-sql

# 2. Démarrer PostgreSQL 17
#    Au premier démarrage, le dataset et les outils de vérification
#    sont chargés automatiquement (quelques secondes).
docker compose up -d

# 3. Vérifier que le conteneur est prêt (STATUS doit afficher « healthy »)
docker compose ps

# 4. Ouvrir la console psql
docker compose exec db psql -U eleve -d cours_sql
```

Dans psql, tape ta première requête :

```sql
SELECT count(*) FROM commandes;
```

Si tu obtiens `1500`, tout fonctionne. 🎉

**Informations de connexion** (pour un client graphique) :

| Paramètre | Valeur |
|---|---|
| Hôte | `localhost` |
| Port | `5433` |
| Base | `cours_sql` |
| Utilisateur | `eleve` |
| Mot de passe | `eleve` |

⚠️ Ces identifiants sont volontairement simples : la base ne tourne que sur ta
machine, pour apprendre. Ne réutilise jamais cette configuration en production.

---

## Comment travailler

### 1. Une fiche, puis des exercices

Chaque module contient :

- une **fiche de cours** dans `fiches/`, à lire en entier avant les exercices ;
- cinq fichiers d'**exercices** dans `exercices/module-XX/`.

| Fichier | Type | Ce que tu fais |
|---|---|---|
| `01_explorer.sql` | Explorer | Découvrir les données |
| `02_lire_predire.sql` | 👁️ Lire / prédire | Prédire le résultat **avant** d'exécuter |
| `03_deboguer.sql` | 🐛 Déboguer | Trouver pourquoi une requête est fausse |
| `04_ecrire.sql` | ✍️ Écrire | Écrire la requête qui répond à une question |
| `05_reecrire.sql` | 🔄 Réécrire | Rendre une requête lisible et l'annoter |

Les exercices « lire / prédire » sont les plus importants. Ne saute pas
l'étape de prédiction : c'est l'écart entre ce que tu crois et ce qui se passe
vraiment qui te fait progresser.

### 2. Vérifier tes réponses

Les exercices qui ont un identifiant (`m00-e1`, `m00-d3`…) se vérifient
directement dans psql :

```sql
SELECT outils.verifier('m00-e1', $q$
    SELECT ... ta requête ...
$q$);
```

La fonction répond :

- `✅ Correct` ;
- `❌ ta requête renvoie X lignes, il en faut Y` ;
- `❌ le bon nombre de lignes mais le contenu diffère`.

**Les solutions ne sont stockées nulle part dans le dépôt.** La vérification
compare une empreinte (hash) de ton résultat à celle du résultat attendu.
Impossible de tricher en lisant un fichier : il faut trouver.

💡 `$q$ ... $q$` est une chaîne « dollar-quotée » de PostgreSQL : tout ce qui est
entre les deux balises est du texte brut, apostrophes comprises.

### 3. Exécuter un fichier entier

Le dossier `exercices/` est accessible depuis le conteneur :

```
\i /exercices/module-00/02_lire_predire.sql
```

### 4. Réglage conseillé dans psql

```
\pset null '∅'
```

Sans ce réglage, psql affiche les NULL comme des cases vides, impossibles à
distinguer d'un texte vide. Le module 0 explique pourquoi c'est important.

### 5. Garder ta progression

Le plus simple : **forke** ce dépôt sur ton compte GitHub, travaille dans ton
fork et commite tes réponses au fur et à mesure. Tu gardes un historique de ta
progression, et tu peux récupérer les nouveaux modules depuis le dépôt d'origine.

```bash
git remote add upstream https://github.com/<ton-compte>/cours-sql.git
git pull upstream main
```

---

## L'agent professeur (optionnel)

Le dépôt contient un agent [OpenCode](https://opencode.ai) (v2), **prof-sql**,
qui joue le rôle d'un professeur particulier.

**Ce qu'il fait** :

- Il lit tes fichiers d'exercices et **exécute tes requêtes** sur la base pour
  voir ce qu'elles renvoient.
- Il te guide par des **questions** (méthode socratique).
- Il donne des **indices gradués** : 🟢 orientation → 🟡 ciblage → 🔴 piste
  quasi directe. Tu passes au niveau suivant seulement si tu le demandes.
- Il te fait **relire ta requête dans l'ordre d'exécution** quand tu bloques.
- Il tient un journal de ta progression dans `progression.md`.

**Ce qu'il ne fait pas** : te donner la solution. Il n'en a d'ailleurs pas la
possibilité technique. Ses permissions lui interdisent d'écrire dans tes
fichiers d'exercices (seul `progression.md` lui est ouvert), et son shell est
limité à `psql`. Si tu veux vraiment la solution, demande-la explicitement : il
te demandera de confirmer, puis te la donnera commentée ligne par ligne.

**Lancer l'agent** :

```bash
# Dans le dossier du cours, avec le conteneur démarré
opencode
```

L'agent prof-sql est sélectionné par défaut (voir `opencode.jsonc`). Touche
`Tab` pour passer à un autre agent.

**Prérequis** : [OpenCode installé](https://opencode.ai) et configuré avec un
fournisseur de modèle d'IA (clé API ou abonnement). Le choix du modèle est libre ;
un modèle performant en raisonnement donne un meilleur professeur.

Sans OpenCode, le cours reste entièrement utilisable : fiches + exercices +
`outils.verifier`.

---

## Programme

| # | Module | Statut |
|---|---|---|
| 0 | **Fondations** : psql, grain, types, NULL, calculs, ordre d'exécution, méthode de lecture | ✅ Disponible |
| 1 | **Interroger une table** : SELECT, WHERE, ORDER BY, LIMIT, DISTINCT, logique du NULL | 🚧 À venir |
| 2 | **Transformer les valeurs** : CASE, COALESCE, CAST, fonctions texte et dates | 🚧 À venir |
| 3 | **Agréger** : GROUP BY, HAVING, les pièges de COUNT | 🚧 À venir |
| 4 | **Jointures** : INNER, LEFT, FULL, CROSS, self-join, anti-join, explosion de lignes | 🚧 À venir |
| 5 | **Structurer ses requêtes** : sous-requêtes, CTE, EXISTS ou IN | 🚧 À venir |
| 6 | **Opérations ensemblistes** : UNION, INTERSECT, EXCEPT | 🚧 À venir |
| 7 | **Fonctions de fenêtre** : ROW_NUMBER, RANK, LAG/LEAD, cumuls | 🚧 À venir |
| 8 | **Modifier les données** : DDL, DML, MERGE, transactions | 🚧 À venir |
| 9 | **Modélisation** : normalisation, schéma en étoile, SCD | 🚧 À venir |
| 10 | **Performance** : EXPLAIN, index, plans d'exécution | 🚧 À venir |
| 11 | **SQL du data engineer** : dédoublonnage, idempotence, chargements incrémentaux | 🚧 À venir |
| 12 | **Lire et décortiquer du SQL réel** : requêtes longues, étape par étape | 🚧 À venir |

Les modules sont publiés au fur et à mesure. Pense à faire `git pull`
régulièrement (voir [Dépannage](#dépannage) pour charger un nouveau module).

---

## Le dataset Kaz Péi

| Table | Une ligne = | Volume |
|---|---|---|
| `magasins` | un magasin | 6 |
| `clients` | un client | 120 |
| `categories` | une catégorie (arborescente) | 8 |
| `produits` | un produit du catalogue | 40 |
| `commandes` | une commande (en-tête) | 1 500 |
| `lignes_commande` | un produit dans une commande | 3 751 |

```
categories ◄── produits ◄── lignes_commande ──► commandes ──► clients
                                                    │
                                                    └──► magasins (NULL = en ligne)
```

Les données sont générées de façon **déterministe** : tout le monde a
exactement les mêmes, donc les mêmes résultats que dans les fiches.

⚠️ Les défauts dans les données sont **volontaires**. Ne les corrige pas : ce
sont tes terrains d'entraînement.

---

## Dépannage

**Le port 5433 est déjà utilisé**
Dans `docker-compose.yml`, remplace `"5433:5432"` par un autre port libre,
par exemple `"5434:5432"`.

**J'ai cassé les données (DELETE, DROP…) et je veux repartir de zéro**

```bash
docker compose down -v      # le -v supprime le volume de données
docker compose up -d
```

Attention : ça efface aussi ce que tu as créé dans la base. Tes fichiers
d'exercices, eux, ne sont pas touchés.

**`outils.verifier` répond « Exercice inconnu »**
Le module a été ajouté après ton premier démarrage. Charge ses attendus :

```bash
docker compose exec db psql -U eleve -d cours_sql -f /exercices/module-01/attendus.sql
```

(ou repars de zéro avec la commande ci-dessus, qui recharge tout.)

**`docker compose` : commande inconnue**
Tu as l'ancienne version de Compose. Essaie `docker-compose` (avec un tiret), ou
mets Docker à jour.

**Le conteneur ne démarre pas**

```bash
docker compose logs db
```

**Windows : tout est très lent**
Le dépôt est probablement dans `C:\` ou `/mnt/c/`. Clone-le dans ton dossier WSL
(`~/cours-sql`).

---

## Organisation du dépôt

```
cours-sql/
├── README.md                     ce fichier
├── AGENTS.md                     contexte du projet pour les agents d'IA
├── opencode.jsonc                configuration OpenCode (agent par défaut)
├── docker-compose.yml            PostgreSQL 17
├── progression.md                ton journal de progression
├── .opencode/agents/prof-sql.md  l'agent professeur
├── data/init/                    scripts exécutés au 1er démarrage
│   ├── 01_schema.sql             schéma de la base
│   ├── 02_donnees.sql            données du dataset
│   ├── 03_outils.sql             fonctions de vérification
│   └── 04_attendus.sh            chargement des empreintes de tous les modules
├── fiches/                       une fiche de cours par module
└── exercices/
    └── module-00/                exercices + attendus.sql (empreintes, pas de solutions)
```

---

## Contribuer

Une erreur dans une fiche, un exercice ambigu, une idée de piège à ajouter ?
Ouvre une *issue* ou une *pull request*. Les retours de personnes qui suivent le
cours sont les plus précieux.

Fait à La Réunion. 🌋
