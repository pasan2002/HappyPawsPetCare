package com.happypaws.petcare.servlet.user;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        handleLogout(req, res);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        handleLogout(req, res);
    }
    
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Get current session
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Log the logout activity
            String authType = (String) session.getAttribute("authType");
            String userId = (String) session.getAttribute("userId");
            
            // Clear all session attributes
            session.removeAttribute("authType");
            session.removeAttribute("userId");
            session.removeAttribute("staffRole");
            session.removeAttribute("userType");
            
            // Invalidate the session completely
            session.invalidate();
            
            // Optional: Log the logout
            if (authType != null && userId != null) {
                System.out.println("User " + userId + " (" + authType + ") logged out");
            }
        }
        
        // Prevent caching of this response
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Redirect to login page with logout message
        String contextPath = request.getContextPath();
        response.sendRedirect(contextPath + "/views/user-management/login.jsp?message=logged_out");
    }
}



