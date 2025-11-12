package com.happypaws.petcare.servlet.pet;

import com.happypaws.petcare.dao.pet.PetDAO;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/owner/pets/delete")
public class PetDeleteServlet extends HttpServlet {

    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Read JSON body
            Map<String, String> requestBody = mapper.readValue(req.getInputStream(), Map.class);
            String petUid = requestBody.get("uid");
            
            if (petUid == null || petUid.trim().isEmpty()) {
                result.put("error", "Pet UID is required");
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), result);
                return;
            }

            // Check if pet exists
            var pet = PetDAO.findByUid(petUid);
            if (pet == null) {
                result.put("error", "Pet not found");
                res.setStatus(404);
                mapper.writeValue(res.getOutputStream(), result);
                return;
            }

            // Delete the pet
            PetDAO.deleteByUid(petUid);
            
            result.put("status", "success");
            result.put("message", "Pet deleted successfully");
            mapper.writeValue(res.getOutputStream(), result);

        } catch (Exception e) {
            System.err.println("Error in PetDeleteServlet: " + e.getMessage());
            e.printStackTrace();
            
            result.put("error", "Failed to delete pet: " + e.getMessage());
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), result);
        }
    }
}