package com.rapizz.service;

import com.rapizz.dao.AbstractDAO;
import java.sql.*;

/** Exemple de service appelant une procédure stockée */
public class LivraisonService extends AbstractDAO {
    public int placerLivraison(int client, int pizza, char taille, int livreur, int vehicule) {
        String sql = "SELECT placer_livraison(?,?,?,?,?)";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, client);
            ps.setInt(2, pizza);
            ps.setString(3, String.valueOf(taille));
            ps.setInt(4, livreur);
            ps.setInt(5, vehicule);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        }
        return -1;
    }
}
