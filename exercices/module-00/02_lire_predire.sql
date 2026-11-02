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

-- magasins 6   clients 120   categories 8   produits 40   commandes 1500   lignes_commande 3751

-- -----------------------------------------------------------------------------
-- L1
-- -----------------------------------------------------------------------------
SELECT
    nom,
    prix_unitaire * 2 AS prix_double
FROM produits
WHERE prix_unitaire > 40
ORDER BY prix_double DESC , nom;

-- En français : On va doubler le prix de tout les produis dont le prix unitaire et strictement
--               superieur a 40 et on récupere aussi le nom, le tout dans l'ordre croissant
-- Grain final : une ligne = un produit au prix doublé dont la valeur unitaire > 40
-- Nombre de lignes prédit : (je ne sais aps cb de produit vos plus que 40 je suppose une 10ene)
-- Première ligne prédite : produit_X ; 80
-- Résultat réel : 7 produits selectionné le premier est "Vanille Bourbon 10 gousses |       84.00"
--                 je ne c'est pas comment est choisis il choisis l'ordre si les prix sont 
--                 identiques je suppose que c'est fait en fonction du nombre de char (a confirmé)
-- Ce qui m'a surpris : pourquoi "Panier vacoa grand" est choisis toujours avant 
--                      Café Bourbon pointu 250g alors qu'il on le même prix.
-- Question bonus : deux produits ont le même prix_double. Leur ordre
-- respectif est-il garanti ? Pourquoi ? non garanti, si on veut le guarantir on rajoute le nom dans
-- l'order : ORDER BY prix_double, nom
-- attention : 1. ASC/DESC ne se propage pas. ORDER BY prix_double DESC, nom = prix décroissant, 
--                puis nom croissant (le défaut est ASC). Si tu veux les deux décroissants, 
--                il faut l'écrire deux fois.

--             2. nom n'est pas garanti unique. Deux produits pourraient porter le même nom. 
--                Pour un ordre absolument déterministe, departage avec une colonne unique : 
--                reference (déclarée UNIQUE dans le schéma) ou produit_id (PK).

--             3. Le tri secondaire a un coût : il ne s'applique qu'aux groupes d'ex æquo, 
--                donc il est presque gratuit ici.


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
-- a = 3
-- b = 3.5
-- c = 1
-- d = -3
-- e = 6
-- Résultat réel :  3 | 3.5000000000000000 | 1 | -3 | 6
-- Ce qui m'a surpris : SQL utilise le PEMDAS en mathématiques (attention a la troncature de l'entier)


-- -----------------------------------------------------------------------------
-- L3
-- -----------------------------------------------------------------------------
SELECT count(*)
FROM clients
WHERE email = NULL;

-- Nombre prédit : vide car pas d'égalité avec le NULL
-- Résultat réel : 0
-- Pourquoi : une comparaison avec NULL n'est jamais vraie, elle est inconnue.
-- Réécris la condition pour compter les clients SANS email (NULL) :
SELECT count(*)
FROM clients
WHERE email IS NULL;  -- 12
-- Combien de clients ont un email vide '' ? Ce nombre est-il inclus
-- dans ta réponse précédente ? non il ne sont pas inclus dedans
-- '' IS NOT NULL (vide est différent de NULL)

SELECT count(*)
FROM clients
WHERE email = '';  -- 1

-- la vraie valeur et 1 clients avec l'email vide


-- -----------------------------------------------------------------------------
-- L4
-- -----------------------------------------------------------------------------
SELECT
    nom,
    prix_unitaire - cout_achat AS marge
FROM produits
ORDER BY marge DESC
LIMIT 3;

-- En français : je veux les 3 premiers produits qui on le meilleur marge (prix_unitaire - cout_achat)
--               dans l'ordre décroissant
-- Les 3 lignes prédites : Coffret prestige rhums, Lampe en bois de goyavier, 
--                         Coffret découverte épices (nom récupéré de la premier requetes)
-- Résultat réel : Gelée de goyave 220g      |  null
--                 Curcuma de La Plaine 100g |  null
--                 Chapeau vétiver           |  null
-- Ce qui m'a surpris : j'ai oublié que postgres affiches les null en premiers dans le DESC

-- NULL n'est pas « petit » ou « grand » en soi ; 
-- c'est le moteur qui décide où le placer. Si l'ordre compte, écris-le.

-- -----------------------------------------------------------------------------
-- L5
-- -----------------------------------------------------------------------------
SELECT
    count(*)                    AS a,
    count(DISTINCT commande_id) AS b
FROM lignes_commande
WHERE produit_id = 24;

-- Grain de lignes_commande : une ligne = un produits dans une commandes
-- a et b seront-ils égaux ? Lequel est le plus grand, et pourquoi ?
-- a et b seront différent car un compte tout les lignes et l'autres compte les commandes distinct
-- de se fait a sera plus grand que b
-- Prédiction : a 40 et b 20
-- Résultat réel :  119 | 118 (je n'est clairement pas compris la requetes vue l'ecart avec ma prédiction)
-- Trouve la commande responsable de l'écart (requête libre) :
SELECT 
    lc.commande_id , COUNT(*)
FROM lignes_commande AS lc
WHERE produit_id = 24
GROUP BY lc.commande_id
HAVING COUNT(*) > 1; -- c'est la commande 42

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

-- Étape 1 FROM     — grain : une ligne = une commande
--                    nb de lignes ≈ 1500
-- Étape 2 WHERE    — qu'est-ce qui est éliminé ?
--                    magasin_id IS NULL faut référence au magasin en ligne
-- Étape 3 GROUP BY — grain : une ligne = un status
-- Étape 4 HAVING   — qu'est-ce qui est éliminé ?
--                    les statuts dont le nombre de commandes dépasse 20
-- Étape 5 SELECT   — que représente total_frais ?
--                    on a le total des frais de livraison par status
-- Étape 7 ORDER BY   le tout affiché en décroisant
-- En français : pour les commandes en ligne (magasin_id IS NULL), regrouper par statut, 
--               compter les commandes et sommer les frais de livraison, ne garder que les statuts 
--               de plus de 20 commandes, trier par nombre décroissant.
-- Nombre de lignes prédit : 5
-- Résultat réel :
--                    statut  | nb  | total_frais 
--                  ----------+-----+-------------
--                   livree   | 260 |     1185.00
--                   expediee |  33 |      147.10
--                   payee    |  33 |      151.10
--                   annulee  |  33 |      144.20
-- Question bonus : certaines commandes en ligne ont frais_livraison NULL.
-- sum() les compte-t-il comme 0, les ignore-t-il, ou rend-il tout NULL ?
-- je suppose qu'il sont ignorer mais apres la vérif il les comptes comme 0
-- Vérifie avec une requête.
SELECT
    cmd.statut,
    count(*)                 AS nb,
    sum(cmd.frais_livraison) AS total_frais
FROM commandes AS cmd
WHERE cmd.magasin_id IS NULL AND cmd.frais_livraison IS NOT NULL
GROUP BY cmd.statut
HAVING count(*) > 20
ORDER BY nb DESC; --NULL

-- reel requete :
SELECT
    sum(frais_livraison)                    AS sum_ignore,
    sum(coalesce(frais_livraison, 0))       AS sum_zero,
    avg(frais_livraison)                    AS avg_ignore,
    avg(coalesce(frais_livraison, 0))       AS avg_zero
FROM commandes
WHERE magasin_id IS NULL;

-- sum() ignore les NULL ; le total est identique à un remplacement par 0, 
-- mais avg() et count() prouvent l'exclusion.

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

-- Bloc WITH:         
--  — grain d'entrée : une ligne de lignes_commande (un produit dans une commande)   
--    grain de sortie : une ligne = un produit (avec sa quantité totale). Pas « une quantité »
-- Requête principale — grain : un produit. Le JOIN sur une PK ne duplique pas ; 
--                              WHERE et ORDER BY ne changent pas le grain.
-- Le produit 39 (« Coffret prestige rhums ») peut-il apparaître ? Pourquoi ?
-- Non le produit 39 n'a aucune ligne dans lignes_commande. Zéro vente.
-- En français : je veux la liste des produits qui a au moins 358 unités vendues, leurs nom
--               leurs references et la quantités vendu dans l'ordre décroissant
-- Nombre de lignes prédit : 20 (suppose que 20 produits on était vendu plus de 358 fois)
-- Résultat réel :
--                   reference |            nom             | qte_vendue 
--                  -----------+----------------------------+------------
--                   P-26      | Chapeau vétiver            |        360
--                   P-36      | Casquette brodée 974       |        360
--                   P-4       | Punch coco 70cl            |        360
--                   P-32      | Paréo motif tamarin        |        359
--                   P-8       | Vanille Bourbon 10 gousses |        359
--                   P-30      | Marmite en fonte miniature |        358

-- Question bonus : regarde la colonne reference dans le résultat.
-- À quantité égale, le tri secondaire « p.reference » met-il 'P-36'
-- avant ou après 'P-4' ?
-- avant car on compare caractère par caractère
-- Pourquoi ?
-- ORDER BY p.reference compare caractère par caractère, de gauche à droite, comme un dictionnaire
-- La longueur ne compte pas : seul le premier caractère différent tranche. 
-- 'P-36' < 'P-4' parce que '3' < '4'. Et 'P-32' < 'P-8' parce que '3' < '8'.