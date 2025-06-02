package com.rapizz.ui.panels;

import javax.swing.*;
import java.awt.*;
import java.util.List;
import java.util.Vector;

import com.rapizz.model.Pizza;
import com.rapizz.dao.PizzaDAO;
import com.rapizz.service.LivraisonService;

/**
 * Formulaire ultraminimal : saisir l’ID client, choisir une pizza et valider.
 * Les autres paramètres (taille, livreur, véhicule) sont fixés en dur pour l’exemple.
 */
public class CommandePanel extends JPanel {

    private final JTextField txtClientId = new JTextField(6);
    private final JComboBox<Pizza> cboPizza;
    private final JButton btnValider = new JButton("Passer commande");
    private final LivraisonService livraisonService = new LivraisonService();

    public CommandePanel() {
        setLayout(new FlowLayout(FlowLayout.LEFT, 10, 10));

        /* --- Remplir la combo avec les pizzas depuis la base --- */
        List<Pizza> pizzas = new PizzaDAO().findAll();
        cboPizza = new JComboBox<>(new Vector<>(pizzas));

        add(new JLabel("Client ID :"));
        add(txtClientId);
        add(new JLabel("Pizza :"));
        add(cboPizza);
        add(btnValider);

        btnValider.addActionListener(e -> passerCommande());
    }

    private void passerCommande() {
        try {
            int clientId = Integer.parseInt(txtClientId.getText().trim());
            Pizza pizza = (Pizza) cboPizza.getSelectedItem();

            /* taille 'M', livreur 1, véhicule 1 juste pour tester */
            int newLivraisonId = livraisonService.placerLivraison(
                    clientId,
                    pizza.getId(),
                    'M',
                    1,
                    1
            );
            JOptionPane.showMessageDialog(this,
                    "Commande enregistrée ! ID livraison : " + newLivraisonId,
                    "Succès", JOptionPane.INFORMATION_MESSAGE);
        } catch (NumberFormatException nfe) {
            JOptionPane.showMessageDialog(this,
                    "ID client invalide.",
                    "Erreur", JOptionPane.ERROR_MESSAGE);
        } catch (Exception ex) {
            /* propager toute erreur JDBC */
            JOptionPane.showMessageDialog(this,
                    ex.getMessage(),
                    "Erreur", JOptionPane.ERROR_MESSAGE);
        }
    }
}
