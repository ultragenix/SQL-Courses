# Module 0 — Fondations : comprendre avant d'écrire

> **Objectif du module** : savoir **lire** n'importe quelle requête SELECT, même
> longue, en suivant une méthode. On écrira peu de SQL ici. On construit les
> fondations qui rendront tous les modules suivants plus faciles.
>
> **Durée estimée** : 3 à 4 heures, exercices compris.
>
> **Prérequis** : Docker installé, le dépôt `cours-sql` cloné.

## Sommaire

- [0.1 Mettre en route l'environnement](#01-mettre-en-route-lenvironnement)
- [0.2 Le kit de survie psql](#02-le-kit-de-survie-psql)
- [0.3 Le modèle relationnel : tables, lignes, clés et grain](#03-le-modèle-relationnel--tables-lignes-clés-et-grain)
- [0.4 Les types de données essentiels](#04-les-types-de-données-essentiels)
- [0.5 NULL : premier contact](#05-null--premier-contact)
- [0.6 Anatomie d'une requête SELECT](#06-anatomie-dune-requête-select)
- [0.7 Calculer directement dans une requête](#07-calculer-directement-dans-une-requête)
- [0.8 L'ordre d'exécution : LA notion clé](#08-lordre-dexécution--la-notion-clé)
- [0.9 La méthode de lecture](#09-la-méthode-de-lecture)
- [0.10 Guillemets simples, guillemets doubles](#010-guillemets-simples-guillemets-doubles)
- [0.11 Écrire du SQL lisible](#011-écrire-du-sql-lisible)
- [0.12 À retenir](#012-à-retenir)
- [Exercices](#exercices)

Légende des encadrés :

- 💡 **Le savais-tu ?** : astuce ou fonctionnalité méconnue
- ⚠️ **Piège** : ce qui donne un résultat faux **sans message d'erreur** (les plus dangereux)
- 🧠 **Sous le capot** : comment PostgreSQL traite vraiment les choses
- 🔁 **Et dans BigQuery ?** : différences avec BigQuery, très utilisé en data (Google Cloud)

---

## 0.1 Mettre en route l'environnement

```bash
cd cours-sql
docker compose up -d          # démarre PostgreSQL 17 en arrière-plan
docker compose ps             # vérifie que le conteneur est « healthy »
docker compose exec db psql -U eleve -d cours_sql
```

Tu arrives sur une invite de ce genre :

```
cours_sql=#
```

Tape ta première requête :

```sql
SELECT count(*) FROM commandes;
```

Résultat attendu : `1500`. Si c'est le cas, tout fonctionne.

Les empreintes de vérification des exercices sont chargées automatiquement au
premier démarrage. Vérifie-le :

```sql
SELECT count(*) FROM outils.attendus;   -- 14 pour le module 0
```

Si un module a été ajouté après ton premier démarrage (après un `git pull`, par
exemple), charge ses attendus à la main : `\i /exercices/module-01/attendus.sql`.

💡 **Le savais-tu ?** Les scripts de `data/init/` ne s'exécutent qu'au **premier**
démarrage, quand le volume de données est vide. Si tu as cassé quelque chose (un
`DELETE` malheureux, par exemple), repars de zéro avec
`docker compose down -v && docker compose up -d`. Le `-v` supprime le volume.

---

## 0.2 Le kit de survie psql

`psql` est le client en ligne de commande officiel de PostgreSQL. C'est l'outil
que tu trouveras sur **tous** les serveurs, sans interface graphique. Le maîtriser
est un vrai atout en entreprise.

Il y a deux types de commandes :

- les **requêtes SQL**, qui se terminent par un point-virgule `;`
- les **méta-commandes psql**, qui commencent par un antislash `\` et n'ont pas de `;`

### Les méta-commandes indispensables

| Commande | Ce qu'elle fait | Quand t'en servir |
|---|---|---|
| `\?` | Liste toutes les méta-commandes | Quand tu as oublié une commande |
| `\h SELECT` | Affiche la **syntaxe officielle** d'une instruction SQL | Quand tu doutes de l'ordre des clauses |
| `\dt` | Liste les tables | Découvrir une base inconnue |
| `\d commandes` | Décrit une table : colonnes, types, NULL autorisé, clés | **Avant d'écrire la moindre requête** sur une table |
| `\d+ commandes` | Pareil, avec les commentaires et la taille | Comprendre à quoi sert une table |
| `\dn` | Liste les schémas | Voir comment la base est organisée |
| `\x` | Bascule l'affichage vertical (une colonne par ligne) | Tables très larges, illisibles en horizontal |
| `\pset null '∅'` | Affiche les NULL avec un symbole visible | **Toujours.** Voir explication ci-dessous |
| `\timing` | Affiche le temps d'exécution de chaque requête | Comparer deux écritures d'une même requête |
| `\e` | Ouvre la dernière requête dans un éditeur de texte | Modifier une requête longue |
| `\i fichier.sql` | Exécute un fichier | Lancer tes fichiers d'exercices |
| `\q` | Quitte psql | |

⚠️ **Piège** : par défaut, psql affiche un NULL comme une **case vide**. Impossible
de distinguer NULL d'une chaîne vide `''`. Dans notre dataset, la cliente 120 a un
email vide `''` et d'autres clients ont un email NULL : sans `\pset null`, ils sont
identiques à l'écran. Ce n'est pas la même chose (voir 0.5).

💡 **Le savais-tu ?** Tu peux rendre ce réglage permanent. Crée un fichier
`~/.psqlrc` sur ta machine (ou dans le conteneur) avec :

```
\pset null '∅'
\timing on
\x auto
```

`\x auto` passe automatiquement en affichage vertical quand le résultat est trop
large pour l'écran.

### Les réflexes clavier

- Tu as oublié le `;` ? L'invite devient `cours_sql-#` (avec un tiret) : psql attend
  la suite. Tape simplement `;` puis Entrée.
- L'invite affiche `cours_sql'#` ? Tu as ouvert une apostrophe sans la fermer.
  Fais `Ctrl+C` pour annuler la saisie.
- `Flèche haut` rappelle les requêtes précédentes.
- `Tab` complète les noms de tables et de colonnes. Utilise-le tout le temps :
  ça évite les fautes de frappe.

🔁 **Et dans BigQuery ?** L'équivalent de `\d table` est l'onglet « Schéma » de la
console, ou la requête `SELECT * FROM dataset.INFORMATION_SCHEMA.COLUMNS`.
PostgreSQL a aussi un `information_schema` standard, mais `\d` est bien plus rapide.

---

## 0.3 Le modèle relationnel : tables, lignes, clés et grain

### Les briques de base

- Une **table** stocke un type de « chose » : des clients, des commandes, des produits.
- Une **ligne** (ou enregistrement) est **une** occurrence de cette chose.
- Une **colonne** est un attribut de cette chose, avec un **type** fixe.
- Un **schéma** est un dossier qui regroupe des tables. Notre dataset est dans le
  schéma `boutique`, et les outils de vérification dans le schéma `outils`.

### Le grain : la notion qui va tout changer pour toi

Le **grain** d'une table (ou d'un résultat de requête), c'est la réponse à la
question : **« une ligne = quoi ? »**

| Table | Une ligne = |
|---|---|
| `clients` | un client |
| `magasins` | un magasin |
| `produits` | un produit du catalogue |
| `commandes` | **une commande** (l'en-tête : qui, où, quand, statut) |
| `lignes_commande` | **un produit dans une commande** (quoi, combien, à quel prix) |

Une commande de 3 produits, c'est donc **1 ligne** dans `commandes` et
**3 lignes** dans `lignes_commande`.

Pourquoi c'est crucial ? Parce que **chaque clause d'une requête peut changer le
grain**. Une jointure peut le rendre plus fin (on passe de « une commande » à « un
produit dans une commande »). Un `GROUP BY` le rend plus grossier (on passe de « une
commande » à « un magasin »). Quasiment toutes les requêtes incompréhensibles, et
une grande partie des bugs silencieux, viennent d'un changement de grain qu'on n'a
pas vu passer. On y revient en 0.9.

### Les clés

La **clé primaire** (PK = Primary Key) identifie chaque ligne de façon **unique**.
Deux lignes ne peuvent pas avoir la même valeur de clé primaire, et elle ne peut
jamais être NULL.

- `clients.client_id`, `commandes.commande_id`, etc.

La **clé étrangère** (FK = Foreign Key) est une colonne qui **pointe vers** la clé
primaire d'une autre table. Elle crée le lien entre les tables.

- `commandes.client_id` pointe vers `clients.client_id` : « cette commande a été
  passée par ce client ».
- `lignes_commande.commande_id` pointe vers `commandes.commande_id`.

PostgreSQL **garantit** qu'une clé étrangère pointe toujours vers une ligne qui
existe. Impossible d'insérer une commande pour le client 9999 s'il n'existe pas.

```
categories ◄── produits ◄── lignes_commande ──► commandes ──► clients
                                                    │
                                                    └──► magasins (NULL = en ligne)
```

### Pourquoi découper en plusieurs tables ?

Pourquoi ne pas tout mettre dans une seule grande table « ventes » ? Parce que le
nom et la commune du client seraient répétés sur chaque produit de chaque commande.
Le jour où il déménage, il faudrait modifier des centaines de lignes, et en oublier
une créerait une incohérence. Découper évite la redondance : c'est la
**normalisation**, qu'on détaillera au module Modélisation.

💡 **Le savais-tu ?** En data engineering (BigQuery, dbt), on fait souvent
l'inverse : on **dénormalise** volontairement dans les tables d'analyse, parce que
les jointures coûtent cher sur de gros volumes et que les données ne sont plus
modifiées. Les deux approches sont justes, chacune dans son contexte : normaliser
pour les bases **transactionnelles** (OLTP = Online Transaction Processing), où
on écrit beaucoup ; dénormaliser pour les bases **analytiques** (OLAP = Online
Analytical Processing), où on lit beaucoup.

### Explore le schéma toi-même

```
\dt
\d clients
\d+ lignes_commande
```

Dans la sortie de `\d`, regarde la colonne **Nullable** : `not null` signifie que la
colonne ne peut jamais être vide. Toutes les autres **peuvent** contenir des NULL,
et ton SQL doit en tenir compte.

---

## 0.4 Les types de données essentiels

Chaque colonne a un type. Le type détermine ce qu'on peut y stocker **et le
comportement des calculs**. Voici les types que tu croiseras tout le temps. On
creusera les dates et le texte dans les modules suivants.

| Type | Contenu | Quand l'utiliser | Quand ne PAS l'utiliser |
|---|---|---|---|
| `integer` | Entier (± 2,1 milliards) | Identifiants, quantités, comptages | Montants en euros |
| `bigint` | Grand entier (± 9 × 10¹⁸) | Identifiants de très grosses tables, compteurs | Quand `integer` suffit (prend 2× plus de place) |
| `numeric(p, s)` | Nombre décimal **exact** | **Argent**, taux, tout ce qui doit tomber juste | Calcul scientifique massif (plus lent) |
| `double precision` | Nombre à virgule flottante, **approché** | Mesures physiques, scores, statistiques | **Jamais pour de l'argent** |
| `text` | Texte de longueur libre | Par défaut pour tout texte en PostgreSQL | |
| `varchar(n)` | Texte limité à n caractères | Quand la limite est une **règle métier** (code postal) | Comme réflexe « pour la performance » : aucun gain en PostgreSQL |
| `boolean` | `true` / `false` / NULL | Drapeaux (`actif`, `est_pro`) | |
| `date` | Une date sans heure | Dates de naissance, d'ouverture | Instant précis d'un événement |
| `timestamptz` | Instant précis **avec fuseau** | **Tout horodatage d'événement** | |
| `timestamp` | Date + heure **sans fuseau** | Rarement : heure « murale » sans lieu | Horodatages d'événements (piège des fuseaux) |

⚠️ **Piège : les flottants ne sont pas exacts**

```sql
SELECT 0.1::double precision + 0.2::double precision AS flottant,
       0.1::numeric + 0.2::numeric                   AS exact;
```

```
      flottant       | exact
---------------------+-------
 0.30000000000000004 |   0.3
```

Le type `double precision` stocke une **approximation binaire**. Sur des millions de
lignes de chiffre d'affaires, les erreurs s'accumulent et ton total ne tombe plus
juste. C'est pour ça que les prix du dataset sont en `numeric(10, 2)`.

🧠 **Sous le capot** : `numeric(10, 2)` signifie « 10 chiffres au total, dont 2 après
la virgule ». Donc au maximum 99 999 999,99.

💡 **Le savais-tu ?** `pg_typeof(...)` te dit le type de n'importe quelle
expression. C'est l'outil de diagnostic idéal quand un calcul donne un résultat
bizarre :

```sql
SELECT pg_typeof(5 / 2), pg_typeof(5 / 2.0), pg_typeof(now());
```

```
 pg_typeof | pg_typeof |        pg_typeof
-----------+-----------+--------------------------
 integer   | numeric   | timestamp with time zone
```

💡 **Le savais-tu ?** `timestamptz` ne stocke **pas** le fuseau horaire. Il
convertit tout en UTC (Coordinated Universal Time) à l'écriture, puis convertit
vers le fuseau de ta session à l'affichage. Notre base est réglée sur
`Indian/Reunion`, d'où le `+04` à la fin des dates. C'est **le** bon type pour un
data engineer qui travaille à La Réunion avec des serveurs en UTC.

🔁 **Et dans BigQuery ?** `INT64` ≈ `bigint`, `NUMERIC` ≈ `numeric`,
`FLOAT64` ≈ `double precision`, `STRING` ≈ `text`, `TIMESTAMP` ≈ `timestamptz`,
`DATETIME` ≈ `timestamp`.

---

## 0.5 NULL : premier contact

`NULL` signifie **« valeur inconnue ou absente »**. Ce n'est **pas** zéro, ce
n'est **pas** une chaîne vide. C'est l'absence d'information.

| Valeur | Signification dans `clients.email` |
|---|---|
| `'jean.payet@mail.re'` | On connaît l'email |
| `''` (chaîne vide) | On a saisi « rien » : le champ a été rempli à vide |
| `NULL` | On ne sait pas, l'information n'a jamais été saisie |

Trois règles à graver dès maintenant (on approfondit au module 1) :

**Règle 1 : un calcul avec NULL donne NULL.**

```sql
SELECT produit_id, nom, prix_unitaire, cout_achat,
       prix_unitaire - cout_achat AS marge
FROM produits
WHERE produit_id IN (9, 11, 18, 26, 40);
```

```
 produit_id |            nom            | prix_unitaire | cout_achat | marge
------------+---------------------------+---------------+------------+-------
          9 | Piment zoizo pot 100g     |          7.90 |       2.50 |  5.40
         11 | Curcuma de La Plaine 100g |          6.90 |          ∅ |     ∅
         18 | Gelée de goyave 220g      |          6.90 |          ∅ |     ∅
         26 | Chapeau vétiver           |         35.00 |          ∅ |     ∅
         40 | Bon cadeau 50 €           |         50.00 |          ∅ |     ∅
```

Logique : 6,90 € moins « un coût inconnu », ça donne « une marge inconnue ».

**Règle 2 : on ne compare JAMAIS avec `= NULL`.**

```sql
SELECT nom FROM produits WHERE cout_achat = NULL;   -- 0 ligne, sans erreur !
SELECT nom FROM produits WHERE cout_achat IS NULL;  -- 4 lignes
```

⚠️ **Piège** : `cout_achat = NULL` ne provoque **aucune erreur**. Elle renvoie
juste zéro ligne. Pourquoi ? Comparer quelque chose à une valeur inconnue donne
« inconnu », jamais « vrai ». Et `WHERE` ne garde que les lignes où la condition
est **vraie**. La bonne syntaxe est `IS NULL` / `IS NOT NULL`.

**Règle 3 : concaténer avec NULL donne NULL.**

```sql
SELECT 'Kaz' || ' ' || 'Péi' AS a,
       'Kaz' || NULL         AS b;
```

```
    a    | b
---------+---
 Kaz Péi | ∅
```

💡 **Le savais-tu ?** Les fonctions `concat(...)` et `concat_ws(separateur, ...)`
(ws = with separator) **ignorent** les NULL au lieu de tout faire disparaître :

```sql
SELECT concat_ws(' ', prenom, nom) FROM clients WHERE client_id = 117;
-- 'SARL Ti Kaz' (le prénom NULL est simplement ignoré, sans espace parasite)
```

---

## 0.6 Anatomie d'une requête SELECT

Une requête `SELECT` est composée de **clauses**. Toutes ne sont pas obligatoires,
mais quand elles sont présentes, elles s'écrivent **toujours dans cet ordre** :

```sql
SELECT    ...   -- 1. quelles colonnes afficher (et calculer)
FROM      ...   -- 2. depuis quelle(s) table(s)
JOIN      ...   --    (en reliant éventuellement d'autres tables)
WHERE     ...   -- 3. quelles LIGNES garder
GROUP BY  ...   -- 4. comment regrouper les lignes
HAVING    ...   -- 5. quels GROUPES garder
ORDER BY  ...   -- 6. dans quel ordre trier
LIMIT     ...   -- 7. combien de lignes renvoyer au maximum
```

| Clause | Rôle en une phrase | Obligatoire ? |
|---|---|---|
| `SELECT` | Choisit et calcule les colonnes du résultat | Oui |
| `FROM` | Désigne la source des lignes | Presque toujours (`SELECT 1 + 1;` fonctionne sans) |
| `JOIN ... ON` | Relie une autre table selon une condition | Non (module 4) |
| `WHERE` | Filtre les **lignes** une par une | Non (module 1) |
| `GROUP BY` | Regroupe les lignes qui partagent des valeurs | Non (module 3) |
| `HAVING` | Filtre les **groupes** après regroupement | Non (module 3) |
| `ORDER BY` | Trie le résultat | Non (module 1) |
| `LIMIT` | Tronque le résultat | Non (module 1) |

⚠️ **Piège** : sans `ORDER BY`, l'ordre des lignes **n'est pas garanti**. Il peut
changer d'une exécution à l'autre, après une mise à jour, ou sur un autre serveur.
Si l'ordre compte, écris-le.

### `SELECT *` : quand oui, quand non

`SELECT *` renvoie toutes les colonnes.

- ✅ **Quand l'utiliser** : pour **explorer** une table dans psql, avec un `LIMIT`.
- ❌ **Quand ne pas l'utiliser** : dans une requête qui sera **conservée** (un
  modèle dbt, un script de pipeline, une vue). Si quelqu'un ajoute une colonne à la
  table, ton résultat change sans que tu le saches. Et sur une base orientée
  colonnes comme BigQuery, tu paies la lecture de toutes les colonnes.

```sql
SELECT * FROM commandes LIMIT 5;   -- parfait pour découvrir la table
```

### Les alias avec `AS`

Un **alias** donne un nom à une colonne calculée ou à une table.

```sql
SELECT nom,
       prix_unitaire * 2 AS prix_double    -- alias de colonne
FROM produits AS p;                        -- alias de table
```

- Pour les colonnes calculées : **toujours** un alias, sinon PostgreSQL nomme la
  colonne `?column?`.
- Pour les tables : indispensable dès qu'il y a plusieurs tables (module 4).

💡 **Le savais-tu ?** Le mot `AS` est facultatif (`prix_unitaire * 2 prix_double`
fonctionne). Mets-le quand même : il rend la lecture évidente, et il évite un piège
classique où une virgule oubliée transforme silencieusement une colonne en alias de
la précédente : `SELECT nom prix_unitaire FROM produits` renvoie **une seule**
colonne, les noms, intitulée `prix_unitaire` !

---

## 0.7 Calculer directement dans une requête

Oui, on peut faire des calculs directement dans le `SELECT` (et dans le `WHERE`,
le `ORDER BY`…). C'est même l'un des usages les plus courants du SQL.

### Les opérateurs arithmétiques

| Opérateur | Rôle | Exemple | Résultat |
|---|---|---|---|
| `+` | Addition | `prix_unitaire + 2` | |
| `-` | Soustraction | `prix_unitaire - cout_achat` | la marge |
| `*` | Multiplication | `quantite * prix_unitaire` | le montant d'une ligne |
| `/` | Division | `5 / 2` | ⚠️ `2` |
| `%` | Modulo (reste de la division entière) | `5 % 2` | `1` |
| `^` | Puissance | `2 ^ 10` | `1024` |
| `\|\|` | Concaténation de texte | `prenom \|\| ' ' \|\| nom` | |

```sql
SELECT nom,
       prix_unitaire,
       cout_achat,
       prix_unitaire - cout_achat                AS marge,
       round(prix_unitaire * 1.085, 2)           AS prix_ttc
FROM produits
LIMIT 3;
```

💡 **Le savais-tu ?** À La Réunion, le taux normal de TVA (Taxe sur la Valeur
Ajoutée) est de 8,5 %, et non 20 % comme en métropole. D'où le `* 1.085`.

### ⚠️ Le piège n°1 du calcul en PostgreSQL : la division entière

```sql
SELECT 5 / 2   AS a,
       5 / 2.0 AS b,
       5 % 2   AS c;
```

```
 a |         b          | c
---+--------------------+---
 2 | 2.5000000000000000 | 1
```

**Règle** : quand les deux opérandes sont des entiers, PostgreSQL fait une
**division entière** (il tronque la partie décimale). Aucune erreur, juste un
résultat faux. C'est le bug classique des calculs de pourcentage :

```sql
-- Part de chaque ligne dans une commande de 11 articles
SELECT quantite * 100 / 11 AS pct_faux,          -- 4 * 100 / 11 → 36
       quantite * 100.0 / 11 AS pct_juste        -- 36.3636...
FROM lignes_commande
WHERE ligne_id = 103;
```

Les solutions, au choix :

- écrire une des constantes avec une décimale : `100.0` ;
- convertir explicitement : `quantite::numeric * 100 / 11`.

🔁 **Et dans BigQuery ?** C'est l'inverse : `/` renvoie **toujours** un `FLOAT64`,
même entre deux entiers. La division entière s'écrit `DIV(5, 2)`. Le même SQL donne
donc des résultats différents sur les deux moteurs : un vrai piège de migration.

### Quand calculer en SQL, et quand ne pas le faire ?

- ✅ **Calcule en SQL** les transformations ligne à ligne simples (marges, montants,
  conversions d'unités, concaténations) : le calcul se fait au plus près des
  données, sans transférer de lignes inutiles vers Python.
- ✅ **Calcule en SQL** tout ce qui sert à filtrer ou agréger : ça réduit le volume
  avant qu'il sorte de la base.
- ❌ **Ne calcule pas en SQL** une logique métier très complexe, avec beaucoup de
  règles imbriquées, qui serait illisible et non testable. Une fonction Python
  testée, ou un modèle dbt découpé en étapes, sera plus maintenable.

---

## 0.8 L'ordre d'exécution : LA notion clé

Voici le point le plus important de tout le module.

**On écrit une requête dans un ordre. PostgreSQL la traite dans un autre.**

| Ordre d'**écriture** | Ordre **logique d'exécution** |
|---|---|
| 1. `SELECT` | 1. `FROM` / `JOIN` |
| 2. `FROM` / `JOIN` | 2. `WHERE` |
| 3. `WHERE` | 3. `GROUP BY` |
| 4. `GROUP BY` | 4. `HAVING` |
| 5. `HAVING` | 5. `SELECT` (calcul des colonnes et des alias) |
| 6. `ORDER BY` | 6. `DISTINCT` |
| 7. `LIMIT` | 7. `ORDER BY` |
| | 8. `LIMIT` / `OFFSET` |

Pense à une chaîne de montage : chaque étape reçoit un **tableau intermédiaire**,
le transforme, et le passe à l'étape suivante.

```
 FROM/JOIN ──► WHERE ──► GROUP BY ──► HAVING ──► SELECT ──► DISTINCT ──► ORDER BY ──► LIMIT
 (assembler)  (filtrer   (regrouper)  (filtrer   (calculer  (dédoublonner) (trier)    (couper)
              lignes)                 groupes)   colonnes)
```

Cet ordre explique d'un coup une série d'erreurs qui semblent arbitraires.

### Conséquence 1 : un alias du SELECT n'existe pas encore dans le WHERE

```sql
SELECT nom, prix_unitaire - cout_achat AS marge
FROM produits
WHERE marge > 20;
```

```
ERROR:  column "marge" does not exist
```

Le `WHERE` (étape 2) s'exécute **avant** le `SELECT` (étape 5). Au moment du
filtre, l'alias `marge` n'a pas encore été créé. Solution : répéter l'expression.

```sql
SELECT nom, prix_unitaire - cout_achat AS marge
FROM produits
WHERE prix_unitaire - cout_achat > 20;
```

(Au module 5, on verra les CTE pour éviter de répéter les expressions longues.)

### Conséquence 2 : un alias du SELECT existe dans le ORDER BY

```sql
SELECT nom, prix_unitaire - cout_achat AS marge
FROM produits
ORDER BY marge DESC
LIMIT 5;
```

Ça fonctionne : le `ORDER BY` (étape 7) arrive **après** le `SELECT`.

⚠️ **Piège** : mais regarde le résultat.

```
            nom            | marge
---------------------------+-------
 Chapeau vétiver           |     ∅
 Bon cadeau 50 €           |     ∅
 Curcuma de La Plaine 100g |     ∅
 Gelée de goyave 220g      |     ∅
 Coffret prestige rhums    | 48.00
```

Les « 5 meilleures marges » commencent par 4 marges **inconnues** ! En PostgreSQL,
NULL est considéré comme **plus grand** que toute valeur : il arrive en dernier
avec `ASC` et **en premier avec `DESC`**. Aucune erreur, résultat faux. Deux
corrections possibles :

```sql
ORDER BY marge DESC NULLS LAST      -- garde les NULL, mais à la fin
-- ou
WHERE cout_achat IS NOT NULL        -- exclut les marges inconnues
```

🔁 **Et dans BigQuery ?** C'est l'inverse : les NULL arrivent en premier avec
`ASC` et en dernier avec `DESC`. Encore un comportement qui change d'un moteur à
l'autre. Le réflexe sûr : écrire `NULLS FIRST` / `NULLS LAST` explicitement dès
que la colonne peut être NULL.

💡 **Le savais-tu ?** Dans `ORDER BY`, un alias ne fonctionne que **seul**.
`ORDER BY marge + 1` échoue avec `column "marge" does not exist`, alors que
`ORDER BY marge` fonctionne. C'est une règle historique du standard SQL.

### Conséquence 3 : on ne peut pas filtrer un agrégat dans le WHERE

```sql
SELECT categorie_id, count(*)
FROM produits
WHERE count(*) > 5
GROUP BY categorie_id;
```

```
ERROR:  aggregate functions are not allowed in WHERE
```

Le `WHERE` filtre des **lignes** individuelles, **avant** le regroupement (étape 2).
À ce moment-là, aucun groupe n'existe encore, donc rien à compter. C'est
exactement pour ça que `HAVING` existe : il filtre **après** le `GROUP BY`
(étape 4). Module 3.

### Conséquence 4 : `LIMIT` est la toute dernière étape

`LIMIT 3` ne veut pas dire « ne lis que 3 lignes ». Toute la requête est
calculée (filtres, regroupements, tri), et **ensuite** on garde les 3 premières.
Un `LIMIT` sur une requête lourde reste une requête lourde (avec des nuances que
le module Performance expliquera).

### 🧠 Sous le capot : ordre logique ≠ ordre physique

Cet ordre est l'ordre **logique** : il définit le **sens** de la requête, donc ce
qui est autorisé et ce qui ne l'est pas. Physiquement, l'optimiseur de PostgreSQL
réorganise librement le travail tant que le résultat est identique : il peut
appliquer un filtre du `WHERE` pendant la lecture de la table, ou choisir l'ordre
des jointures. Pour **lire et écrire** une requête, raisonne toujours avec l'ordre
logique. Pour la **performance**, on regardera l'ordre physique avec `EXPLAIN`.

💡 **Le savais-tu ?** PostgreSQL accepte un alias du SELECT dans le `GROUP BY`
(`GROUP BY cat` avec `categorie_id AS cat`), ce qui contredit l'ordre logique.
C'est une **extension** de PostgreSQL, pratique mais non standard. Pour garder des
réflexes portables, préfère regrouper sur l'expression d'origine.

---

## 0.9 La méthode de lecture

Voici la méthode qui va te servir pour **toute** requête, du `SELECT` de 3 lignes
au modèle dbt de 200 lignes.

> **Règle d'or : on ne lit pas une requête de haut en bas.
> On la lit dans l'ordre d'exécution, en suivant le grain.**

### Les 7 questions

| Étape | Clause | La question à te poser |
|---|---|---|
| 1 | `FROM` / `JOIN` | D'où viennent les données ? **Une ligne = quoi ?** Combien de lignes environ ? |
| 2 | `WHERE` | Quelles lignes sont éliminées ? Le grain ne change pas, seul le nombre baisse. |
| 3 | `GROUP BY` | **Une ligne = quoi, maintenant ?** (le grain devient la liste des colonnes du GROUP BY) |
| 4 | `HAVING` | Quels groupes sont éliminés ? |
| 5 | `SELECT` | Quelles colonnes sont calculées ? Chaque agrégat porte sur quoi ? |
| 6 | `DISTINCT` | Des doublons sont-ils retirés ? Pourquoi y en aurait-il ? |
| 7 | `ORDER BY` / `LIMIT` | Comment le résultat est-il présenté et tronqué ? |

Et la question qui débloque presque tout : **« à cette étape, une ligne = quoi ? »**

### Exemple guidé, étape par étape

Voici une requête de taille réelle. Ne cherche pas à la comprendre d'un bloc :
on va la lire.

```sql
SELECT
    m.nom                                    AS magasin,
    count(DISTINCT cmd.commande_id)          AS nb_commandes,
    sum(lc.quantite * lc.prix_unitaire)      AS chiffre_affaires
FROM commandes AS cmd
JOIN magasins AS m
    ON m.magasin_id = cmd.magasin_id
JOIN lignes_commande AS lc
    ON lc.commande_id = cmd.commande_id
WHERE cmd.statut = 'livree'
  AND cmd.date_commande >= '2025-01-01'
GROUP BY m.nom
HAVING sum(lc.quantite * lc.prix_unitaire) > 11000
ORDER BY chiffre_affaires DESC
LIMIT 3;
```

Tu ne connais pas encore les `JOIN` en détail (module 4). Ce n'est pas grave :
retiens simplement qu'un `JOIN` **colle** les lignes d'une autre table à côté des
lignes existantes, selon la condition du `ON`.

**Étape 1 : FROM / JOIN, d'où viennent les données ?**

- `FROM commandes AS cmd` : on part des commandes. **Une ligne = une commande.**
  1 500 lignes.
- `JOIN magasins AS m ON ...` : on colle à chaque commande les infos de son magasin.
  Une commande n'a qu'un magasin, donc le grain ne change pas : **une ligne = une
  commande**, avec son magasin. Mais les commandes en ligne (`magasin_id` NULL)
  n'ont pas de magasin correspondant : elles disparaissent. Il reste 1 125 lignes.
- `JOIN lignes_commande AS lc ON ...` : on colle à chaque commande **ses** lignes de
  détail. Une commande de 4 produits devient **4 lignes**. Le grain change :
  **une ligne = un produit dans une commande en magasin**. On passe à 3 376 lignes.

Voici à quoi ressemble ce tableau intermédiaire (quelques colonnes) :

```
 commande_id |         nom          | statut |     date_commande      | produit_id | quantite | prix_unitaire
-------------+----------------------+--------+------------------------+------------+----------+---------------
           3 | Kaz Péi Est          | livree | 2025-03-12 14:33:00+04 |         13 |        5 |          9.90
           3 | Kaz Péi Est          | livree | 2025-03-12 14:33:00+04 |         30 |        1 |         22.00
           3 | Kaz Péi Est          | livree | 2025-03-12 14:33:00+04 |          9 |        2 |          7.90
           3 | Kaz Péi Est          | livree | 2025-03-12 14:33:00+04 |         26 |        3 |         35.00
           5 | Kaz Péi Front de mer | livree | 2025-04-28 18:55:00+04 |         35 |        2 |         19.90
```

Regarde : la commande 3 apparaît **4 fois**. Garde ça en tête pour l'étape 5.

**Étape 2 : WHERE, quelles lignes sont éliminées ?**

On garde les lignes des commandes livrées, passées depuis le 1er janvier 2025.
Le grain ne change pas (toujours un produit dans une commande). Il reste
1 530 lignes.

**Étape 3 : GROUP BY, une ligne = quoi, maintenant ?**

`GROUP BY m.nom` : toutes les lignes d'un même magasin sont rassemblées en une
seule. **Une ligne = un magasin.** Il reste 6 lignes, une par magasin.

**Étape 4 : HAVING, quels groupes sont éliminés ?**

On ne garde que les magasins dont le chiffre d'affaires dépasse 11 000 €. Deux
magasins sont éliminés, il en reste 4.

**Étape 5 : SELECT, quelles colonnes sont calculées ?**

- `m.nom` : le nom du magasin (c'est la colonne du regroupement).
- `sum(lc.quantite * lc.prix_unitaire)` : pour chaque magasin, on additionne le
  montant de **chaque ligne de détail**. C'est juste, parce que le grain avant le
  regroupement était « un produit dans une commande ».
- `count(DISTINCT cmd.commande_id)` : pourquoi `DISTINCT` ? Parce que la commande 3
  apparaît 4 fois (étape 1). Un `count(*)` compterait des **lignes de détail**, pas
  des commandes. Démonstration :

```
       magasin        | count(*) | count(DISTINCT commande_id)
----------------------+----------+-----------------------------
 Kaz Péi Barachois    |      345 |                         116
 Kaz Péi Est          |      340 |                         115
```

Avec `count(*)`, on annoncerait 345 commandes au lieu de 116 : **trois fois trop**,
sans aucun message d'erreur. Voilà le bug silencieux typique d'un changement de
grain qu'on n'a pas vu.

**Étape 6 : DISTINCT**, pas de `SELECT DISTINCT` ici, on passe.

**Étape 7 : ORDER BY / LIMIT**

On trie par chiffre d'affaires décroissant, et on garde les 3 premiers.

**Traduction en français** : « Les 3 magasins qui ont fait le plus gros chiffre
d'affaires sur les commandes livrées depuis début 2025, parmi ceux qui ont
dépassé 11 000 €, avec leur nombre de commandes. »

```
       magasin        | nb_commandes | chiffre_affaires
----------------------+--------------+------------------
 Kaz Péi Barachois    |          116 |         22758.83
 Kaz Péi Est          |          115 |         21879.40
 Kaz Péi Front de mer |          114 |         21167.00
```

💡 **Le savais-tu ?** Une lecture attentive révèle aussi ce que la requête **ne
fait pas** : ce chiffre d'affaires ignore la colonne `remise_pct`. Est-ce voulu ?
C'est exactement le type de question qu'un bon relecteur pose. Lire une requête,
ce n'est pas seulement comprendre ce qu'elle fait, c'est aussi vérifier qu'elle
fait **ce qu'on croit**.

### Technique 1 : l'exécution progressive

Quand une requête te résiste, **reconstruis-la morceau par morceau** dans psql, en
suivant l'ordre d'exécution :

```sql
-- 1. Seulement la source, pour voir le grain
SELECT * FROM commandes AS cmd
JOIN magasins AS m ON m.magasin_id = cmd.magasin_id
JOIN lignes_commande AS lc ON lc.commande_id = cmd.commande_id
LIMIT 20;

-- 2. Combien de lignes à cette étape ?
SELECT count(*) FROM commandes AS cmd
JOIN magasins AS m ON m.magasin_id = cmd.magasin_id
JOIN lignes_commande AS lc ON lc.commande_id = cmd.commande_id;

-- 3. On ajoute le WHERE, on recompte...
-- 4. On ajoute le GROUP BY...
```

À chaque étape, tu **vois** le grain et le nombre de lignes. C'est la technique la
plus efficace pour comprendre, et pour déboguer.

### Technique 2 : annoter le grain en commentaire

Quand tu lis (ou écris) une requête complexe, note le grain à chaque étape :

```sql
SELECT ...
FROM commandes AS cmd                                  -- grain : 1 commande
JOIN magasins AS m ON ...                              -- grain : 1 commande (+ son magasin), commandes en ligne exclues
JOIN lignes_commande AS lc ON ...                      -- grain : 1 produit dans 1 commande ⚠️
WHERE ...                                              -- même grain, moins de lignes
GROUP BY m.nom                                         -- grain : 1 magasin
```

Le ⚠️ marque l'endroit où le grain devient plus fin : c'est là que les
`count(*)` et les `sum(...)` sur des colonnes de l'en-tête deviennent dangereux.

### Technique 3 : lire une CTE

Une CTE (Common Table Expression) est une requête nommée, définie avec `WITH`, que
la requête principale utilise comme une table. On les verra en détail au
module 5, mais voici déjà comment les lire :

```sql
WITH ventes_par_produit AS (            -- bloc 1 : lis-le comme une table à part
    SELECT produit_id,
           sum(quantite) AS qte_vendue
    FROM lignes_commande                --   grain d'entrée : 1 produit dans 1 commande
    GROUP BY produit_id                 --   grain de sortie : 1 produit
)
SELECT p.nom, v.qte_vendue              -- requête principale
FROM ventes_par_produit AS v            --   grain : 1 produit (la CTE)
JOIN produits AS p
    ON p.produit_id = v.produit_id      --   grain inchangé : 1 produit + ses infos
ORDER BY v.qte_vendue DESC;
```

**Méthode** : lis chaque bloc `WITH` **de haut en bas**, comme une table
intermédiaire indépendante, en notant son grain de sortie. Puis lis la requête
principale en remplaçant mentalement le nom de la CTE par « la table qui contient
1 ligne par… ».

### Technique 4 : lire une sous-requête

Une sous-requête est une requête entre parenthèses à l'intérieur d'une autre.
**On la lit de l'intérieur vers l'extérieur** : d'abord la plus imbriquée, puis
celle qui l'entoure.

```sql
SELECT nom, prix_unitaire
FROM produits
WHERE prix_unitaire > (                  -- 2. puis : les produits plus chers que ça
    SELECT avg(prix_unitaire)            -- 1. d'abord : le prix moyen (une seule valeur)
    FROM produits
);
```

---

## 0.10 Guillemets simples, guillemets doubles

En SQL, les deux types de guillemets n'ont **pas du tout** le même sens.

| Guillemets | Désignent | Exemple |
|---|---|---|
| `'simples'` | Une **valeur** (texte, date) | `WHERE commune = 'Saint-Denis'` |
| `"doubles"` | Un **identifiant** (nom de table ou de colonne) | `SELECT "Nom Bizarre" FROM ...` |

⚠️ **Piège** : si tu viens de Python ou de JavaScript, tu as le réflexe des
guillemets doubles pour le texte. En SQL, ça donne :

```sql
SELECT count(*) FROM clients WHERE commune = "Saint-Denis";
```

```
ERROR:  column "Saint-Denis" does not exist
```

PostgreSQL a cherché une **colonne** nommée `Saint-Denis`.

💡 **Le savais-tu ?** Pour mettre une apostrophe dans un texte, on la **double** :
`'L''Étang-Salé'`. Ce sont deux apostrophes simples, pas un guillemet double.

🧠 **Sous le capot** : PostgreSQL convertit en **minuscules** tous les
identifiants sans guillemets. `SELECT NOM FROM PRODUITS` fonctionne, car il lit
`nom` et `produits`. Mais si une table a été créée avec des guillemets et des
majuscules (`CREATE TABLE "Clients"`), tu devras **toujours** écrire `"Clients"`
avec les guillemets. C'est pour ça qu'on nomme tout en minuscules et en
`snake_case`.

### La casse des valeurs, elle, compte

Les **identifiants** sont insensibles à la casse (sans guillemets), mais les
**valeurs** texte sont **sensibles à la casse** :

```sql
SELECT count(*) FROM clients WHERE commune = 'Saint-Denis';         -- 7
SELECT count(*) FROM clients WHERE lower(commune) = 'saint-denis';  -- 12
```

`lower()` récupère `SAINT-DENIS` et `saint-denis`. Mais pas `'Saint-Denis '` (avec
une espace finale) ni `'St-Denis'`. Le nettoyage des textes est un vrai sujet, qu'on
traitera en détail au module 2 (et on verra pourquoi `lower()` dans un `WHERE` peut
ralentir une requête sur une grosse table).

🔁 **Et dans BigQuery ?** Les identifiants s'entourent de **backticks**
(`` `projet.dataset.table` ``), pas de guillemets doubles. Les comparaisons de
texte sont aussi sensibles à la casse.

---

## 0.11 Écrire du SQL lisible

Le SQL est lu bien plus souvent qu'il n'est écrit. Une requête lisible est une
requête **qu'on peut lire avec la méthode** : chaque clause est visible d'un coup
d'œil.

**Avant** :

```sql
select m.nom,count(distinct c.commande_id) n,sum(l.quantite*l.prix_unitaire) ca from commandes c join magasins m on m.magasin_id=c.magasin_id join lignes_commande l on l.commande_id=c.commande_id where c.statut='livree' group by m.nom order by ca desc;
```

**Après** :

```sql
SELECT
    m.nom                                AS magasin,
    count(DISTINCT cmd.commande_id)      AS nb_commandes,
    sum(lc.quantite * lc.prix_unitaire)  AS chiffre_affaires
FROM commandes AS cmd
JOIN magasins AS m
    ON m.magasin_id = cmd.magasin_id
JOIN lignes_commande AS lc
    ON lc.commande_id = cmd.commande_id
WHERE cmd.statut = 'livree'
GROUP BY m.nom
ORDER BY chiffre_affaires DESC;
```

Les conventions du cours :

1. **Mots-clés en MAJUSCULES**, noms de tables et colonnes en minuscules.
2. **Une clause par ligne**, en début de ligne : l'œil repère `FROM`, `WHERE`,
   `GROUP BY` immédiatement.
3. **Une colonne par ligne** dans le `SELECT` dès qu'il y en a plus de deux.
4. **Indentation** de 4 espaces pour ce qui appartient à une clause.
5. **Alias de tables parlants** : `cmd`, `lc`, `m` plutôt que `a`, `b`, `c`.
   Évite `c` pour commandes alors que `clients` existe aussi : c'est une source de
   confusion garantie.
6. **Alias explicites** pour chaque colonne calculée, avec `AS`.
7. **Commentaires** : `-- une ligne` ou `/* plusieurs lignes */`. Explique le
   **pourquoi** (« on exclut les annulées car elles ne génèrent pas de CA »), pas
   le **quoi** (« on filtre sur le statut »).

💡 **Le savais-tu ?** Certaines équipes mettent les virgules **en début de ligne**
(`, count(*) AS nb`). Avantage : on peut commenter n'importe quelle colonne sauf la
première sans casser la requête. Les deux styles sont valables ; l'important est
d'être cohérent dans une même base de code. Côté outillage, l'outil `sqlfluff`
(utilisé avec dbt) peut formater et vérifier ton style automatiquement.

---

## 0.12 À retenir

- [ ] Je sais me connecter avec psql, et j'utilise `\d table` avant d'écrire une requête.
- [ ] J'affiche les NULL avec `\pset null '∅'`.
- [ ] Je sais dire le **grain** de chaque table du dataset.
- [ ] Je connais la différence entre clé primaire et clé étrangère.
- [ ] J'utilise `numeric` pour l'argent, jamais `double precision`.
- [ ] Je sais que NULL ≠ 0 ≠ `''`, qu'un calcul avec NULL donne NULL, et qu'on
      teste avec `IS NULL`.
- [ ] Je me méfie de la **division entière** (`5 / 2 = 2`).
- [ ] Je connais l'**ordre logique d'exécution** par cœur et je sais expliquer
      pourquoi un alias ne marche pas dans le `WHERE`.
- [ ] Je sais que les NULL arrivent **en premier** avec `ORDER BY ... DESC`.
- [ ] Je lis une requête avec la méthode des 7 questions en suivant le grain.
- [ ] Je ne confonds plus `'valeur'` et `"identifiant"`.

---

## Exercices

Les exercices sont dans `exercices/module-00/`. Fais-les **dans l'ordre**.

| Fichier | Type | Ce que tu fais |
|---|---|---|
| `01_explorer.sql` | Explorer | Découvrir le dataset avec psql |
| `02_lire_predire.sql` | 👁️ Lire / prédire | Écrire ta prédiction **avant** d'exécuter |
| `03_deboguer.sql` | 🐛 Déboguer | Trouver et corriger l'erreur |
| `04_ecrire.sql` | ✍️ Écrire | Écrire la requête à partir d'une question |
| `05_reecrire.sql` | 🔄 Réécrire | Rendre une requête lisible et l'annoter |

Pour vérifier un exercice qui a un identifiant (`m00-d1`, `m00-e1`…) :

```sql
SELECT outils.verifier('m00-e1', $q$
    SELECT ... ta requête ...
$q$);
```

Bloqué ? Lance OpenCode dans le dossier du cours, choisis l'agent **prof-sql**
(touche Tab), et montre-lui ton fichier. Il te guidera sans te donner la réponse.
