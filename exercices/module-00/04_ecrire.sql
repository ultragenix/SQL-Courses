-- =============================================================================
-- Module 0 — Exercice 04 : écrire
-- Type : ✍️ Écrire
--
-- Écris la requête qui répond à chaque question.
-- Respecte EXACTEMENT les colonnes demandées, dans l'ordre et avec les
-- alias indiqués (l'ordre des lignes, lui, n'a pas d'importance pour la
-- vérification, sauf mention contraire).
--
-- Vérifie chaque réponse :
--   SELECT outils.verifier('m00-e1', $q$
--       ta requête
--   $q$);
--
-- Avant d'écrire : quel est le grain de la table de départ ?
-- Après avoir écrit : relis ta requête avec la méthode (ordre d'exécution).
-- =============================================================================


-- -----------------------------------------------------------------------------
-- m00-e1 : le prix TTC de chaque produit
-- La TVA à La Réunion est de 8,5 %. Le prix TTC = prix HT × 1,085,
-- arrondi au centime.
-- Colonnes attendues : reference, nom, prix_unitaire, prix_ttc
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
-- m00-e2 : la marge et le taux de marge des produits ACTIFS dont le coût
-- d'achat est CONNU.
--   marge          = prix_unitaire - cout_achat
--   taux_marge_pct = marge / prix_unitaire × 100, arrondi à 1 décimale
-- Colonnes attendues : nom, marge, taux_marge_pct
-- Indice : deux conditions dans le WHERE, reliées par AND.
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
-- m00-e3 : le poids en GRAMMES des produits qui pèsent plus d'un kilo.
-- Colonnes attendues : nom, poids_g
-- poids_g doit être un nombre ENTIER (pas de décimales du tout).
-- Indice : regarde ce que donne poids_kg * 1000 avec pg_typeof(),
-- puis cherche comment convertir un type (fiche, section 0.7).
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
-- m00-e4 : le détail de la commande 42 avec le montant de chaque ligne.
--   montant = quantité × prix unitaire (on ignore la remise pour l'instant)
-- Colonnes attendues : ligne_id, produit_id, quantite, prix_unitaire, montant
-- Question complémentaire (en commentaire) : que remarques-tu sur les
-- produits de cette commande ? Est-ce forcément une erreur ?
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
-- m00-e5 : le nom complet des clients 116 à 120, sous la forme
-- « prénom nom » séparés par UNE espace. Si le prénom est absent, le nom
-- complet doit quand même apparaître, sans espace parasite au début.
-- Colonnes attendues : client_id, nom_complet
-- Indice : essaie d'abord avec ||, observe le client 117, puis relis
-- la fin de la section 0.5.
-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------
-- m00-e6 : l'âge (en jours) de chaque magasin au 1er janvier 2026,
-- uniquement pour les magasins encore ouverts.
-- Colonnes attendues : nom, age_jours
-- Indices :
--   - date '2026-01-01' écrit une date constante ;
--   - en PostgreSQL, date - date donne un nombre de jours (integer) ;
--   - « encore ouvert » se lit dans la colonne date_fermeture (relis 01_schema.sql).
-- -----------------------------------------------------------------------------
