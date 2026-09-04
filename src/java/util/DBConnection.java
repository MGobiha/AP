package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Singleton design pattern: one shared database connection factory.
 * Callers use {@link #getConnection()} which delegates to the single instance.
 */
public class DBConnection {

    private static volatile DBConnection instance;

    private static final String URL = "jdbc:mysql://localhost:3306/ocean_view_resort?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    private DBConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("MySQL JDBC driver not found", e);
        }
    }

    public static DBConnection getInstance() {
        if (instance == null) {
            synchronized (DBConnection.class) {
                if (instance == null) {
                    instance = new DBConnection();
                }
            }
        }
        return instance;
    }

    public Connection open() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static Connection getConnection() {
        try {
            return getInstance().open();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
