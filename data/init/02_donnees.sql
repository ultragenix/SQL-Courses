-- =============================================================================
-- Données du dataset fil rouge « Kaz Péi »
-- Générées de façon DÉTERMINISTE (pas de random()) : tout le monde obtient
-- exactement les mêmes données, donc les mêmes résultats d'exercices.
-- =============================================================================

SET search_path = boutique, public;

-- -----------------------------------------------------------------------------
-- Magasins
-- -----------------------------------------------------------------------------
INSERT INTO magasins (magasin_id, nom, commune, date_ouverture, surface_m2, date_fermeture) VALUES
    (1, 'Kaz Péi Barachois',   'Saint-Denis',  '2018-03-10', 180,  NULL),
    (2, 'Kaz Péi Front de mer','Saint-Pierre', '2019-06-01', 150,  NULL),
    (3, 'Kaz Péi Marché',      'Saint-Paul',   '2020-02-15', 95,   NULL),
    (4, 'Kaz Péi Est',         'Saint-Benoît', '2021-09-04', 120,  NULL),
    (5, 'Kaz Péi Hauts',       'Le Tampon',    '2023-04-22', NULL, NULL),
    (6, 'Kaz Péi Champ-Borne', 'Saint-André',  '2020-11-07', 80,   '2025-06-30');

-- -----------------------------------------------------------------------------
-- Catégories (arborescence)
-- -----------------------------------------------------------------------------
INSERT INTO categories (categorie_id, nom, categorie_parent_id) VALUES
    (1, 'Épicerie fine',          NULL),
    (2, 'Rhums & boissons',       1),
    (3, 'Épices & condiments',    1),
    (4, 'Confitures & douceurs',  1),
    (5, 'Artisanat',              NULL),
    (6, 'Vannerie',               5),
    (7, 'Textile',                NULL),
    (8, 'Cosmétiques',            NULL);   -- aucun produit dans cette catégorie

-- -----------------------------------------------------------------------------
-- Produits
-- ⚠️ reference est du TEXTE : 'P-10' < 'P-9' en tri alphabétique !
-- -----------------------------------------------------------------------------
INSERT INTO produits (produit_id, reference, nom, categorie_id, prix_unitaire, cout_achat, poids_kg, actif) VALUES
    ( 1, 'P-1',  'Rhum arrangé vanille 70cl',       2, 32.00, 14.50, 1.300, true),
    ( 2, 'P-2',  'Rhum arrangé letchi 70cl',        2, 32.00, 14.50, 1.300, true),
    ( 3, 'P-3',  'Rhum arrangé gingembre 50cl',     2, 26.50, 11.00, 0.950, true),
    ( 4, 'P-4',  'Punch coco 70cl',                 2, 18.90,  7.20, 1.250, true),
    ( 5, 'P-5',  'Sirop de canne 50cl',             2,  6.50,  2.10, 0.700, true),
    ( 6, 'P-6',  'Café Bourbon pointu 250g',        1, 45.00, 28.00, 0.280, true),
    ( 7, 'P-7',  'Vanille Bourbon 5 gousses',       3, 24.00, 12.00, 0.030, true),
    ( 8, 'P-8',  'Vanille Bourbon 10 gousses',      3, 42.00, 21.00, 0.055, true),
    ( 9, 'P-9',  'Piment zoizo pot 100g',           3,  7.90,  2.50, 0.180, true),
    (10, 'P-10', 'Massalé pour cari 100g',          3,  5.50,  1.60, 0.120, true),
    (11, 'P-11', 'Curcuma de La Plaine 100g',       3,  6.90, NULL,  0.120, true),
    (12, 'P-12', 'Achards de légumes 350g',         3,  8.50,  3.10, 0.420, true),
    (13, 'P-13', 'Combava confit 200g',             3,  9.90,  3.80, 0.250, true),
    (14, 'P-14', 'Poivre sauvage voatsiperifery',   3, 14.50,  6.00, 0.050, false),
    (15, 'P-15', 'Confiture goyavier 220g',         4,  7.50,  2.60, 0.330, true),
    (16, 'P-16', 'Confiture letchi 220g',           4,  7.50,  2.60, 0.330, true),
    (17, 'P-17', 'Confiture ananas Victoria 220g',  4,  7.90,  2.80, 0.330, true),
    (18, 'P-18', 'Gelée de goyave 220g',            4,  6.90, NULL,  0.330, true),
    (19, 'P-19', 'Bonbons piment (sachet)',         4,  4.50,  1.20, 0.200, true),
    (20, 'P-20', 'Macatia coco (x6)',               4,  5.90,  2.00, 0.300, true),
    (21, 'P-21', 'Gâteau patate (part)',            4,  3.50,  1.10, 0.150, false),
    (22, 'P-22', 'Miel de baies roses 250g',        4, 15.90,  7.50, 0.350, true),
    (23, 'P-23', 'Panier vacoa moyen',              6, 29.00, 12.00, 0.400, true),
    (24, 'P-24', 'Panier vacoa grand',              6, 45.00, 19.00, 0.650, true),
    (25, 'P-25', 'Bertel vacoa',                    6, 38.00, 16.00, 0.500, true),
    (26, 'P-26', 'Chapeau vétiver',                 6, 35.00, NULL,  0.150, true),
    (27, 'P-27', 'Dessous de plat vacoa',           6, 12.00,  4.00, 0.120, true),
    (28, 'P-28', 'Lampe en bois de goyavier',       5, 65.00, 30.00, 1.100, true),
    (29, 'P-29', 'Planche à découper tamarin',      5, 39.00, 17.00, 0.900, true),
    (30, 'P-30', 'Marmite en fonte miniature',      5, 22.00,  9.00, 0.800, true),
    (31, 'P-31', 'Carte postale illustrée',         5,  2.00,  0.40, 0.010, true),
    (32, 'P-32', 'Paréo motif tamarin',             7, 25.00,  9.00, 0.200, true),
    (33, 'P-33', 'Paréo motif fleur de vanille',    7, 25.00,  9.00, 0.200, true),
    (34, 'P-34', 'Tee-shirt « 974 »',              7, 19.90,  6.50, 0.180, true),
    (35, 'P-35', 'Tee-shirt « Péi lé la »',        7, 19.90,  6.50, 0.180, true),
    (36, 'P-36', 'Casquette brodée 974',            7, 17.50,  5.80, 0.120, true),
    (37, 'P-37', 'Sac en toile Kaz Péi',            7,  9.90,  2.90, 0.150, true),
    (38, 'P-38', 'Coffret découverte épices',       3, 49.00, 22.00, 0.900, true),
    (39, 'P-39', 'Coffret prestige rhums',          2, 89.00, 41.00, 3.500, true),   -- jamais vendu
    (40, 'P-40', 'Bon cadeau 50 €',                 NULL, 50.00, NULL, NULL, true);  -- sans catégorie, jamais vendu

-- -----------------------------------------------------------------------------
-- Clients 1 à 115 : générés
-- -----------------------------------------------------------------------------
INSERT INTO clients (client_id, prenom, nom, email, telephone, commune,
                     date_naissance, date_inscription, est_pro)
SELECT
    i AS client_id,
    p.prenom,
    n.nom,
    CASE
        WHEN i % 9 = 0  THEN NULL                                           -- pas d'email
        WHEN i % 11 = 0 THEN initcap(p.prenom) || '.' || upper(n.nom) || i || '@Mail.RE'  -- casse incohérente
        ELSE lower(p.prenom || '.' || n.nom) || i || '@mail.re'
    END AS email,
    CASE WHEN i % 8 = 0 THEN NULL
         ELSE '0692 ' || lpad(((i * 4517) % 1000000)::text, 6, '0')
    END AS telephone,
    c.commune,
    CASE WHEN i % 6 = 0 THEN NULL
         ELSE date '1950-01-01' + (i * 263) % 20000
    END AS date_naissance,
    date '2023-01-15' + (i * 17) % 900 AS date_inscription,
    (i % 10 = 0) AS est_pro
FROM generate_series(1, 115) AS i
JOIN LATERAL (
    SELECT (ARRAY['Marie','Jean','Sophie','Didier','Nathalie','Patrick','Céline','Frédéric',
                  'Sandrine','Thierry','Mélissa','Kévin','Laëtitia','Loïc','Émilie','Johan',
                  'Aurélie','Ludovic','Noémie','Mickaël'])[1 + (i * 7) % 20] AS prenom
) p ON true
JOIN LATERAL (
    SELECT (ARRAY['Payet','Hoarau','Grondin','Fontaine','Rivière','Técher','Boyer','Robert',
                  'Lebon','Maillot','Nativel','Hoareau','Ethève','Dijoux','Turpin','Morel',
                  'Lauret','Clain','Sautron','Mussard','Ah-Hot','Ramassamy','Vienne'])[1 + (i * 5) % 23] AS nom
) n ON true
JOIN LATERAL (
    SELECT CASE
        -- 1 client sur 7 a une commune saisie « salement », comme dans la vraie vie
        WHEN i % 7 = 0 THEN
            (ARRAY['SAINT-DENIS','saint-denis','Saint-Denis ','St-Denis',
                   'Saint Pierre','L''Etang-Salé', NULL])[1 + (i / 7) % 7]
        ELSE
            (ARRAY['Saint-Denis','Saint-Pierre','Saint-Paul','Le Tampon','Saint-André',
                   'Saint-Louis','Le Port','Saint-Benoît','Sainte-Marie','L''Étang-Salé',
                   'Saint-Leu','Cilaos','La Possession','Sainte-Suzanne'])[1 + ((i - i / 7) * 5) % 14]
    END AS commune
) c ON true;

-- -----------------------------------------------------------------------------
-- Clients 116 à 120 : cas particuliers écrits à la main
-- -----------------------------------------------------------------------------
INSERT INTO clients (client_id, prenom, nom, email, telephone, commune,
                     date_naissance, date_inscription, est_pro) VALUES
    -- Doublon probable du client 3 (même personne, email avec une casse différente)
    (116, 'jean', 'MOREL', 'Jean.Morel3@mail.re', NULL, 'L''Etang-Salé', '1952-02-29', '2025-02-01', false),
    (117, NULL,      'SARL Ti Kaz',  'contact@tikaz.re', '0262 41 00 00', 'Saint-Pierre', NULL, '2024-05-12', true),
    (118, 'Jean',    'Payet',  'jean.payet@mail.re', '0692 000118', 'Le Tampon', '1988-07-14', '2025-09-30', false),
    (119, 'Jean',    'Payet',  'JEAN.PAYET@MAIL.RE ', '0692 000118', 'Le Tampon', '1988-07-14', '2025-10-02', false),  -- doublon de 118 (email en majuscules + espace final)
    (120, 'Ève',     'Lauret', '', NULL, NULL, '2001-02-28', '2025-12-20', false);  -- email = chaîne vide (≠ NULL !)

-- -----------------------------------------------------------------------------
-- Commandes : 1 500 commandes réparties sur 2024 et 2025
-- Les clients 111 à 120 n'ont JAMAIS commandé.
-- -----------------------------------------------------------------------------
INSERT INTO commandes (commande_id, client_id, magasin_id, date_commande, statut, frais_livraison)
WITH base AS (
    SELECT
        i,
        1 + (i * 37) % 110 AS client_id,
        CASE WHEN i % 4 = 0 THEN NULL ELSE 1 + (i * 5) % 6 END AS magasin_brut,
        (timestamp '2024-01-01 08:00'
            + ((i * 389) % 731) * interval '1 day'
            + ((i * 131) % 660)  * interval '1 minute') AT TIME ZONE 'Indian/Reunion' AS date_commande,
        CASE i % 23
            WHEN 0 THEN 'annulee'
            WHEN 1 THEN 'annulee'
            WHEN 2 THEN 'en_attente'
            WHEN 3 THEN 'payee'
            WHEN 4 THEN 'payee'
            WHEN 5 THEN 'expediee'
            WHEN 6 THEN 'expediee'
            ELSE 'livree'
        END AS statut_brut
    FROM generate_series(1, 1500) AS i
)
SELECT
    i,
    client_id,
    -- le magasin 6 a fermé le 30/06/2025 : ses commandes après cette date
    -- sont réaffectées au magasin 1
    CASE WHEN magasin_brut = 6 AND date_commande >= timestamptz '2025-07-01 00:00+04'
         THEN 1 ELSE magasin_brut END,
    date_commande,
    -- en magasin, on repart avec ses produits : ni « expédiée » ni « en attente »
    CASE WHEN magasin_brut IS NOT NULL AND statut_brut IN ('expediee', 'en_attente', 'payee')
         THEN 'livree' ELSE statut_brut END,
    CASE
        WHEN magasin_brut IS NOT NULL THEN NULL      -- en magasin : pas de livraison
        WHEN i % 3 = 0 THEN 0                        -- livraison offerte
        WHEN i % 7 = 0 THEN NULL                     -- oubli de saisie
        ELSE 4.90 + (i % 3) * 2
    END
FROM base;

-- -----------------------------------------------------------------------------
-- Lignes de commande : 1 à 4 produits par commande
-- Les produits 39 et 40 ne sont JAMAIS vendus.
-- -----------------------------------------------------------------------------
INSERT INTO lignes_commande (ligne_id, commande_id, produit_id, quantite, prix_unitaire, remise_pct)
SELECT
    row_number() OVER (ORDER BY c.commande_id, k) AS ligne_id,
    c.commande_id,
    1 + (c.commande_id * 11 + k * 17) % 38 AS produit_id,
    1 + (c.commande_id + k) % 5 AS quantite,
    -- 1 commande sur 10 a été passée pendant une promo à -10 % sur le prix
    round(p.prix_unitaire * CASE WHEN c.commande_id % 10 = 0 THEN 0.9 ELSE 1 END, 2) AS prix_unitaire,
    CASE
        WHEN (c.commande_id + k) % 6 = 0  THEN 10
        WHEN (c.commande_id + k) % 13 = 0 THEN NULL   -- remise non renseignée
        ELSE 0
    END AS remise_pct
FROM commandes c
CROSS JOIN LATERAL generate_series(1, 1 + c.commande_id % 4) AS k
JOIN produits p ON p.produit_id = 1 + (c.commande_id * 11 + k * 17) % 38;

-- Piège volontaire : la commande 42 contient deux fois le même produit
-- sur deux lignes séparées (saisie en caisse en deux fois)
INSERT INTO lignes_commande (ligne_id, commande_id, produit_id, quantite, prix_unitaire, remise_pct)
SELECT max(ligne_id) + 1, 42, 24, 1, 45.00, 0 FROM lignes_commande;

ANALYZE;
