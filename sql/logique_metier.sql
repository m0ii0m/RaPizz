-- Procédure
CREATE OR REPLACE FUNCTION placer_livraison(
    _client INT,
    _pizza  INT,
    _taille CHAR(1),
    _livreur INT,
    _vehicule INT
) RETURNS INT AS $$
DECLARE
    _prix NUMERIC(6,2);
    _gratuite BOOLEAN := FALSE;
    _raison TEXT := NULL;
    _id INT;
BEGIN
  -- calcul du prix
  SELECT ROUND(p.prix_base * t.facteur_prix,2)
    INTO _prix
    FROM pizza p JOIN taille t ON t.taille_code = _taille
   WHERE p.pizza_id = _pizza;

  -- gestion fidélité
  SELECT pizzas_payees_compteur
    INTO STRICT _id
    FROM client WHERE client_id=_client;

  IF _id >= 9 THEN  -- 10e pizza
     _gratuite := TRUE;
     _raison   := 'FIDELITE';
     _prix     := 0;
     UPDATE client SET pizzas_payees_compteur = 0 WHERE client_id=_client;
  END IF;

  -- vérification solde
  IF NOT _gratuite THEN
    UPDATE client SET solde = solde - _prix,
                      pizzas_payees_compteur = pizzas_payees_compteur + 1
    WHERE client_id = _client AND solde >= _prix;
    IF NOT FOUND THEN
       RAISE EXCEPTION 'Solde insuffisant';
    END IF;
  END IF;

  -- insertion livraison
  INSERT INTO livraison (client_id,pizza_id,taille_code,livreur_id,vehicule_id,prix_facture,gratuite,raison_gratuite)
  VALUES (_client,_pizza,_taille,_livreur,_vehicule,_prix,_gratuite,_raison)
  RETURNING livraison_id INTO _id;

  RETURN _id;
END;$$ LANGUAGE plpgsql;

-- Trigger retard

CREATE OR REPLACE FUNCTION check_retard() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.date_livraison IS NOT NULL
     AND NEW.date_livraison > NEW.date_commande + INTERVAL '30 minutes'
     AND NEW.gratuite = FALSE THEN
       UPDATE client SET solde = solde + NEW.prix_facture
        WHERE client_id = NEW.client_id;
       NEW.gratuite := TRUE;
       NEW.raison_gratuite := 'RETARD';
       NEW.prix_facture := 0;
  END IF;
  RETURN NEW;
END;$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_retard
AFTER UPDATE OF date_livraison ON livraison
FOR EACH ROW EXECUTE FUNCTION check_retard();