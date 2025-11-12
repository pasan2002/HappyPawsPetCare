package com.happypaws.petcare.servlet.pet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.happypaws.petcare.dao.pet.PetDAO;
import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.model.Owner;
import com.happypaws.petcare.model.Pet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;

@WebServlet("/api/pets/by-uid")
public class PetByUidServlet extends HttpServlet {
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule())
            .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

    private static final String ERROR_KEY = "error";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");

        try {
            // Require an authenticated session
            HttpSession session = req.getSession(false);
            if (session == null) {
                res.setStatus(401);
                mapper.writeValue(res.getOutputStream(),
                        Collections.singletonMap(ERROR_KEY, "Authentication required"));
                return;
            }

            // Only staff should call this endpoint (receptionist/vet/groomer/pharmacist/manager/admin)
            String authType = (String) session.getAttribute("authType");
            if (!"staff".equalsIgnoreCase(authType)) {
                res.setStatus(403);
                mapper.writeValue(res.getOutputStream(),
                        Collections.singletonMap(ERROR_KEY, "Access denied"));
                return;
            }

            String uid = req.getParameter("uid");
            if (uid == null || uid.trim().isEmpty()) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(),
                        Collections.singletonMap(ERROR_KEY, "Missing 'uid' parameter"));
                return;
            }

            Pet pet = PetDAO.findByUid(uid.trim());
            if (pet == null) {
                res.setStatus(404);
                mapper.writeValue(res.getOutputStream(),
                        Collections.singletonMap(ERROR_KEY, "Pet not found"));
                return;
            }

            // Enrich with owner details if available (best-effort; failures won't break response)
            if (pet.getOwnerId() != null) {
                Owner owner = safeFindOwner(pet.getOwnerId());
                if (owner != null) {
                    pet.setOwnerName(owner.getFullName());
                    pet.setOwnerPhone(owner.getPhone());
                }
            }

            mapper.writeValue(res.getOutputStream(), pet);
        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(),
                    Collections.singletonMap(ERROR_KEY, "Lookup failed: " + e.getMessage()));
        }
    }

    private Owner safeFindOwner(Integer ownerId) {
        try {
            return OwnerDAO.findById(ownerId);
        } catch (Exception e) {
            // Intentionally ignore owner enrichment failures to keep primary payload available
            return null;
        }
    }
}
