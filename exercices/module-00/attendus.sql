-- =============================================================================
-- Module 0 — Empreintes des résultats attendus
-- À charger une fois dans psql :  \i /exercices/module-00/attendus.sql
--
-- Ce fichier ne contient AUCUNE solution : seulement le nombre de lignes et
-- un hash (md5) du résultat attendu. Il est impossible de retrouver la
-- requête à partir de ce hash.
-- =============================================================================

INSERT INTO outils.attendus (exercice_id, nb_lignes, empreinte, consigne) VALUES
    ('m00-d1', 7, '41dadf4ef740e461400d570bdde621f4', 'Produits dont la marge dépasse 20 € (nom, marge)'),
    ('m00-d2', 9, 'a6d093bc87a5e59d0611ff704545cf4d', 'Clients habitant « Le Tampon » (client_id, prenom, nom)'),
    ('m00-d3', 4, '38546748c3ccb0d6b0e191052296780f', 'Produits au coût d''achat inconnu (produit_id, nom)'),
    ('m00-d4', 4, '9eb1867635c0385e5d161b9fae7e0da1', 'Catégories de plus de 5 produits (categorie_id, nb_produits)'),
    ('m00-d5', 4, '6b7029d9dd87921021f50d90e2c032b2', 'Part en % de chaque ligne de la commande 42 (ligne_id, quantite, part_pct)'),
    ('m00-d6', 3, '9b33daca3f95e1581cf3577620bab370', 'Top 3 des marges connues (nom, marge)'),
    ('m00-d7', 40, '6c74d64aca5e85f3c352d3dac2e4599b', 'Produits et prix (nom, prix_unitaire)'),
    ('m00-e1', 40, '7be1f928aa8a5dbb58a1150450fe0ccf', 'Prix TTC à 8,5 % (reference, nom, prix_unitaire, prix_ttc)'),
    ('m00-e2', 34, 'e45c2a4b34b8af43af56196aab5f8ffd', 'Marge et taux de marge des produits actifs au coût connu (nom, marge, taux_marge_pct)'),
    ('m00-e3', 5, '5349d941afbf58e3f7457abcd12a7f6a', 'Poids en grammes (entier) des produits de plus d''1 kg (nom, poids_g)'),
    ('m00-e4', 4, '3f17a0076eb05a9d66a83c75768e5b02', 'Détail de la commande 42 avec montant (ligne_id, produit_id, quantite, prix_unitaire, montant)'),
    ('m00-e5', 5, 'a162c92b8263b71bff33f0ae9d784493', 'Nom complet des clients 116 à 120 (client_id, nom_complet)'),
    ('m00-e6', 5, 'acaa6bd326747af8694e23a556e843d0', 'Âge en jours au 01/01/2026 des magasins ouverts (nom, age_jours)'),
    ('m00-r1', 5, 'dcb5c7fffb23a1755d3f388d988b90af', 'Requête réécrite : même résultat que l''originale')
ON CONFLICT (exercice_id) DO UPDATE
   SET nb_lignes = EXCLUDED.nb_lignes,
       empreinte = EXCLUDED.empreinte,
       consigne  = EXCLUDED.consigne;
