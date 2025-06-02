CREATE TABLE client (
  client_id  SERIAL PRIMARY KEY,
  nom        VARCHAR(50) NOT NULL,
  prenom     VARCHAR(50) NOT NULL,
  adresse    TEXT NOT NULL,
  email      VARCHAR(120) UNIQUE NOT NULL,
  tel        VARCHAR(20),
  solde      NUMERIC(8,2) DEFAULT 0 CHECK (solde >= 0),
  pizzas_payees_compteur SMALLINT DEFAULT 0 CHECK (pizzas_payees_compteur >= 0)
);

CREATE TABLE pizza (
  pizza_id   SERIAL PRIMARY KEY,
  nom        VARCHAR(60) UNIQUE NOT NULL,
  prix_base  NUMERIC(5,2) NOT NULL CHECK (prix_base > 0)
);

CREATE TABLE ingredient (
  ingredient_id SERIAL PRIMARY KEY,
  libelle       VARCHAR(60) UNIQUE NOT NULL
);

CREATE TABLE pizza_ingredient (
  pizza_id      INT REFERENCES pizza(pizza_id) ON DELETE CASCADE,
  ingredient_id INT REFERENCES ingredient(ingredient_id) ON DELETE RESTRICT,
  PRIMARY KEY (pizza_id, ingredient_id)
);

CREATE TABLE taille (
  taille_code  CHAR(1) PRIMARY KEY,  -- N, H, O
  libelle      VARCHAR(20) NOT NULL,
  facteur_prix NUMERIC(4,3) NOT NULL CHECK (facteur_prix > 0)
);

CREATE TABLE livreur (
  livreur_id SERIAL PRIMARY KEY,
  nom        VARCHAR(50) NOT NULL,
  prenom     VARCHAR(50) NOT NULL
);

CREATE TABLE vehicule (
  vehicule_id     SERIAL PRIMARY KEY,
  immatriculation VARCHAR(15) UNIQUE NOT NULL,
  type            VARCHAR(10) CHECK (type IN ('AUTO','MOTO')),
  modele          VARCHAR(60)
);

CREATE TABLE livraison (
  livraison_id SERIAL PRIMARY KEY,
  client_id    INT REFERENCES client(client_id),
  pizza_id     INT REFERENCES pizza(pizza_id),
  taille_code  CHAR(1) REFERENCES taille(taille_code),
  livreur_id   INT REFERENCES livreur(livreur_id),
  vehicule_id  INT REFERENCES vehicule(vehicule_id),
  date_commande   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  date_livraison  TIMESTAMP,
  prix_facture NUMERIC(6,2) NOT NULL,
  gratuite     BOOLEAN NOT NULL DEFAULT FALSE,
  raison_gratuite VARCHAR(20)
);

CREATE INDEX idx_livraison_client ON livraison(client_id);
CREATE INDEX idx_livraison_vehicule ON livraison(vehicule_id);