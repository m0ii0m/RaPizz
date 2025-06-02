package com.rapizz.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public abstract class AbstractDAO {
    private static Connection singleton;

    protected static Connection getConnection() throws SQLException {
        if (singleton == null || singleton.isClosed()) {
            Properties props = new Properties();
            try (var in = AbstractDAO.class.getClassLoader().getResourceAsStream("db.properties")) {
                props.load(in);
            } catch (Exception e) {
                throw new RuntimeException("Unable to load db.properties", e);
            }
            singleton = DriverManager.getConnection(props.getProperty("jdbc.url"), props);
        }
        return singleton;
    }
}
