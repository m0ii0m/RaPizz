-- Tailles
INSERT INTO taille VALUES
  ('N','Naine',0.666), ('H','Humaine',1.000), ('O','Ogresse',1.333);

-- Ingrédients
INSERT INTO ingredient (libelle) VALUES
 ('Tomate'),('Mozzarella'),('Jambon'),('Champignons'),('Olives'),
 ('Anchois'),('Poivrons'),('Chorizo');

-- Pizzas
INSERT INTO pizza (nom,prix_base) VALUES
 ('Margherita',8.00),
 ('Reine',9.50),
 ('Chorizo Fiesta',10.50);

-- Composition
INSERT INTO pizza_ingredient VALUES
 -- Margherita
 (1,1),(1,2),
 -- Reine
 (2,1),(2,2),(2,3),(2,4),
 -- Chorizo Fiesta
 (3,1),(3,2),(3,8),(3,5);

-- Clients
INSERT INTO client (nom,prenom,adresse,email,solde) VALUES
 ('Durand','Alice','1 rue des Lilas','alice@example.com',50),
 ('Martin','Bob','2 av. de Paris','bob@example.com',30);

-- Livreurs & véhicules
INSERT INTO livreur (nom,prenom) VALUES ('Lemoine','Céline'),('Perez','Diego');
INSERT INTO vehicule (immatriculation,type,modele) VALUES
 ('AB-123-CD','MOTO','Yamaha 125'),
 ('EF-456-GH','AUTO','Fiat Panda');