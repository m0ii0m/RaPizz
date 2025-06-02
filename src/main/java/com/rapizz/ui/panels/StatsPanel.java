package com.rapizz.ui.panels;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.sql.*;

import com.rapizz.dao.AbstractDAO;

/**
 * Tableau de statistiques : nombre de livraisons par pizza.
 * S’appuie sur une requête SQL directe pour la démonstration.
 */
public class StatsPanel extends JPanel {

    private final DefaultTableModel model = new DefaultTableModel(
            new Object[] { "Pizza", "Total livraisons" }, 0) {
        @Override public boolean isCellEditable(int r, int c) { return false; }
    };

    public StatsPanel() {
        setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
        JTable table = new JTable(model);
        add(new JScrollPane(table));
        chargerStats();
    }

    private void chargerStats() {
        String sql = """
                     SELECT p.nom,
                            COUNT(*) AS total
                       FROM livraison l
                       JOIN pizza p ON p.pizza_id = l.pizza_id
                      GROUP BY p.nom
                      ORDER BY total DESC
                     """;
        try (Connection c = AbstractDAO.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            model.setRowCount(0);                    // reset
            while (rs.next()) {
                model.addRow(new Object[] {
                        rs.getString("nom"),
                        rs.getInt("total")
                });
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this,
                    ex.getMessage(),
                    "Erreur SQL", JOptionPane.ERROR_MESSAGE);
        }
    }
}
