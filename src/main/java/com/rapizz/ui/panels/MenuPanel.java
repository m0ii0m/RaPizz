package com.rapizz.ui.panels;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import com.rapizz.dao.PizzaDAO;
import com.rapizz.model.Pizza;
import java.util.List;

public class MenuPanel extends JPanel {

    private final JTable table;
    private final DefaultTableModel model;
    private final PizzaDAO pizzaDAO = new PizzaDAO();

    public MenuPanel() {
        setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

        model = new DefaultTableModel(new Object[]{"ID", "Nom", "Prix base (€)"}, 0) {
            // éviter l’édition des cellules
            @Override public boolean isCellEditable(int row, int column) { return false; }
        };

        table = new JTable(model);
        add(new JScrollPane(table));

        loadData();   // remplissage initial
    }

    private void loadData() {
        List<Pizza> pizzas = pizzaDAO.findAll();
        model.setRowCount(0);                 // vide la table
        pizzas.forEach(p ->
            model.addRow(new Object[]{p.getId(), p.getNom(), p.getPrixBase()})
        );
    }
}
