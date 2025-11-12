package com.happypaws.petcare.servlet.pet;

import com.happypaws.petcare.dao.pet.PetDAO;
import com.happypaws.petcare.model.Pet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet("/owner/pets/edit")
public class PetEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String petUid = req.getParameter("uid");
        
        if (petUid == null || petUid.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/owner/pets?error=Pet+not+found");
            return;
        }

        try {
            Pet pet = PetDAO.findByUid(petUid);
            if (pet == null) {
                res.sendRedirect(req.getContextPath() + "/owner/pets?error=Pet+not+found");
                return;
            }

            req.setAttribute("pet", pet);
            RequestDispatcher rd = req.getRequestDispatcher("/views/pet-management/edit-pet.jsp");
            rd.forward(req, res);

        } catch (Exception e) {
            System.err.println("Error in PetEditServlet doGet: " + e.getMessage());
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/owner/pets?error=Server+error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String petUid = req.getParameter("uid");
        String name = req.getParameter("name");
        String species = req.getParameter("species");
        String breed = req.getParameter("breed");
        String dobStr = req.getParameter("dob");
        String sex = req.getParameter("sex");
        String microchipNo = req.getParameter("microchipNo");

        if (petUid == null || petUid.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/owner/pets?error=Pet+not+found");
            return;
        }

        if (name == null || name.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/owner/pets/edit?uid=" + petUid + "&error=Name+is+required");
            return;
        }

        try {
            Pet pet = PetDAO.findByUid(petUid);
            if (pet == null) {
                res.sendRedirect(req.getContextPath() + "/owner/pets?error=Pet+not+found");
                return;
            }

            // Update pet details
            pet.setName(name.trim());
            pet.setSpecies(species != null ? species.trim() : null);
            pet.setBreed(breed != null ? breed.trim() : null);
            pet.setSex(sex != null ? sex.trim() : null);
            pet.setMicrochipNo(microchipNo != null ? microchipNo.trim() : null);

            // Parse date of birth
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    pet.setDob(LocalDate.parse(dobStr, DateTimeFormatter.ISO_LOCAL_DATE));
                } catch (Exception e) {
                    System.err.println("Error parsing date: " + e.getMessage());
                    // Continue without updating the date
                }
            }

            PetDAO.update(pet);

            res.sendRedirect(req.getContextPath() + "/owner/pets?success=Pet+updated+successfully");

        } catch (Exception e) {
            System.err.println("Error in PetEditServlet doPost: " + e.getMessage());
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/owner/pets/edit?uid=" + petUid + "&error=Server+error");
        }
    }
}