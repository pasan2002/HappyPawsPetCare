package com.happypaws.petcare.servlet.user;

import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.model.Owner;
import com.happypaws.petcare.util.PasswordUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/owner-change-password")
public class OwnerChangePasswordServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Check authentication
        HttpSession session = req.getSession(false);
        if (session == null || !"owner".equals(session.getAttribute("authType"))) {
            res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp?error=Please+login+as+owner");
            return;
        }

        RequestDispatcher rd = req.getRequestDispatcher("/views/user-management/owner-change-password.jsp");
        rd.forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Check authentication
        HttpSession session = req.getSession(false);
        if (session == null || !"owner".equals(session.getAttribute("authType"))) {
            res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp?error=Please+login+as+owner");
            return;
        }

        // Get owner ID from session
        Object attr = session.getAttribute("ownerId");
        Integer ownerId = null;
        if (attr instanceof Number) {
            ownerId = ((Number) attr).intValue();
        } else if (attr != null) {
            try { 
                ownerId = Integer.valueOf(attr.toString()); 
            } catch (NumberFormatException e) {
                // Handle error
            }
        }

        if (ownerId == null) {
            res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp?error=Please+login+as+owner");
            return;
        }

        try {
            // Get form parameters
            String currentPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");

            System.out.println("DEBUG: Password change attempt for owner ID: " + ownerId);
            System.out.println("DEBUG: Current password provided: " + (currentPassword != null && !currentPassword.isEmpty()));
            System.out.println("DEBUG: New password provided: " + (newPassword != null && !newPassword.isEmpty()));

            // Validate required fields
            if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
                
                req.setAttribute("error", "All password fields are required.");
                doGet(req, res);
                return;
            }

            // Validate password confirmation
            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("error", "New passwords do not match.");
                doGet(req, res);
                return;
            }

            // Validate password length
            if (newPassword.length() < 8) {
                req.setAttribute("error", "New password must be at least 8 characters long.");
                doGet(req, res);
                return;
            }

            // Get current owner information
            Owner owner = OwnerDAO.findById(ownerId);
            if (owner == null) {
                System.out.println("DEBUG: Owner not found for ID: " + ownerId);
                req.setAttribute("error", "Owner not found.");
                doGet(req, res);
                return;
            }

            System.out.println("DEBUG: Owner found: " + owner.getEmail());
            System.out.println("DEBUG: Current password hash exists: " + (owner.getPasswordHash() != null));

            // Verify current password
            if (!PasswordUtil.verify(currentPassword, owner.getPasswordHash())) {
                System.out.println("DEBUG: Current password verification failed");
                req.setAttribute("error", "Current password is incorrect.");
                doGet(req, res);
                return;
            }

            System.out.println("DEBUG: Current password verified successfully");

            // Hash new password
            String hashedNewPassword = PasswordUtil.hash(newPassword);
            System.out.println("DEBUG: New password hashed successfully");
            
            // Update password
            boolean updateSuccess = OwnerDAO.updatePassword(ownerId, hashedNewPassword);
            System.out.println("DEBUG: Password update result: " + updateSuccess);

            if (!updateSuccess) {
                req.setAttribute("error", "Failed to update password. Please try again.");
                doGet(req, res);
                return;
            }

            // Set success message
            req.setAttribute("success", "Password updated successfully!");
            System.out.println("DEBUG: Password change completed successfully");
            
            // Forward to the same page to show success message
            RequestDispatcher rd = req.getRequestDispatcher("/views/user-management/owner-change-password.jsp");
            rd.forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error updating password: " + e.getMessage());
            doGet(req, res);
        }
    }
}