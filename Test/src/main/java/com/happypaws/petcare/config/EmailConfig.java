package com.happypaws.petcare.config;

import java.util.Properties;
import javax.mail.Session;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

/**
 * Email configuration for Gmail SMTP
 * Environment variables required:
 * - EMAIL_USERNAME: Your Gmail address
 * - EMAIL_PASSWORD: Your Gmail app password (not your regular password)
 */
public class EmailConfig {
    
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    public static final String SENDER_NAME = "Happy Paws PetCare";
    
    // Private constructor to prevent instantiation
    private EmailConfig() {
        throw new UnsupportedOperationException("Utility class");
    }
    
    public static Session getEmailSession() {
        // Gmail SMTP configuration
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.debug", "false"); // Set to true for debugging
        
        // Authentication
        String username = System.getenv("EMAIL_USERNAME");
        String password = System.getenv("EMAIL_PASSWORD");
        
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalStateException("Email username not configured. Please set EMAIL_USERNAME environment variable to your Gmail address.");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalStateException("Email password not configured. Please set EMAIL_PASSWORD environment variable to your Gmail app password.");
        }
        
        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
    }
    
    public static String getSenderEmail() {
        return System.getenv("EMAIL_USERNAME");
    }
}