package com.happypaws.petcare.servlet.user;

import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.model.Owner;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/owner-profile")
public class OwnerProfileServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
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
            // Get owner information
            Owner owner = OwnerDAO.findById(ownerId);
            System.out.println("DEBUG: Loading profile for owner ID: " + ownerId);
            System.out.println("DEBUG: Owner found: " + (owner != null));
            if (owner != null) {
                System.out.println("DEBUG: Owner details - Name: " + owner.getFullName() + ", Email: " + owner.getEmail());
                System.out.println("DEBUG: Owner ID: " + owner.getOwnerId());
            }
            
            req.setAttribute("owner", owner);
            System.out.println("DEBUG: Owner set as request attribute");
            
            RequestDispatcher rd = req.getRequestDispatcher("/views/user-management/owner-profile.jsp");
            rd.forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG: Error loading profile: " + e.getMessage());
            req.setAttribute("error", "Error loading profile information: " + e.getMessage());
            RequestDispatcher rd = req.getRequestDispatcher("/views/user-management/owner-profile.jsp");
            rd.forward(req, res);
        }
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
            // Get form parameters (only phone can be updated)
            String phone = req.getParameter("phone");

            // Get current owner information
            Owner owner = OwnerDAO.findById(ownerId);
            if (owner == null) {
                req.setAttribute("error", "Owner not found.");
                doGet(req, res);
                return;
            }

            // Update only the phone number (fullName and email are read-only)
            owner.setPhone(phone != null ? phone.trim() : null);

            // Save to database
            OwnerDAO.update(owner);

            // Update session with new name
            session.setAttribute("ownerName", owner.getFullName());

            // Set success message
            req.setAttribute("message", "Profile updated successfully!");
            req.setAttribute("owner", owner);
            
            RequestDispatcher rd = req.getRequestDispatcher("/views/user-management/owner-profile.jsp");
            rd.forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error updating profile: " + e.getMessage());
            doGet(req, res);
        }
    }
}