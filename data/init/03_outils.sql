-- =============================================================================
-- Outils de vérification des exercices
--
-- Principe : pour chaque exercice d'écriture, on stocke uniquement une
-- EMPREINTE (hash) du résultat attendu, jamais la requête-solution.
-- On peut donc vérifier une réponse sans pouvoir lire la solution.
--
-- Utilisation (dans psql) :
--   SELECT outils.verifier('m00-e01', $q$
--       SELECT ... ta requête ...
--   $q$);
--
-- $q$ ... $q$ est une « chaîne dollar-quotée » PostgreSQL : tout ce qui est
-- entre les deux balises est du texte brut, apostrophes comprises. Pratique
-- pour passer une requête entière en paramètre sans échapper les ' .
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS outils;

CREATE TABLE IF NOT EXISTS outils.attendus (
    exercice_id  text PRIMARY KEY,   -- ex. 'm00-e01'
    nb_lignes    bigint NOT NULL,
    empreinte    text   NOT NULL,    -- md5 du résultat, indépendant de l'ordre des lignes
    consigne     text                -- rappel court de la consigne
);

-- Calcule l'empreinte d'un résultat de requête.
-- L'ordre des LIGNES n'a pas d'importance, l'ordre et le format des COLONNES oui.
-- COLLATE "C" : tri octet par octet, identique quelle que soit la langue
-- configurée sur le serveur (sinon le hash changerait d'une machine à l'autre).
CREATE OR REPLACE FUNCTION outils.empreinte(requete text,
                                            OUT nb_lignes bigint,
                                            OUT empreinte text)
LANGUAGE plpgsql AS $$
BEGIN
    EXECUTE format(
        'SELECT count(*), md5(coalesce(string_agg(t::text, %L ORDER BY t::text COLLATE "C"), %L)) FROM (%s) AS t',
        E'\n', '', rtrim(btrim(requete), ';' || E' \n\t')
    ) INTO nb_lignes, empreinte;
END;
$$;

-- Compare le résultat d'une requête à l'attendu d'un exercice.
CREATE OR REPLACE FUNCTION outils.verifier(p_exercice_id text, requete text)
RETURNS text
LANGUAGE plpgsql AS $$
DECLARE
    a outils.attendus%ROWTYPE;
    r record;
BEGIN
    SELECT * INTO a FROM outils.attendus WHERE exercice_id = p_exercice_id;
    IF NOT FOUND THEN
        RETURN '⚠️ Exercice inconnu : ' || p_exercice_id
            || ' (as-tu chargé le fichier attendus.sql du module ?)';
    END IF;

    SELECT * INTO r FROM outils.empreinte(requete);

    IF r.empreinte = a.empreinte THEN
        RETURN '✅ Correct (' || r.nb_lignes || ' lignes)';
    ELSIF r.nb_lignes <> a.nb_lignes THEN
        RETURN '❌ Pas encore : ta requête renvoie ' || r.nb_lignes
            || ' ligne(s), il en faut ' || a.nb_lignes || '.';
    ELSE
        RETURN '❌ Pas encore : le bon nombre de lignes (' || r.nb_lignes
            || ') mais le contenu diffère. Vérifie l''ordre des colonnes, '
            || 'les arrondis, les NULL et le filtre.';
    END IF;
END;
$$;

-- Petit utilitaire pour l'auteur du cours : enregistre l'attendu à partir
-- d'une requête de référence (utilisé pour générer les fichiers attendus.sql).
CREATE OR REPLACE FUNCTION outils.enregistrer(p_exercice_id text, p_consigne text, requete text)
RETURNS void
LANGUAGE plpgsql AS $$
DECLARE r record;
BEGIN
    SELECT * INTO r FROM outils.empreinte(requete);
    INSERT INTO outils.attendus VALUES (p_exercice_id, r.nb_lignes, r.empreinte, p_consigne)
    ON CONFLICT (exercice_id) DO UPDATE
       SET nb_lignes = EXCLUDED.nb_lignes,
           empreinte = EXCLUDED.empreinte,
           consigne  = EXCLUDED.consigne;
END;
$$;
