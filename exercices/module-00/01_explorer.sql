-- =============================================================================
-- Module 0 — Exercice 01 : explorer le dataset avec psql
-- Type : Explorer
--
-- Pas de vérification automatique ici : écris tes réponses en commentaire
-- sous chaque question. Elles serviront de référence pour la suite.
-- =============================================================================

-- Q1. Active l'affichage visible des NULL et le chronomètre.
--     Quelles deux méta-commandes as-tu tapées ?
-- Réponse :
--pour rendre visible le NULL on utilise la commandes \pset null '[VALUE]' par exemple si on veut le
--    mettre par defaut a 'null' on tape la commande \pset null 'null' 
--    (on ne mes pas a 0 sa peut porté a confusion comme pour le 0 qui est une livraison offerte)
--pour afficher le chronometre de la requetes on fait \timing (favorisé \timing on)

-- Q2. Liste les tables du schéma boutique. Combien y en a-t-il ?
-- Réponse :
-- \dt liste les tables de tous les schémas du search_path, pas seulement celui de boutique 
-- — la colonne Schema apparaît dès que plusieurs schémas sont représentés.
--    Attention  ne pas confondre table et schema  boutique ici est un schema pas une table)
--    la bonne formulation serais (quelle serais tout les schema présent dans le search_path ?)

-- Q3. Avec \d commandes : quelles colonnes de commandes PEUVENT être NULL ?
--     Pour chacune, explique en une phrase ce que signifie un NULL
--     (indice : relis les commentaires du fichier data/init/01_schema.sql).
-- Réponse :
--deux colonnes peuvent etre null le magasin_id (qui représente le magasin en ligne quand il est a null)
--    et le frais_livraison qui correspond (a un achat en magasin car il ny a pas de livraison)
-- attention, frais_livraison = 0 est une commande en ligne avec livraison offerte : ce n'est pas un NULL

-- Q4. Quelle est la clé primaire de lignes_commande ?
--     Quelles sont ses clés étrangères, et vers quelles tables pointent-elles ?
-- Réponse :
--la clé primaire de lignes_commande est ligne_id
--il possede deux clé étrangères commande_id qui est référence a la tables commandes
--    et la clé étrangères produit_id qui fait référence a la table produits


-- Q5. Donne le GRAIN de chaque table, sous la forme « une ligne = ... ».
--     magasins, clients, categories, produits, commandes, lignes_commande
-- Réponse :
--    magasin => une ligne = un magasin
--    clients => une ligne = un client
--    categories => une ligne = une catégorie, éventuellement rattachée à une catégorie parente
--    produits => une ligne = un produit
--    commandes => une ligne = l'en-tête d'une commande : qui, où, quand, statut 
--    lignes_commande => une ligne = un produits qui est dans une commande

-- Q6. Compte le nombre de lignes de chaque table (une requête par table).
--     Avant d'exécuter : lignes_commande aura-t-elle plus ou moins de lignes
--     que commandes ? Pourquoi ?
-- Prédiction : lignes_commande aura bien plus de ligne que commandes car pour une commande 
--              on a plusieurs lignes_commande
-- Résultats : commandes 1500; lignes_commande = 3751


-- Q7. Affiche les clients 116 à 120 avec SELECT *.
--     Le résultat est trop large ? Essaie \x puis relance.
--     Quelles anomalies de données repères-tu ? (il y en a au moins 4)
-- Réponse :
SELECT *  FROM clients
WHERE client_id >= 116 AND client_id <= 120;

-- je contaste l'anomalie sur le client 118 et 119 qui sont la meme personnes un avec un mail en maj
-- 119 a un espace a la fin de son email; 120 a un email vide est qui est considéré comme non null
-- 116 'jean' = 'Jean' est faut fait attention a la casse

-- Q8. Avec \h SELECT, retrouve dans la syntaxe officielle l'ordre d'écriture
--     des clauses. Où se place WINDOW ? Et FETCH ?
-- Réponse :
-- WINDOW est apres le Having et avant l'union et l'order by
-- FETCH est juste apres OFFSET et avant le FOR

-- Q9. Dans la table categories, une colonne pointe vers... la table categories
--     elle-même. Laquelle ? À quoi ça sert ? Dessine l'arborescence des
--     catégories sur papier (ou en commentaire).
-- Réponse :
-- categorie_parent_id pointe vers lui meme car on as des parents de catégorie qui regroupe des 
--  sous catégorie par exemple la catégorie 2,3 et 4 ou le meme parents qui est la catégorie 1
-- c'est une jointures qui se relie a elle meme dans l'arboressence

-- =============================================================================
-- MISE AU PROPRE — synthèse de l'exercice 01
-- (version relue et corrigée des réponses ci-dessus, à garder comme référence)
-- =============================================================================

-- 1) psql : voir ce que l'écran cache
--    - \pset null '[NULL]'  rend les NULL visibles (jamais 0 : 0 est une valeur).
--    - \timing on           affiche la durée de chaque requête.
--    - \dt                   liste les tables des schémas du search_path (boutique, public) ;
--                            la colonne Schema donne l'origine de chaque table.
--    - \d table              décrit les colonnes, les NULL autorisés, les clés.
--    - \h SELECT             affiche la syntaxe officielle d'une commande.
--    - \x                     bascule l'affichage en mode « une colonne par ligne » (lisible
--                            quand la table est large).

-- 2) Objets et résolution des noms
--    - Une base contient des schémas ; un schéma contient des tables.
--      « boutique » est un schéma, pas une table.
--    - search_path = boutique, public : un nom non qualifié (clients) est cherché
--      d'abord dans boutique, puis dans public.
--    - Écrire boutique.clients lève toute ambiguïté (notation schéma.objet).

-- 3) NULL : une absence de valeur, pas une valeur
--    - magasin_id NULL dans commandes   = commande passée en ligne (pas de magasin).
--    - frais_livraison NULL             = achat en magasin (aucune livraison à facturer).
--    - frais_livraison = 0              = commande en ligne avec livraison offerte : ce n'est
--                                         PAS un NULL, c'est un vrai zéro.
--    - NULL n'est jamais égal à rien : on le teste avec IS NULL / IS NOT NULL, pas avec =.
--    - '' (chaîne vide) est une valeur présente, donc différente de NULL.

-- 4) Clés et grain
--    - Chaque table a une clé primaire (Primary Key, PK) : une colonne qui identifie
--      une ligne de façon unique.
--    - Une clé étrangère (Foreign Key, FK) pointe vers la PK d'une autre table.
--      lignes_commande : PK = ligne_id ; FK = commande_id → commandes, produit_id → produits.
--    - Le grain, c'est « à quoi correspond une ligne » :
--        magasins         une ligne = un magasin
--        clients          une ligne = un client
--        categories       une ligne = une catégorie (categorie_parent_id NULL = catégorie racine)
--        produits         une ligne = un produit
--        commandes        une ligne = l'en-tête d'une commande (qui, où, quand, statut)
--        lignes_commande  une ligne = un produit dans une commande
--    - Conséquence : une commande peut avoir plusieurs lignes de commande, donc
--      lignes_commande est plus volumineuse que commandes (3751 contre 1500).
--      Compter les lignes d'une table ne dit rien du nombre de commandes.

-- 5) Arborescence des catégories
--    - categories.categorie_parent_id est une FK auto-référente : elle pointe vers
--      categories.categorie_id. Une catégorie peut donc avoir un parent, et NULL
--      signifie « catégorie racine ».
--    - Pour parcourir cette hiérarchie, il faudra une jointure de categories sur
--      elle-même (ou une CTE récursive plus tard).

-- 6) Données réelles : les anomalies ne se voient pas toujours à l'œil nu
--    Sur les clients 116 à 120 :
--      - 116 : prénom écrit 'jean' alors que les autres sont capitalisés → problème de casse.
--      - 118 et 119 : même personne en double, avec l'email écrit différemment → doublon.
--      - 119 : espace en fin d'email → invisible sans length() ou btrim().
--      - 120 : email = '' (chaîne vide) et non NULL → email présent mais inutilisable.
--    Méthode : encadrer les valeurs (par exemple '[' || email || ']'), mesurer
--    length(), comparer email <> btrim(email). Ce qui est NULL doit être traité
--    comme une information manquante, pas comme une faute de saisie.

-- 7) Ordre d'écriture des clauses (rappel de \h SELECT)
--    SELECT … FROM … WHERE … GROUP BY … HAVING … WINDOW …
--    UNION / INTERSECT / EXCEPT …
--    ORDER BY … LIMIT … OFFSET … FETCH … FOR …
--    Cet ordre est celui de l'écriture ; l'ordre d'exécution, lui, est différent
--    (FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT).
--    C'est cet ordre d'exécution qu'on suit pour lire une requête.

-- 8) La question réflexe, à poser à chaque étape
--    « À cette étape, une ligne = quoi ? »
--    Elle permet de savoir si le résultat est au bon grain avant d'ajouter une
--    clause, et d'éviter les doublons et les comptes faux.