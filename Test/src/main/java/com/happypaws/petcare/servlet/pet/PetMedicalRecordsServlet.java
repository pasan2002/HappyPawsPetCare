package com.happypaws.petcare.servlet.pet;

import com.happypaws.petcare.dao.medical.MedicalRecordDAO;
import com.happypaws.petcare.dao.pet.PetDAO;
import com.happypaws.petcare.model.MedicalRecord;
import com.happypaws.petcare.model.Pet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/owner/pets/medical-records")
public class PetMedicalRecordsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Check session for owner access
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp");
            return;
        }

        // Check if user is owner
        String authType = (String) session.getAttribute("authType");
        if (authType == null || !authType.equals("owner")) {
            res.sendError(403, "Access denied. Owner access required.");
            return;
        }

        String petUid = req.getParameter("petUid");
        if (petUid == null || petUid.trim().isEmpty()) {
            res.sendError(400, "Pet UID is required.");
            return;
        }

        try {
            // Get the pet information
            Pet pet = PetDAO.findByUid(petUid);
            if (pet == null) {
                res.sendError(404, "Pet not found.");
                return;
            }

            // Verify pet belongs to this owner
            Integer ownerId = (Integer) session.getAttribute("ownerId");
            if (ownerId == null || !pet.getOwnerId().equals(ownerId)) {
                res.sendError(403, "Access denied. This pet does not belong to you.");
                return;
            }

            // Get medical records for this pet
            List<MedicalRecord> records = MedicalRecordDAO.findByPetUid(petUid);
            
            req.setAttribute("pet", pet);
            req.setAttribute("records", records);
            
            RequestDispatcher rd = req.getRequestDispatcher("/views/pet-management/pet-medical-records.jsp");
            rd.forward(req, res);
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendError(500, "Unable to load medical records: " + e.getMessage());
        }
    }
}
