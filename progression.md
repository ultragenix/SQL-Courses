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
| `02_lire_predire.sql` | à faire | — | prochain. Prédiction écrite **avant** exécution, non négociable |
| `03_deboguer.sql` | à faire | — | |
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

## Journal des sessions

### 2026-11-02 — session 1 : module 0, exploration

- Conteneur relancé (`healthy`), base `cours_sql`, `search_path` = `boutique, public`.
- Notions vues : schéma vs table vs base, `search_path` et résolution des noms,
  le schéma `public` (et le pseudo-rôle `PUBLIC`, homonyme), `\dt` = requête sur
  `pg_class` filtrée par `current_schemas()`, `\d`/`\dv` et le masquage de
  `pg_catalog`/`information_schema`, grain, PK/FK, FK auto-référente.
- `01_explorer.sql` : Q1 à Q9 validées. Aides : 🟡 sur Q3, Q5, Q7.
  Commit `0151734`.
- Drill : trois requêtes de contrôle qualité écrites seul, justes.
- Point d'arrêt : mise au propre du 01 en attente (section de synthèse en fin de
  fichier), puis `02_lire_predire.sql`.
- Prochaine session : `02_lire_predire.sql`, prédiction écrite avant exécution.
  Puis `03_deboguer.sql`. Si le temps le permet, revoir NULL vs `''` vs `0` en écriture.

### 2026-10-27 — session 0 : mise en route

- Projet initialisé et vérifié : PostgreSQL 17, conteneur `healthy`, dataset Kaz Péi chargé.
- Commit initial du dépôt (18 fichiers).
- Vu en session : `docker compose up -d` / `exec`, décomposition du `docker-compose.yml`,
  les schémas `boutique` / `outils` / `public`, la notation `schéma.objet`.
- Exercices : aucun commencé. Q1 à Q3 de `01_explorer.sql` restent à faire.
- Prochaine session : fiche **0.1 → 0.4**, puis Q1, Q2, Q3 de `01_explorer.sql`.
  Rythme : 4 h/jour, 14 jours, entretien data engineer junior au bout.
