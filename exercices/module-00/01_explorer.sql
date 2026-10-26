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


-- Q2. Liste les tables du schéma boutique. Combien y en a-t-il ?
-- Réponse :


-- Q3. Avec \d commandes : quelles colonnes de commandes PEUVENT être NULL ?
--     Pour chacune, explique en une phrase ce que signifie un NULL
--     (indice : relis les commentaires du fichier data/init/01_schema.sql).
-- Réponse :


-- Q4. Quelle est la clé primaire de lignes_commande ?
--     Quelles sont ses clés étrangères, et vers quelles tables pointent-elles ?
-- Réponse :


-- Q5. Donne le GRAIN de chaque table, sous la forme « une ligne = ... ».
--     magasins, clients, categories, produits, commandes, lignes_commande
-- Réponse :


-- Q6. Compte le nombre de lignes de chaque table (une requête par table).
--     Avant d'exécuter : lignes_commande aura-t-elle plus ou moins de lignes
--     que commandes ? Pourquoi ?
-- Prédiction :
-- Résultats :


-- Q7. Affiche les clients 116 à 120 avec SELECT *.
--     Le résultat est trop large ? Essaie \x puis relance.
--     Quelles anomalies de données repères-tu ? (il y en a au moins 4)
-- Réponse :


-- Q8. Avec \h SELECT, retrouve dans la syntaxe officielle l'ordre d'écriture
--     des clauses. Où se place WINDOW ? Et FETCH ?
-- Réponse :


-- Q9. Dans la table categories, une colonne pointe vers... la table categories
--     elle-même. Laquelle ? À quoi ça sert ? Dessine l'arborescence des
--     catégories sur papier (ou en commentaire).
-- Réponse :
