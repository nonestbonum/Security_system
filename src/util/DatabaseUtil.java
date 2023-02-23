package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {

    static final String URL = "jdbc:postgresql://localhost:5432/test_db";
    static final String DRIVER = "org.postgresql.Driver";
    static final String USER = "mrbrann";
    static final String PASS = "postgres";

    public DatabaseUtil() {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}