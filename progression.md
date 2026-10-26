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

## Notions fragiles à revoir

- **Schéma / base / table** : premier contact le 27/10, la distinction n'est pas encore solide.
  À revoir avec des exemples concrets (`boutique.clients` contre `outils.attendus`).
- **Catalogues système** (`pg_class`, `oid`, `relkind`) : hors programme pour l'instant.
  Le but n'est pas de les connaître, seulement de savoir qu'ils existent et que `psql` les interroge pour toi (`\dt`, `\d`).
- **La question réflexe** « à cette étape, une ligne = quoi ? » : à automatiser, c'est l'objectif n°1 du module 0.

## Prédictions ratées (et ce qui m'a surpris)

## Journal des sessions

### 2026-10-27 — session 0 : mise en route

- Projet initialisé et vérifié : PostgreSQL 17, conteneur `healthy`, dataset Kaz Péi chargé.
- Commit initial du dépôt (18 fichiers).
- Vu en session : `docker compose up -d` / `exec`, décomposition du `docker-compose.yml`,
  les schémas `boutique` / `outils` / `public`, la notation `schéma.objet`.
- Exercices : aucun commencé. Q1 à Q3 de `01_explorer.sql` restent à faire.
- Prochaine session : fiche **0.1 → 0.4**, puis Q1, Q2, Q3 de `01_explorer.sql`.
  Rythme : 4 h/jour, 14 jours, entretien data engineer junior au bout.
