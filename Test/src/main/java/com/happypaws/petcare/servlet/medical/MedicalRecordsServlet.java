package com.happypaws.petcare.servlet.medical;

import com.happypaws.petcare.dao.medical.MedicalRecordDAO;
import com.happypaws.petcare.dao.pet.PetDAO;
import com.happypaws.petcare.dao.user.StaffDAO;
import com.happypaws.petcare.model.MedicalRecord;
import com.happypaws.petcare.model.Pet;
import com.happypaws.petcare.model.Staff;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/medical/records")
public class MedicalRecordsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Check session for admin/staff access
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp");
            return;
        }

        // Check if user is admin or staff (check authType attribute set by LoginServlet)
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
                // Load record for editing
                String recordIdStr = req.getParameter("id");
                if (recordIdStr != null) {
                    int recordId = Integer.parseInt(recordIdStr);
                    MedicalRecord record = MedicalRecordDAO.findById(recordId);
                    
                    // Check if vet can edit this record (only their own records)
                    if (("vet".equals(staffRole) || "veterinarian".equals(staffRole)) && 
                        record != null && !Integer.valueOf(record.getStaffId()).equals(staffId)) {
                        res.sendError(403, "Access denied. You can only edit your own records.");
                        return;
                    }
                    
                    req.setAttribute("editRecord", record);
                }
            }
            
            // Load medical records based on role
            List<MedicalRecord> records;
            if ("vet".equals(staffRole) || "veterinarian".equals(staffRole)) {
                // Vets see only their own records
                records = MedicalRecordDAO.findByStaffId(staffId);
            } else {
                // Admin and other staff see all records
                records = MedicalRecordDAO.getAll();
            }
            req.setAttribute("records", records);
            
            // Load pets and staff for dropdowns
            List<Pet> pets = PetDAO.getAll();
            req.setAttribute("pets", pets);
            
            List<Staff> staffList = StaffDAO.getAll();
            req.setAttribute("staffList", staffList);
            
            RequestDispatcher rd = req.getRequestDispatcher("/views/medical-management/medical_records.jsp");
            rd.forward(req, res);
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendError(500, "Unable to load medical records: " + e.getMessage());
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

        // Check if user is admin or staff (check authType attribute set by LoginServlet)
        String authType = (String) session.getAttribute("authType");
        if (authType == null || (!authType.equals("admin") && !authType.equals("staff"))) {
            res.sendError(403, "Access denied. Admin or Staff access required.");
            return;
        }

        // Get staff role and ID for authorization
        String staffRole = (String) session.getAttribute("staffRole");
        Integer staffId = (Integer) session.getAttribute("staffId");

        String action = req.getParameter("action");
        
        try {
            if ("delete".equals(action)) {
                // Delete record
                String recordIdStr = req.getParameter("recordId");
                if (recordIdStr != null && !recordIdStr.trim().isEmpty()) {
                    int recordId = Integer.parseInt(recordIdStr.trim());
                    
                    // Check if vet can delete this record (only their own records)
                    if ("vet".equals(staffRole) || "veterinarian".equals(staffRole)) {
                        MedicalRecord record = MedicalRecordDAO.findById(recordId);
                        if (record != null && !Integer.valueOf(record.getStaffId()).equals(staffId)) {
                            res.sendError(403, "Access denied. You can only delete your own records.");
                            return;
                        }
                    }
                    
                    MedicalRecordDAO.delete(recordId);
                    req.setAttribute("success", "Medical record deleted successfully!");
                }
            } else if ("update".equals(action)) {
                // Update existing record
                updateRecord(req, staffRole, staffId);
                req.setAttribute("success", "Medical record updated successfully!");
            } else {
                // Create new record
                createRecord(req, staffId);
                req.setAttribute("success", "Medical record created successfully!");
            }
            
            // Reload page
            doGet(req, res);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error processing request: " + e.getMessage());
            doGet(req, res);
        }
    }
    
    private void createRecord(HttpServletRequest req, Integer loggedInStaffId) throws Exception {
        String petUidStr = req.getParameter("petUid");
        String staffIdStr = req.getParameter("staffId");
        String visitTimeStr = req.getParameter("visitTime");
        String weightStr = req.getParameter("weightKg");
        String notes = req.getParameter("notes");
        
        // Validate required fields
        if (petUidStr == null || petUidStr.trim().isEmpty() ||
            staffIdStr == null || staffIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Pet and Staff are required fields.");
        }
        
        MedicalRecord record = new MedicalRecord();
        record.setPetUid(petUidStr.trim());  // uniqueidentifier (String)
        
        // Use the staffId from form, or default to logged-in staff
        int staffId = Integer.parseInt(staffIdStr.trim());
        record.setStaffId(staffId);
        
        // Parse visit time
        if (visitTimeStr != null && !visitTimeStr.trim().isEmpty()) {
            try {
                LocalDateTime visitTime = LocalDateTime.parse(visitTimeStr.trim(), 
                    DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                record.setVisitTime(visitTime);
            } catch (Exception e) {
                record.setVisitTime(LocalDateTime.now());
            }
        } else {
            record.setVisitTime(LocalDateTime.now());
        }
        
        // Parse weight
        if (weightStr != null && !weightStr.trim().isEmpty()) {
            try {
                record.setWeightKg(new BigDecimal(weightStr.trim()));
            } catch (NumberFormatException e) {
                record.setWeightKg(null);
            }
        }
        
        record.setNotes(notes != null ? notes.trim() : "");
        
        MedicalRecordDAO.insert(record);
    }
    
    private void updateRecord(HttpServletRequest req, String staffRole, Integer loggedInStaffId) throws Exception {
        String recordIdStr = req.getParameter("recordId");
        String petUidStr = req.getParameter("petUid");
        String staffIdStr = req.getParameter("staffId");
        String visitTimeStr = req.getParameter("visitTime");
        String weightStr = req.getParameter("weightKg");
        String notes = req.getParameter("notes");
        
        // Validate required fields
        if (recordIdStr == null || recordIdStr.trim().isEmpty() ||
            petUidStr == null || petUidStr.trim().isEmpty() ||
            staffIdStr == null || staffIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Record ID, Pet and Staff are required fields.");
        }
        
        int recordId = Integer.parseInt(recordIdStr.trim());
        
        // Check if vet can update this record (only their own records)
        if ("vet".equals(staffRole) || "veterinarian".equals(staffRole)) {
            MedicalRecord existingRecord = MedicalRecordDAO.findById(recordId);
            if (existingRecord != null && !Integer.valueOf(existingRecord.getStaffId()).equals(loggedInStaffId)) {
                throw new IllegalArgumentException("Access denied. You can only update your own records.");
            }
        }
        
        MedicalRecord record = new MedicalRecord();
        record.setRecordId(recordId);
        record.setPetUid(petUidStr.trim());  // uniqueidentifier (String)
        record.setStaffId(Integer.parseInt(staffIdStr.trim()));
        
        // Parse visit time
        if (visitTimeStr != null && !visitTimeStr.trim().isEmpty()) {
            try {
                LocalDateTime visitTime = LocalDateTime.parse(visitTimeStr.trim(), 
                    DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                record.setVisitTime(visitTime);
            } catch (Exception e) {
                record.setVisitTime(LocalDateTime.now());
            }
        } else {
            record.setVisitTime(LocalDateTime.now());
        }
        
        // Parse weight
        if (weightStr != null && !weightStr.trim().isEmpty()) {
            try {
                record.setWeightKg(new BigDecimal(weightStr.trim()));
            } catch (NumberFormatException e) {
                record.setWeightKg(null);
            }
        }
        
        record.setNotes(notes != null ? notes.trim() : "");
        
        MedicalRecordDAO.update(record);
    }
}
