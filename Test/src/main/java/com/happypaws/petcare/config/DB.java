package com.happypaws.petcare.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DB {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=SEP2;encrypt=false";
    private static final String USER = "sa";
    private static final String PASSWORD = "123";

    private static Connection connection;

    private DB() {}

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("SQL Server JDBC Driver not found", e);
        }
    }

    // Get database connection with validation
    private static synchronized Connection getDatabaseConnection() throws SQLException {
        if (!isConnectionValid(connection)) {
            closeConnection();
            connection = createNewConnection();
            System.out.println("Created new database connection");
        }
        return connection;
    }

    /**
     * Creates a new SQL Server connection with optimized timeout and performance settings.
     * Includes parameters for connection stability, query execution, and application monitoring.
     */
    private static Connection createNewConnection() throws SQLException {
        String connectionUrl = URL +
                ";loginTimeout=30" +
                ";socketTimeout=0" +
                ";lockTimeout=30000" +
                ";selectMethod=direct" +
                ";sendTimeAsDateTime=false" +
                ";trustServerCertificate=true" +
                ";applicationName=HappyPawsApp";

        return DriverManager.getConnection(connectionUrl, USER, PASSWORD);
    }

    // Check if connection is valid
    private static boolean isConnectionValid(Connection conn) {
        try {
            return conn != null && !conn.isClosed() && conn.isValid(2);
        } catch (SQLException e) {
            System.err.println("Connection validation failed: " + e.getMessage());
            return false;
        }
    }

    // Get connection with retry mechanism
    public static Connection getConnection() throws Exception {
        int maxRetries = 3;
        int currentAttempt = 0;
        Exception lastException = null;

        while (currentAttempt < maxRetries) {
            try {
                return getDatabaseConnection();
            } catch (SQLException e) {
                lastException = e;
                currentAttempt++;
                System.err.println("Database connection attempt " + currentAttempt + " failed: " + e.getMessage());

                if (currentAttempt < maxRetries) {
                    closeConnection();
                    try {
                        Thread.sleep(1000 * currentAttempt);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        throw new Exception("Connection retry interrupted", ie);
                    }
                }
            }
        }

        throw new Exception("Failed to establish database connection after " + maxRetries + " attempts", lastException);
    }

    // Method to close the connection
    public static synchronized void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                connection = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}



