#!/bin/bash
# Charge les empreintes de vérification de tous les modules présents
# dans /exercices (monté depuis ./exercices par docker-compose.yml).
# Exécuté automatiquement au PREMIER démarrage du conteneur.
set -e
for f in /exercices/module-*/attendus.sql; do
    [ -f "$f" ] || continue
    echo "Chargement des attendus : $f"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -q -f "$f"
done
