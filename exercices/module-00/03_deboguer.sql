-- =============================================================================
-- Module 0 — Exercice 03 : déboguer
-- Type : 🐛 Déboguer
--
-- Chaque requête ci-dessous est fausse. Certaines provoquent une erreur,
-- d'autres renvoient un résultat faux SANS erreur (les plus dangereuses).
--
-- Pour chacune :
--   1. Exécute-la et lis le message d'erreur (ou le résultat) EN ENTIER.
--   2. Explique en commentaire la cause, en t'appuyant sur l'ordre
--      d'exécution ou les règles du NULL.
--   3. Écris la version corrigée, en gardant EXACTEMENT les colonnes demandées,
--      dans le même ordre.
--   4. Vérifie avec outils.verifier('m00-dX', $q$ ... $q$);
-- =============================================================================


-- -----------------------------------------------------------------------------
-- m00-d1 : les produits dont la marge dépasse 20 €
-- Colonnes attendues : nom, marge
-- -----------------------------------------------------------------------------
SELECT
    nom,
    prix_unitaire - cout_achat AS marge
FROM produits
WHERE marge > 20;

-- Cause :
-- Correction :


-- -----------------------------------------------------------------------------
-- m00-d2 : les clients habitant « Le Tampon » (écrit exactement ainsi)
-- Colonnes attendues : client_id, prenom, nom
-- -----------------------------------------------------------------------------
SELECT
    client_id,
    prenom,
    nom
FROM clients
WHERE commune = "Le Tampon";

-- Cause :
-- Correction :


-- -----------------------------------------------------------------------------
-- m00-d3 : les produits dont le coût d'achat est inconnu
-- Colonnes attendues : produit_id, nom
-- -----------------------------------------------------------------------------
SELECT
    produit_id,
    nom
FROM produits
WHERE cout_achat = NULL;

-- Cause (attention : pas d'erreur ici !) :
-- Correction :


-- -----------------------------------------------------------------------------
-- m00-d4 : les catégories qui contiennent plus de 5 produits
-- Colonnes attendues : categorie_id, nb_produits
-- -----------------------------------------------------------------------------
SELECT
    categorie_id,
    count(*) AS nb_produits
FROM produits
WHERE count(*) > 5
GROUP BY categorie_id;

-- Cause :
-- Correction (indice : la fiche nomme la clause qui filtre les groupes,
-- même si on ne la détaille qu'au module 3) :


-- -----------------------------------------------------------------------------
-- m00-d5 : la commande 42 contient 11 articles au total. Pour chacune de ses
-- lignes, on veut la part (en %) que représente la quantité, arrondie à
-- 1 décimale.
-- Colonnes attendues : ligne_id, quantite, part_pct
-- Résultat attendu pour la ligne 103 (quantité 4) : 36.4
-- -----------------------------------------------------------------------------
SELECT
    ligne_id,
    quantite,
    round(quantite * 100 / 11, 1) AS part_pct
FROM lignes_commande
WHERE commande_id = 42;

-- Cause (pas d'erreur ici non plus) :
-- Correction :


-- -----------------------------------------------------------------------------
-- m00-d6 : les 3 produits qui ont la plus grosse marge connue
-- Colonnes attendues : nom, marge
-- -----------------------------------------------------------------------------
SELECT
    nom,
    prix_unitaire - cout_achat AS marge
FROM produits
ORDER BY marge DESC
LIMIT 3;

-- Cause :
-- Correction (il existe deux corrections possibles, trouve les deux) :


-- -----------------------------------------------------------------------------
-- m00-d7 : la liste des produits avec leur prix
-- Colonnes attendues : nom, prix_unitaire
-- -----------------------------------------------------------------------------
SELECT
    nom
    prix_unitaire
FROM produits;

-- La requête s'exécute sans erreur. Que renvoie-t-elle vraiment ?
-- Cause :
-- Correction :
