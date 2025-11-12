package com.happypaws.petcare.servlet.appointment;

import com.happypaws.petcare.dao.pet.PetDAO;
import com.happypaws.petcare.model.Pet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/appointments/new")
public class AppointmentRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Object oid = session.getAttribute("ownerId");
        Integer ownerId = null;
        if (oid instanceof Number) ownerId = ((Number) oid).intValue();
        else if (oid != null) try { ownerId = Integer.valueOf(oid.toString()); } catch (NumberFormatException ignore) {}

        if (ownerId == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String petUid = req.getParameter("petUid");
        if (petUid == null || petUid.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/owner/pets");
            return;
        }

        try {
            Pet pet = PetDAO.findByUid(petUid);
            if (pet == null) {
                res.sendError(404, "Pet not found");
                return;
            }
            if (!ownerId.equals(pet.getOwnerId())) {
                res.sendError(403, "You do not own this pet.");
                return;
            }

            req.setAttribute("pet", pet);
            req.setAttribute("today", LocalDate.now().toString());
            RequestDispatcher rd = req.getRequestDispatcher("/views/appointment-management/appointment_request.jsp");
            rd.forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
            res.sendError(500, "Unable to open appointment request page.");
        }
    }
}



