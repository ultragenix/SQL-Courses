# Ma progression

> Journal tenu par l'agent prof-sql. Tu peux le lire et l'annoter.

## Mon profil

- Niveau de départ : quelques lignes de SQL déjà écrites, auto-évaluation « gros débutant ».
- Objectif : entretien technique pour un poste de data engineer junior, dans 2 semaines.
- Profil : data engineer junior, lacunes SQL identifiées par lui-même.
- Priorité : savoir **lire** une requête et **expliquer** son résultat (plus utile en entretien que réciter de la syntaxe).

## Plan des 2 semaines

Rythme annoncé par l'apprenant : **4 h/jour, tous les jours, 2 semaines**.
Choix explicite : bases solides plutôt que survol. On termine le module 0
avant d'ouvrir quoi que ce soit d'autre.

Les fiches au-delà du module 0 ne sont pas encore écrites dans le dépôt :
l'apprenant les fournira au fur et à mesure.

| Phase | Jours | Contenu | Statut |
|---|---|---|---|
| 1 | 1-2 | Module 0 en entier : exploration, lecture/prédiction, débogage, écriture, réécriture + méthode de lecture | en cours |
| 2 | 3-11 | Modules complémentaires fournis par l'apprenant, un par un, priorité entretien : agrégats, jointures, NULL, sous-requêtes/CTE | à venir |
| 3 | 12-13 | Lecture de requêtes longues : déroulé à voix haute, grain à chaque étape | à venir |
| 4 | 14 | Révision + simulation d'entretien | à venir |

## Module en cours

Module 0 — Fondations

## Exercices

| Exercice | Statut | Aide utilisée | Remarques |
|---|---|---|---|
| `01_explorer.sql` | ✅ Q1 à Q9 | indices 🟡 sur Q3, Q5, Q7 | commit `0151734`. Q5 : le grain de `lignes_commande` confondu avec l'en-tête de commande → corrigé. Q7 : a d'abord listé des NULL **autorisés** par le schéma au lieu des vraies anomalies |
| `02_lire_predire.sql` | ✅ L1 à L7 | indices 🟡 sur L3 (NULL), L5 (grain), L7 (tri texte) | prédictions écrites avant exécution. Erreurs de raisonnement corrigées : division entière vs PEMDAS (L2), `<> NULL` (L3), `IS NOT NULL` inversé (L3), NULL en tête du `DESC` (L4), grain du `GROUP BY` (L6), `sum()` et les NULL (L6), tri texte `'P-36' < 'P-4'` (L7), produit 39 absent de la CTE (L7) |
| `03_deboguer.sql` | à faire | — | prochain |
| `04_ecrire.sql` | à faire | — | |
| `05_reecrire.sql` | à faire | — | |

Drill hors exercice (02/11) : trois requêtes de contrôle qualité écrites seul, justes
(`btrim`, `= ''`, `IS NULL`) → 1 / 1 / 12. A compris pourquoi `col <> btrim(col)`
ignore les NULL.

## Notions fragiles à revoir

- **Schéma / base / table** : ~~premier contact le 27/10, la distinction n'est pas encore solide.~~
  **Résolu le 02/11** (Q2 juste, reformulation spontanée de la question : « quels schémas sont
  présents dans le `search_path` ? »). Reste à vérifier à l'écrit en situation.
- **Catalogues système** (`pg_class`, `oid`, `relkind`) : hors programme pour l'instant.
  Le but n'est pas de les connaître, seulement de savoir qu'ils existent et que `psql` les interroge pour toi (`\dt`, `\d`).
- **La question réflexe** « à cette étape, une ligne = quoi ? » : à automatiser, c'est l'objectif n°1 du module 0.
  Progrès net sur Q5, mais encore donné après coup plutôt que posé d'emblée.

- **NULL mal cerné** : confond NULL et 0 (`frais_livraison`), et NULL avec chaîne vide `''`.
  Corrigé à l'oral le 02/11, **à revalider par un exercice d'écriture** (module 03/04).
- **Qualité de données** : tendance à traiter une donnée manquante (NULL autorisé par le schéma)
  comme une anomalie. La vraie anomalie est une valeur *présente mais fausse* (casse, espace, `''`).
- **GROUP BY / HAVING** : pas encore vus. Nécessaires pour la détection de doublons.
  Ne pas les supposer acquis.
- **Syntaxe `FILTER (WHERE …)`** : découverte le 02/11, non pratiquée.

## Prédictions ratées (et ce qui m'a surpris)

- **Q6 (02/11)** — prédiction juste : `lignes_commande` > `commandes`, 3751 contre 1500.
  Raisonnement correct (une commande = plusieurs produits). Rien à corriger.
- **Q7 (02/11)** — s'attendait à ne trouver que des doublons. Surprise : les anomalies
  invisibles (espace final, `''` vs NULL, casse) ne se voient pas à l'écran, il a fallu
  `length()`, `btrim()` et des crochets autour de la valeur.
- **Q3 (02/11)** — explication initiale de `frais_livraison` ambiguë (« correspond à un achat
  en magasin ») : décrivait le sens de la colonne, pas celui du NULL.

### Session 2 — prédictions (02/11)

- **L1** : fourchette ~10 vs 7, correcte. Bonus raté : croyait le tri des ex æquo alphabétique ;
  contredit par son propre résultat (`'Café' < 'Panier'` mais Panier sort avant). Notion acquise :
  l'ordre des ex æquo n'est pas garanti, il faut un critère secondaire (`prix_double, nom`).
- **L2** : 5/5 juste. Explication fausse au départ : croyait que SQL ne respecte pas PEMDAS.
  En réalité `/` et `*` sont au même niveau (gauche → droite) ; c'est la division **entière**
  qui tronque vers zéro (`-7/2 = -3`, pas `-4`).
- **L3** : `= NULL` → 0 compris. Mais a écrit `IS NOT NULL` pour compter les clients « sans email »
  (inversion), puis croyait 5 emails vides (en réalité 1). `'' <> NULL` vaut NULL, pas TRUE.
- **L4** : a bien vu que les 3 lignes sont des marges NULL. Avait prédit les 3 vraies meilleures
  marges (48 / 35 / 27) → intuition métier juste, la requête ne répond pas à cette question.
  Notion : `NULLS FIRST` par défaut en DESC, `NULLS LAST` en ASC (PostgreSQL ; MySQL/SQLite/SQL Server inversent).
- **L5** : raisonnement `a > b` juste, chiffres inventés (40/20 au lieu de 119/118). A compris
  `count(*)` vs `count(DISTINCT …)` ; a trouvé seule la commande 42 (deux lignes du produit 24)
  en écrivant `GROUP BY`/`HAVING` sans les avoir vus.
- **L6** : a prédit 5 statuts, en a obtenu 4 (`en_attente` = 16 lignes, éliminé par `HAVING > 20`).
  Objectif de volume non déduit du `HAVING`. A cru que `sum()` comptait les NULL comme 0 ;
  corrigé via `avg` (1185/235 ≠ 1185/260). Tri des ex æquo (trois statuts à 33) non garanti.
- **L7** : a compris le grain de la CTE. N'a pas vu que `reference` est du **texte** :
  `'P-36' < 'P-4'` (comparaison caractère par caractère). Produit 39 : a d'abord répondu par le
  seuil, alors qu'il est absent de la CTE (zéro vente) — distinction `WHERE` (ligne filtrée) vs
  `JOIN` (ligne inexistante).


## Journal des sessions

### 2026-11-02 — session 2 : lecture / prédiction

- `02_lire_predire.sql` : L1 à L7 faites, prédictions écrites avant exécution.
  Aides 🟡 sur L3, L5, L7 ; le reste en autonomie.
- Progrès marquant : a écrit seule `GROUP BY` / `HAVING` en L5 pour trouver la commande 42,
  avant même d'avoir vu L6.
- Fragilités confirmées : distinction NULL / `''` / `0` (L3), volume d'un `HAVING` (L6),
  `sum()` et les NULL (L6), tri **texte** vs tri numérique (L7).
- Prochaine session : `03_deboguer.sql`, puis `04_ecrire.sql` et `05_reecrire.sql`.
  Révision ciblée : `GROUP BY` / `HAVING` / agrégats et NULL (à refaire en écriture seule).

### 2026-11-02 — session 1 : module 0, exploration

- Conteneur relancé (`healthy`), base `cours_sql`, `search_path` = `boutique, public`.
- Notions vues : schéma vs table vs base, `search_path` et résolution des noms,
  le schéma `public` (et le pseudo-rôle `PUBLIC`, homonyme), `\dt` = requête sur
  `pg_class` filtrée par `current_schemas()`, `\d`/`\dv` et le masquage de
  `pg_catalog`/`information_schema`, grain, PK/FK, FK auto-référente.
- `01_explorer.sql` : Q1 à Q9 validées. Aides : 🟡 sur Q3, Q5, Q7.
  Commit `0151734`.
- Drill : trois requêtes de contrôle qualité écrites seul, justes.
- Point d'arrêt : mise au propre du 01 **faite** le 02/11 (section « MISE AU PROPRE »
  en fin de `01_explorer.sql`, 8 points de synthèse), puis `02_lire_predire.sql`.
- Prochaine session : `02_lire_predire.sql`, prédiction écrite avant exécution.
  Puis `03_deboguer.sql`. Si le temps le permet, revoir NULL vs `''` vs `0` en écriture.
- Hors SQL : remote `origin` repassé de HTTPS à SSH le 02/11, push OK.
  Réflexe à garder : `git remote -v` avant de soupçonner les clés.

### 2026-10-27 — session 0 : mise en route

- Projet initialisé et vérifié : PostgreSQL 17, conteneur `healthy`, dataset Kaz Péi chargé.
- Commit initial du dépôt (18 fichiers).
- Vu en session : `docker compose up -d` / `exec`, décomposition du `docker-compose.yml`,
  les schémas `boutique` / `outils` / `public`, la notation `schéma.objet`.
- Exercices : aucun commencé. Q1 à Q3 de `01_explorer.sql` restent à faire.
- Prochaine session : fiche **0.1 → 0.4**, puis Q1, Q2, Q3 de `01_explorer.sql`.
  Rythme : 4 h/jour, 14 jours, entretien data engineer junior au bout.
