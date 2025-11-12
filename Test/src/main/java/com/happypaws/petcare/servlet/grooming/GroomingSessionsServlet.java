package com.happypaws.petcare.servlet.grooming;

import com.happypaws.petcare.dao.grooming.GroomingSessionDAO;
import com.happypaws.petcare.dao.pet.PetDAO;
import com.happypaws.petcare.dao.user.StaffDAO;
import com.happypaws.petcare.model.GroomingSession;
import com.happypaws.petcare.model.Pet;
import com.happypaws.petcare.model.Staff;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/grooming/sessions")
public class GroomingSessionsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Check session for admin/staff access
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp");
            return;
        }

        // Check if user is admin or staff
        String authType = (String) session.getAttribute("authType");
        if (authType == null || (!authType.equals("admin") && !authType.equals("staff"))) {
            res.sendError(403, "Access denied. Admin or Staff access required.");
            return;
        }

        // Get staff role and ID for filtering
        String staffRole = (String) session.getAttribute("staffRole");
        Integer staffId = (Integer) session.getAttribute("staffId");

        String action = req.getParameter("action");
        
        try {
            if ("edit".equals(action)) {
                // Load session for editing
                String sessionIdStr = req.getParameter("id");
                if (sessionIdStr != null) {
                    int sessionId = Integer.parseInt(sessionIdStr);
                    GroomingSession groomingSession = GroomingSessionDAO.findById(sessionId);
                    
                    // Check if groomer can edit this session (only their own sessions)
                    if ("groomer".equals(staffRole) && 
                        groomingSession != null && !groomingSession.getStaffId().equals(staffId)) {
                        res.sendError(403, "Access denied. You can only edit your own grooming sessions.");
                        return;
                    }
                    
                    req.setAttribute("editSession", groomingSession);
                }
            }
            
            // Load grooming sessions based on role
            List<GroomingSession> sessions;
            if ("groomer".equals(staffRole)) {
                // Groomers see only their own sessions
                sessions = GroomingSessionDAO.findByStaffId(staffId);
            } else {
                // Admin and other staff see all sessions
                sessions = GroomingSessionDAO.getAll();
            }
            req.setAttribute("sessions", sessions);
            
            // Load pets and staff for dropdowns
            List<Pet> pets = PetDAO.getAll();
            req.setAttribute("pets", pets);
            
            List<Staff> staffList = StaffDAO.getAll();
            req.setAttribute("staffList", staffList);
            
            RequestDispatcher rd = req.getRequestDispatcher("/views/grooming-management/grooming_sessions.jsp");
            rd.forward(req, res);
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendError(500, "Unable to load grooming sessions: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Check session for admin/staff access
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp");
            return;
        }

        // Check if user is admin or staff
        String authType = (String) session.getAttribute("authType");
        if (authType == null || (!authType.equals("admin") && !authType.equals("staff"))) {
            res.sendError(403, "Access denied. Admin or Staff access required.");
            return;
        }

        // Get staff role and ID for authorization
        String staffRole = (String) session.getAttribute("staffRole");
        Integer staffId = (Integer) session.getAttribute("staffId");

        String action = req.getParameter("action");
        
        System.out.println("DEBUG doPost - action: '" + action + "'");
        System.out.println("DEBUG doPost - All parameters: " + req.getParameterMap().keySet());
        System.out.println("DEBUG doPost - sessionId param: '" + req.getParameter("sessionId") + "'");
        
        try {
            if ("delete".equals(action)) {
                // Delete session
                String sessionIdStr = req.getParameter("sessionId");
                System.out.println("DEBUG delete - sessionIdStr: '" + sessionIdStr + "'");
                
                if (sessionIdStr != null && !sessionIdStr.trim().isEmpty()) {
                    int sessionId = Integer.parseInt(sessionIdStr.trim());
                    
                    // Check if groomer can delete this session (only their own sessions)
                    if ("groomer".equals(staffRole)) {
                        GroomingSession groomingSession = GroomingSessionDAO.findById(sessionId);
                        if (groomingSession != null && !groomingSession.getStaffId().equals(staffId)) {
                            res.sendError(403, "Access denied. You can only delete your own grooming sessions.");
                            return;
                        }
                    }
                    
                    GroomingSessionDAO.delete(sessionId);
                    System.out.println("DEBUG delete - Successfully deleted session: " + sessionId);
                    req.setAttribute("success", "Grooming session deleted successfully!");
                } else {
                    System.out.println("DEBUG delete - sessionId is null or empty!");
                }
                // Reload page after delete
                doGet(req, res);
                return; // Important: exit after delete
                
            } else if ("update".equals(action)) {
                // Update existing session
                updateSession(req, staffRole, staffId);
                req.setAttribute("success", "Grooming session updated successfully!");
            } else {
                // Create new session
                createSession(req, staffId);
                req.setAttribute("success", "Grooming session created successfully!");
            }
            
            // Reload page
            doGet(req, res);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error processing request: " + e.getMessage());
            doGet(req, res);
        }
    }
    
    private void createSession(HttpServletRequest req, Integer loggedInStaffId) throws Exception {
        String petUidStr = req.getParameter("petUid");
        String staffIdStr = req.getParameter("staffId");
        String sessionTimeStr = req.getParameter("sessionTime");
        String serviceType = req.getParameter("serviceType");
        String notes = req.getParameter("notes");
        
        // Debug logging
        System.out.println("DEBUG createSession - petUidStr: '" + petUidStr + "'");
        System.out.println("DEBUG createSession - staffIdStr: '" + staffIdStr + "'");
        System.out.println("DEBUG createSession - loggedInStaffId: " + loggedInStaffId);
        
        // Validate required fields
        if (petUidStr == null || petUidStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Pet is required.");
        }
        
        // Use staffId from form if provided, otherwise use logged-in staff
        Integer staffId = null;
        if (staffIdStr != null && !staffIdStr.trim().isEmpty()) {
            staffId = Integer.parseInt(staffIdStr.trim());
        } else if (loggedInStaffId != null) {
            staffId = loggedInStaffId;
        }
        
        if (staffId == null) {
            throw new IllegalArgumentException("Staff ID is required.");
        }
        
        System.out.println("DEBUG createSession - Final staffId to use: " + staffId);
        
        GroomingSession session = new GroomingSession();
        session.setPetUid(petUidStr.trim());  // uniqueidentifier (String)
        session.setStaffId(staffId);
        
        // Parse session time
        if (sessionTimeStr != null && !sessionTimeStr.trim().isEmpty()) {
            try {
                LocalDateTime sessionTime = LocalDateTime.parse(sessionTimeStr.trim(), 
                    DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                session.setSessionTime(sessionTime);
            } catch (Exception e) {
                session.setSessionTime(LocalDateTime.now());
            }
        } else {
            session.setSessionTime(LocalDateTime.now());
        }
        
        session.setServiceType(serviceType != null ? serviceType.trim() : "");
        session.setNotes(notes != null ? notes.trim() : "");
        
        GroomingSessionDAO.insert(session);
    }
    
    private void updateSession(HttpServletRequest req, String staffRole, Integer loggedInStaffId) throws Exception {
        String sessionIdStr = req.getParameter("sessionId");
        String petUidStr = req.getParameter("petUid");
        String staffIdStr = req.getParameter("staffId");
        String sessionTimeStr = req.getParameter("sessionTime");
        String serviceType = req.getParameter("serviceType");
        String notes = req.getParameter("notes");
        
        // Validate required fields
        if (sessionIdStr == null || sessionIdStr.trim().isEmpty() ||
            petUidStr == null || petUidStr.trim().isEmpty() ||
            staffIdStr == null || staffIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Session ID, Pet and Staff are required fields.");
        }
        
        int sessionId = Integer.parseInt(sessionIdStr.trim());
        
        // Check if groomer can update this session (only their own sessions)
        if ("groomer".equals(staffRole)) {
            GroomingSession existingSession = GroomingSessionDAO.findById(sessionId);
            if (existingSession != null && !existingSession.getStaffId().equals(loggedInStaffId)) {
                throw new IllegalArgumentException("Access denied. You can only update your own grooming sessions.");
            }
        }
        
        GroomingSession session = new GroomingSession();
        session.setSessionId(sessionId);
        session.setPetUid(petUidStr.trim());  // uniqueidentifier (String)
        session.setStaffId(Integer.parseInt(staffIdStr.trim()));
        
        // Parse session time
        if (sessionTimeStr != null && !sessionTimeStr.trim().isEmpty()) {
            try {
                LocalDateTime sessionTime = LocalDateTime.parse(sessionTimeStr.trim(), 
                    DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                session.setSessionTime(sessionTime);
            } catch (Exception e) {
                session.setSessionTime(LocalDateTime.now());
            }
        } else {
            session.setSessionTime(LocalDateTime.now());
        }
        
        session.setServiceType(serviceType != null ? serviceType.trim() : "");
        session.setNotes(notes != null ? notes.trim() : "");
        
        GroomingSessionDAO.update(session);
    }
}
