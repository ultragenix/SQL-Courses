-- =============================================================================
-- Dataset fil rouge : « Kaz Péi », une enseigne fictive de produits péi
-- (épicerie fine, artisanat, textile) avec des magasins dans l'île
-- et une boutique en ligne.
--
-- Schéma : boutique
--
--   categories ◄──┐ (une catégorie peut avoir une catégorie parente)
--       ▲         │
--       │         └── categories.categorie_parent_id
--   produits
--       ▲
--       │
--   lignes_commande ──► commandes ──► clients
--                           │
--                           └──► magasins   (NULL = commande en ligne)
--
-- ⚠️ Les données contiennent VOLONTAIREMENT des défauts du monde réel :
--    NULL, doublons, fautes de saisie, majuscules incohérentes, espaces en trop.
--    Ce n'est pas un bug, c'est le terrain d'entraînement.
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS boutique;

-- Toutes les sessions sur cette base cherchent les tables dans « boutique »
-- d'abord : on peut écrire  FROM clients  au lieu de  FROM boutique.clients
ALTER DATABASE cours_sql SET search_path = boutique, public;
-- Les dates/heures s'affichent à l'heure de La Réunion (UTC+4)
ALTER DATABASE cours_sql SET timezone = 'Indian/Reunion';

SET search_path = boutique, public;

-- -----------------------------------------------------------------------------
-- magasins : les points de vente physiques
-- -----------------------------------------------------------------------------
CREATE TABLE magasins (
    magasin_id    integer      PRIMARY KEY,
    nom           text         NOT NULL,
    commune       text         NOT NULL,
    date_ouverture date        NOT NULL,
    surface_m2    integer,                       -- NULL = surface non renseignée
    date_fermeture date                          -- NULL = magasin toujours ouvert
);

-- -----------------------------------------------------------------------------
-- clients : les personnes (ou entreprises) qui achètent
-- -----------------------------------------------------------------------------
CREATE TABLE clients (
    client_id        integer   PRIMARY KEY,
    prenom           text,
    nom              text      NOT NULL,
    email            text,                       -- peut être NULL (client en magasin)
    telephone        text,
    commune          text,                       -- saisie libre : attention aux variantes !
    date_naissance   date,
    date_inscription date      NOT NULL,
    est_pro          boolean   NOT NULL DEFAULT false   -- true = client professionnel
);

-- -----------------------------------------------------------------------------
-- categories : arborescence de catégories (servira pour les hiérarchies)
-- -----------------------------------------------------------------------------
CREATE TABLE categories (
    categorie_id        integer PRIMARY KEY,
    nom                 text    NOT NULL,
    categorie_parent_id integer REFERENCES categories (categorie_id)  -- NULL = catégorie racine
);

-- -----------------------------------------------------------------------------
-- produits : le catalogue
-- -----------------------------------------------------------------------------
CREATE TABLE produits (
    produit_id     integer        PRIMARY KEY,
    reference      text           NOT NULL UNIQUE,   -- ex. 'P-7', 'P-12' (du TEXTE !)
    nom            text           NOT NULL,
    categorie_id   integer        REFERENCES categories (categorie_id),  -- peut être NULL
    prix_unitaire  numeric(10, 2) NOT NULL,          -- prix de vente ACTUEL, en euros
    cout_achat     numeric(10, 2),                   -- NULL = coût inconnu
    poids_kg       numeric(6, 3),
    actif          boolean        NOT NULL DEFAULT true  -- false = retiré du catalogue
);

-- -----------------------------------------------------------------------------
-- commandes : l'en-tête de chaque commande
-- -----------------------------------------------------------------------------
CREATE TABLE commandes (
    commande_id      integer     PRIMARY KEY,
    client_id        integer     NOT NULL REFERENCES clients (client_id),
    magasin_id       integer     REFERENCES magasins (magasin_id),  -- NULL = commande en ligne
    date_commande    timestamptz NOT NULL,
    statut           text        NOT NULL
        CHECK (statut IN ('en_attente', 'payee', 'expediee', 'livree', 'annulee')),
    frais_livraison  numeric(8, 2)           -- NULL en magasin, parfois 0 en ligne
);

-- -----------------------------------------------------------------------------
-- lignes_commande : le détail (quels produits, combien, à quel prix)
-- Le prix est celui AU MOMENT de la commande : il peut différer du prix actuel
-- dans produits.prix_unitaire.
-- -----------------------------------------------------------------------------
CREATE TABLE lignes_commande (
    ligne_id       integer        PRIMARY KEY,
    commande_id    integer        NOT NULL REFERENCES commandes (commande_id),
    produit_id     integer        NOT NULL REFERENCES produits (produit_id),
    quantite       integer        NOT NULL CHECK (quantite > 0),
    prix_unitaire  numeric(10, 2) NOT NULL,
    remise_pct     numeric(5, 2)              -- NULL = pas renseigné (≠ 0 !)
);

COMMENT ON TABLE magasins        IS 'Points de vente physiques de Kaz Péi';
COMMENT ON TABLE clients         IS 'Clients particuliers et professionnels';
COMMENT ON TABLE categories      IS 'Catégories de produits, arborescentes';
COMMENT ON TABLE produits        IS 'Catalogue produits';
COMMENT ON TABLE commandes       IS 'En-têtes de commande (une ligne = une commande)';
COMMENT ON TABLE lignes_commande IS 'Détail des commandes (une ligne = un produit dans une commande)';
