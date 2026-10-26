-- =============================================================================
-- Module 0 — Exercice 02 : lire et prédire
-- Type : 👁️ Lire / prédire
--
-- RÈGLE : pour chaque requête, écris D'ABORD ta prédiction en commentaire,
-- ENSUITE seulement exécute-la. Ne triche pas : l'écart entre ta prédiction
-- et le résultat réel, c'est exactement là que tu apprends.
--
-- Pour chaque requête, applique la méthode de lecture (fiche, section 0.9) :
-- lis dans l'ordre d'exécution et note le grain à chaque étape.
--
-- Format de prédiction attendu :
--   -- En français : (ce que fait la requête, en une phrase)
--   -- Grain final : une ligne = ...
--   -- Nombre de lignes prédit : ...
--   -- Première ligne prédite : ...
--   -- Résultat réel : ...
--   -- Ce qui m'a surpris : ...
-- =============================================================================


-- -----------------------------------------------------------------------------
-- L1
-- -----------------------------------------------------------------------------
SELECT
    nom,
    prix_unitaire * 2 AS prix_double
FROM produits
WHERE prix_unitaire > 40
ORDER BY prix_double;

-- En français :
-- Grain final :
-- Nombre de lignes prédit :
-- Première ligne prédite :
-- Résultat réel :
-- Ce qui m'a surpris :
-- Question bonus : deux produits ont le même prix_double. Leur ordre
-- respectif est-il garanti ? Pourquoi ?


-- -----------------------------------------------------------------------------
-- L2
-- -----------------------------------------------------------------------------
SELECT
    7 / 2      AS a,
    7 / 2.0    AS b,
    7 % 2      AS c,
    -7 / 2     AS d,
    7 / 2 * 2  AS e;

-- Prédis la valeur de chacune des 5 colonnes :
-- a =
-- b =
-- c =
-- d =
-- e =
-- Résultat réel :
-- Ce qui m'a surpris :


-- -----------------------------------------------------------------------------
-- L3
-- -----------------------------------------------------------------------------
SELECT count(*)
FROM clients
WHERE email = NULL;

-- Nombre prédit :
-- Résultat réel :
-- Pourquoi :
-- Réécris la condition pour compter les clients SANS email (NULL) :
-- Combien de clients ont un email vide '' ? Ce nombre est-il inclus
-- dans ta réponse précédente ?


-- -----------------------------------------------------------------------------
-- L4
-- -----------------------------------------------------------------------------
SELECT
    nom,
    prix_unitaire - cout_achat AS marge
FROM produits
ORDER BY marge DESC
LIMIT 3;

-- En français :
-- Les 3 lignes prédites :
-- Résultat réel :
-- Ce qui m'a surpris :


-- -----------------------------------------------------------------------------
-- L5
-- -----------------------------------------------------------------------------
SELECT
    count(*)                    AS a,
    count(DISTINCT commande_id) AS b
FROM lignes_commande
WHERE produit_id = 24;

-- Grain de lignes_commande : une ligne = ...
-- a et b seront-ils égaux ? Lequel est le plus grand, et pourquoi ?
-- Prédiction :
-- Résultat réel :
-- Trouve la commande responsable de l'écart (requête libre) :


-- -----------------------------------------------------------------------------
-- L6
-- -----------------------------------------------------------------------------
SELECT
    cmd.statut,
    count(*)                 AS nb,
    sum(cmd.frais_livraison) AS total_frais
FROM commandes AS cmd
WHERE cmd.magasin_id IS NULL
GROUP BY cmd.statut
HAVING count(*) > 20
ORDER BY nb DESC;

-- Étape 1 FROM     — grain : une ligne = ...      nb de lignes ≈ ...
-- Étape 2 WHERE    — qu'est-ce qui est éliminé ?
-- Étape 3 GROUP BY — grain : une ligne = ...
-- Étape 4 HAVING   — qu'est-ce qui est éliminé ?
-- Étape 5 SELECT   — que représente total_frais ?
-- Étape 7 ORDER BY
-- En français :
-- Nombre de lignes prédit :
-- Résultat réel :
-- Question bonus : certaines commandes en ligne ont frais_livraison NULL.
-- sum() les compte-t-il comme 0, les ignore-t-il, ou rend-il tout NULL ?
-- Vérifie avec une requête.


-- -----------------------------------------------------------------------------
-- L7 (CTE)
-- -----------------------------------------------------------------------------
WITH ventes_par_produit AS (
    SELECT
        produit_id,
        sum(quantite) AS qte_vendue
    FROM lignes_commande
    GROUP BY produit_id
)
SELECT
    p.reference,
    p.nom,
    v.qte_vendue
FROM ventes_par_produit AS v
JOIN produits AS p
    ON p.produit_id = v.produit_id
WHERE v.qte_vendue >= 358
ORDER BY v.qte_vendue DESC, p.reference;

-- Bloc WITH         — grain d'entrée : ...   grain de sortie : ...
-- Requête principale — grain : ...
-- Le produit 39 (« Coffret prestige rhums ») peut-il apparaître ? Pourquoi ?
-- En français :
-- Nombre de lignes prédit :
-- Résultat réel :
-- Question bonus : regarde la colonne reference dans le résultat.
-- À quantité égale, le tri secondaire « p.reference » met-il 'P-36'
-- avant ou après 'P-4' ?
-- Pourquoi ?
