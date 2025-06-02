package com.rapizz.dao;

import com.rapizz.model.Pizza;
import java.sql.*;
import java.util.*;

public class PizzaDAO extends AbstractDAO {

    public List<Pizza> findAll() {
        String sql = "SELECT pizza_id, nom, prix_base FROM pizza ORDER BY nom";
        try (PreparedStatement ps = getConnection().prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Pizza> list = new ArrayList<>();
            while (rs.next()) {
                list.add(new Pizza(rs.getInt(1), rs.getString(2), rs.getBigDecimal(3)));
            }
            return list;

        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        }
    }
}
