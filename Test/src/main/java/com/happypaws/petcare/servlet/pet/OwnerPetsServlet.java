package com.happypaws.petcare.servlet.pet;

import com.happypaws.petcare.dao.pet.PetDAO;
import com.happypaws.petcare.model.Pet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@WebServlet("/owner/pets")
public class OwnerPetsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Don't create a new session by accident
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Be tolerant to different stored types (Integer, Long, String)
        Object attr = session.getAttribute("ownerId"); // <-- make sure this key matches your login code
        Integer ownerId = null;
        if (attr instanceof Number) {
            ownerId = ((Number) attr).intValue();
        } else if (attr != null) {
            try { ownerId = Integer.valueOf(attr.toString()); } catch (NumberFormatException ignored) {}
        }

        if (ownerId == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<Pet> pets = PetDAO.findByOwner(ownerId);
            req.setAttribute("pets", pets);
            
            // Handle success and error messages from URL parameters
            String success = req.getParameter("success");
            String error = req.getParameter("error");
            if (success != null) {
                req.setAttribute("success", success);
            }
            if (error != null) {
                req.setAttribute("error", error);
            }
            
            RequestDispatcher rd = req.getRequestDispatcher("/views/pet-management/pets.jsp"); // adjust path if needed
            rd.forward(req, res);
        } catch (Exception e) {
            // Log server-side; keep message generic for users
            e.printStackTrace();
            res.sendError(500, "Unable to load pets right now.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Get owner ID from session
        Object attr = session.getAttribute("ownerId");
        Integer ownerId = null;
        if (attr instanceof Number) {
            ownerId = ((Number) attr).intValue();
        } else if (attr != null) {
            try { ownerId = Integer.valueOf(attr.toString()); } catch (NumberFormatException ignored) {}
        }

        if (ownerId == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Get form parameters
            String name = req.getParameter("name");
            String species = req.getParameter("species");
            String breed = req.getParameter("breed");
            String dobStr = req.getParameter("dob");
            String sex = req.getParameter("sex");
            String microchipNo = req.getParameter("microchipNo");

            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                species == null || species.trim().isEmpty()) {
                req.setAttribute("error", "Pet name and species are required fields.");
                doGet(req, res);
                return;
            }

            // Create pet object
            Pet pet = new Pet();
            pet.setPetUid(UUID.randomUUID().toString());
            pet.setOwnerId(ownerId);
            pet.setName(name.trim());
            pet.setSpecies(species.trim());
            pet.setBreed(breed != null ? breed.trim() : null);
            
            // Parse date
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    pet.setDob(LocalDate.parse(dobStr.trim()));
                } catch (Exception e) {
                    req.setAttribute("error", "Please enter a valid date of birth.");
                    doGet(req, res);
                    return;
                }
            }
            
            pet.setSex(sex != null ? sex.trim() : null);
            pet.setMicrochipNo(microchipNo != null ? microchipNo.trim() : null);
            pet.setCreatedAt(LocalDateTime.now());

            // Save to database
            PetDAO.insert(pet);

            // Redirect with success message to avoid form resubmission and page state issues
            res.sendRedirect(req.getContextPath() + "/owner/pets?success=Pet+successfully+registered!");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error registering pet: " + e.getMessage());
            doGet(req, res);
        }
    }
}



