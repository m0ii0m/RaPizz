-- Menu
SELECT p.nom AS pizza,
       t.libelle AS taille,
       ROUND(p.prix_base * t.facteur_prix,2) AS prix,
       STRING_AGG(i.libelle, ', ' ORDER BY i.libelle) AS ingredients
FROM pizza p
JOIN pizza_ingredient pi ON pi.pizza_id = p.pizza_id
JOIN ingredient i        ON i.ingredient_id = pi.ingredient_id
CROSS JOIN taille t
GROUP BY p.pizza_id, p.nom, t.taille_code, t.libelle, t.facteur_prix
ORDER BY p.nom, t.taille_code;

-- Fiche de livraison
SELECT l.livraison_id,
       li.nom || ' ' || li.prenom      AS livreur,
       v.type || ' ' || v.modele       AS vehicule,
       c.nom || ' ' || c.prenom        AS client,
       l.date_commande,
       l.date_livraison,
       CASE WHEN l.date_livraison > l.date_commande + INTERVAL '30 minutes'
            THEN 'RETARD' ELSE 'OK' END AS statut,
       p.nom  AS pizza,
       p.prix_base                      AS prix_base
FROM livraison l
JOIN livreur li ON li.livreur_id = l.livreur_id
JOIN vehicule v ON v.vehicule_id = l.vehicule_id
JOIN client  c ON c.client_id = l.client_id
JOIN pizza   p ON p.pizza_id  = l.pizza_id
ORDER BY l.livraison_id;

-- Véhicules n’ayant jamais servi
SELECT v.*
FROM vehicule v
LEFT JOIN livraison l ON l.vehicule_id = v.vehicule_id
WHERE l.vehicule_id IS NULL;

-- Nombre de commandes par client
SELECT c.client_id, c.nom, c.prenom, COUNT(l.livraison_id) AS nb_commandes
FROM client c
LEFT JOIN livraison l ON l.client_id = c.client_id
GROUP BY c.client_id, c.nom, c.prenom;

-- Moyenne de commandes
WITH stats AS (
  SELECT COUNT(*) AS nb FROM livraison
)
SELECT AVG(nb) FROM (
  SELECT COUNT(*) AS nb
  FROM livraison
  GROUP BY client_id
) s;

-- Clients au‑dessus de la moyenne
WITH nb_par_client AS (
  SELECT client_id, COUNT(*) AS nb
  FROM livraison
  GROUP BY client_id
),
  moyenne AS (
  SELECT AVG(nb) AS moy FROM nb_par_client
)
SELECT c.* , n.nb
FROM client c
JOIN nb_par_client n ON n.client_id = c.client_id
JOIN moyenne m ON n.nb > m.moy;