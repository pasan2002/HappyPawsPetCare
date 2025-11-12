package com.happypaws.petcare.listener;

import com.happypaws.petcare.config.DB;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.concurrent.ConcurrentHashMap;

@WebListener
public class ContextListener implements ServletContextListener {
    
    // Store active sessions for cleanup on shutdown
    private static final ConcurrentHashMap<String, HttpSession> activeSessions = new ConcurrentHashMap<>();
    
    public static void addSession(HttpSession session) {
        activeSessions.put(session.getId(), session);
    }
    
    public static void removeSession(String sessionId) {
        activeSessions.remove(sessionId);
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Happy Paws PetCare Application Started");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Happy Paws PetCare Application Shutting Down - Cleaning up sessions");
        
        // Clean up all active sessions
        for (HttpSession session : activeSessions.values()) {
            try {
                if (session != null) {
                    // Log session cleanup
                    String authType = (String) session.getAttribute("authType");
                    String userId = (String) session.getAttribute("userId");
                    
                    if (authType != null && userId != null) {
                        System.out.println("Cleaning up session for user: " + userId + " (" + authType + ")");
                    }
                    
                    // Clear session attributes
                    session.removeAttribute("authType");
                    session.removeAttribute("userId");
                    session.removeAttribute("staffRole");
                    session.removeAttribute("userType");
                    
                    // Invalidate session
                    session.invalidate();
                }
            } catch (Exception e) {
                // Session might already be invalidated, ignore
                System.out.println("Session already invalidated or error occurred: " + e.getMessage());
            }
        }
        
        activeSessions.clear();
        System.out.println("Session cleanup completed");
        
        // Close database connections
        System.out.println("Closing database connections...");
        try {
            DB.closeConnection();
            System.out.println("Database connections closed successfully");
        } catch (Exception e) {
            System.out.println("Error closing database connections: " + e.getMessage());
        }
        
        // Deregister JDBC drivers to prevent memory leaks
        System.out.println("Deregistering JDBC drivers...");
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                System.out.println("Deregistered JDBC driver: " + driver.getClass().getName());
            } catch (SQLException e) {
                System.out.println("Error deregistering driver " + driver.getClass().getName() + ": " + e.getMessage());
            }
        }
        
        System.out.println("Application shutdown complete");
    }
}