# Cours SQL PostgreSQL — contexte du projet

## Le projet

Un cours de SQL complet, module par module, sur **PostgreSQL 17**. Il s'adresse à
toute personne qui veut passer de « savoir » à « comprendre » le SQL, avec un
accent particulier sur **la lecture de requêtes complexes**.

Pour chaque notion, le cours explique **pourquoi** on l'utilise, **quand**
l'utiliser, **quand ne pas** l'utiliser, et tous les petits détails qui font la
différence (casse, NULL, types, arrondis, etc.).

## Organisation du dépôt

```
cours-sql/
├── docker-compose.yml        PostgreSQL 17 (conteneur cours-sql-db, port machine 5433)
├── AGENTS.md                 ce fichier
├── .opencode/agents/         l'agent professeur (prof-sql)
├── data/init/                scripts exécutés au 1er démarrage du conteneur
│   ├── 01_schema.sql         schéma « boutique » (dataset fil rouge Kaz Péi)
│   ├── 02_donnees.sql        données (déterministes, avec pièges volontaires)
│   ├── 03_outils.sql         fonctions de vérification des exercices
│   └── 04_attendus.sh        charge les attendus.sql de tous les modules
├── fiches/                   une fiche de cours Markdown par module
├── exercices/module-XX/      les fichiers .sql d'exercices que l'apprenant remplit
└── progression.md            journal de progression tenu par l'agent professeur
```

## Base de données

- Base `cours_sql`, utilisateur `eleve`, mot de passe `eleve`.
- Le `search_path` est réglé sur `boutique, public` : on écrit `FROM clients`.
- Fuseau horaire de la base : `Indian/Reunion` (UTC+4).
- Tables : `magasins`, `clients`, `categories`, `produits`, `commandes`, `lignes_commande`.
- Les données contiennent des défauts **volontaires** (NULL, doublons, casse
  incohérente, espaces en trop, chaîne vide vs NULL, produits jamais vendus,
  clients sans commande). Ne jamais les « corriger » : ce sont des terrains
  d'entraînement.

## Commandes utiles

```bash
docker compose up -d                                   # démarrer
docker compose exec db psql -U eleve -d cours_sql      # console interactive
docker compose exec -T db psql -U eleve -d cours_sql -c "SELECT 1;"   # une requête
docker compose exec -T db psql -U eleve -d cours_sql -f /exercices/module-01/attendus.sql  # charger les attendus d'un module ajouté après le 1er démarrage
docker compose down -v && docker compose up -d         # tout réinitialiser
```

## Vérification des exercices

Les solutions ne sont **jamais** stockées en clair. Chaque module fournit un
fichier `exercices/module-XX/attendus.sql` qui enregistre une empreinte (hash)
du résultat attendu. Ces fichiers sont chargés automatiquement au premier
démarrage du conteneur. On vérifie une réponse avec :

```sql
SELECT outils.verifier('m00-e01', $q$ SELECT ... $q$);
```

## Conventions SQL du cours

- Mots-clés en MAJUSCULES, identifiants en minuscules (`snake_case`).
- Une clause par ligne, indentation de 4 espaces.
- Alias de tables courts et explicites (`c` pour clients, `cmd` pour commandes).
- Commentaires `--` pour expliquer le **pourquoi**, pas le **quoi**.
- Questions d'exercices écrites en commentaires `--` (copier-coller direct).
- Tout acronyme est défini en anglais à sa première apparition
  (ex. CTE = Common Table Expression).
