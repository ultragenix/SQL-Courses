-- =============================================================================
-- Module 0 — Exercice 05 : réécrire et annoter
-- Type : 🔄 Réécrire
--
-- La requête ci-dessous fonctionne, mais elle est illisible.
--
--   1. AVANT de la reformater, essaie de la lire telle quelle et écris en
--      une phrase ce que tu penses qu'elle fait. (Tu vas voir à quel point
--      la mise en forme aide la lecture.)
--   2. Reformate-la selon les conventions du cours (fiche, section 0.11) :
--      mots-clés en majuscules, une clause par ligne, alias parlants avec AS.
--   3. Annote le GRAIN à chaque étape en commentaire (fiche, section 0.9,
--      technique 2). Marque d'un ⚠️ l'endroit où le grain devient plus fin.
--   4. Réécris en français ce que fait la requête.
--   5. Vérifie que ta version renvoie exactement le même résultat :
--        SELECT outils.verifier('m00-r1', $q$ ta version $q$);
--      (Attention : garde les mêmes colonnes, dans le même ordre.)
--   6. Question piège : count(*) compte-t-il ici des commandes ou autre
--      chose ? Si ce n'est pas des commandes, l'alias choisi est trompeur.
--      Que proposes-tu ? (Ne modifie pas le résultat pour la vérification :
--      réponds en commentaire.)
-- =============================================================================

select a.commune,count(*) n,sum(c.quantite*c.prix_unitaire) t from clients a join commandes b on b.client_id=a.client_id join lignes_commande c on c.commande_id=b.commande_id where b.statut<>'annulee' and a.est_pro=false group by a.commune order by t desc limit 5;

-- 1. Ma lecture avant reformatage :


-- 2 et 3. Ma version reformatée et annotée :


-- 4. En français :


-- 6. count(*) compte :
--    Proposition :
