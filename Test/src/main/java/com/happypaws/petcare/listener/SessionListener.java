package com.happypaws.petcare.listener;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import javax.servlet.http.HttpSession;

@WebListener
public class SessionListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        // Set session timeout to 30 minutes (1800 seconds)
        session.setMaxInactiveInterval(1800);
        
        // Register session with context listener for cleanup
        ContextListener.addSession(session);
        
        System.out.println("Session created: " + session.getId());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        System.out.println("Session destroyed: " + session.getId());
        
        // Unregister session from context listener
        ContextListener.removeSession(session.getId());
        
        // Clean up any session-specific resources
        String authType = (String) session.getAttribute("authType");
        String userId = (String) session.getAttribute("userId");
        
        if (authType != null && userId != null) {
            System.out.println("User " + userId + " (" + authType + ") session ended");
        }
        
        // Clear all session attributes
        session.removeAttribute("authType");
        session.removeAttribute("userId");
        session.removeAttribute("staffRole");
        session.removeAttribute("userType");
    }
}