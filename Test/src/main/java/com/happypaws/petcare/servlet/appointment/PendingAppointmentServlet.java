package com.happypaws.petcare.servlet.appointment;

import com.happypaws.petcare.dao.pet.PetDAO;
import com.happypaws.petcare.model.Pet;

import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Handles appointment request submission by storing data in session
 * instead of creating in DB immediately. Redirects to payment selection.
 * Appointment is only created after payment method is chosen.
 */
@WebServlet("/appointments/pending")
public class PendingAppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            HttpSession session = req.getSession(false);
            if (session == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            // Get owner ID from session
            Object o = session.getAttribute("ownerId");
            Integer ownerId = null;
            if (o instanceof Number) {
                ownerId = ((Number) o).intValue();
            } else if (o != null) {
                try {
                    ownerId = Integer.valueOf(o.toString());
                } catch (NumberFormatException ignored) {
                }
            }

            if (ownerId == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            // Get form fields
            String petUid = req.getParameter("petUid");
            String type = req.getParameter("type");
            String date = req.getParameter("date");
            String time = req.getParameter("time");
            String phoneNo = req.getParameter("phoneNo");
            String staffIdStr = req.getParameter("staffId");

            // Validate required fields
            if (petUid == null || petUid.isBlank() ||
                    type == null || type.isBlank() ||
                    date == null || date.isBlank() ||
                    time == null || time.isBlank()) {
                forwardBackWithError(req, res, petUid, "Please fill all required fields.");
                return;
            }

            // Validate pet belongs to owner
            Pet pet;
            try {
                pet = PetDAO.findByUid(petUid);
            } catch (Exception ex) {
                pet = null;
            }
            if (pet == null) {
                forwardBackWithError(req, res, petUid, "Pet not found.");
                return;
            }
            if (!ownerId.equals(pet.getOwnerId())) {
                forwardBackWithError(req, res, petUid, "This pet does not belong to you.");
                return;
            }

            // Parse staff ID
            Integer staffId = null;
            if (staffIdStr != null && !staffIdStr.isBlank()) {
                try {
                    staffId = Integer.valueOf(staffIdStr);
                } catch (NumberFormatException ignored) {
                }
            }

            // Calculate fee based on type
            BigDecimal fee;
            switch (type.trim().toLowerCase()) {
                case "veterinary":
                    fee = new BigDecimal("3500");
                    break;
                case "grooming":
                    fee = new BigDecimal("3000");
                    break;
                default:
                    fee = BigDecimal.ZERO;
            }

            // Parse date and time
            LocalDateTime scheduledAt = LocalDateTime.parse(date + "T" + time);

            // Store appointment data in session
            Map<String, Object> pendingAppointment = new HashMap<>();
            pendingAppointment.put("petUid", petUid.trim());
            pendingAppointment.put("ownerId", ownerId);
            pendingAppointment.put("staffId", staffId);
            pendingAppointment.put("type", type.trim());
            pendingAppointment.put("scheduledAt", scheduledAt);
            pendingAppointment.put("phoneNo", phoneNo != null ? phoneNo.trim() : null);
            pendingAppointment.put("fee", fee);
            pendingAppointment.put("status", "pending");

            session.setAttribute("pendingAppointment", pendingAppointment);

            // Redirect to payment selection
            res.sendRedirect(req.getContextPath() + "/pay/select/pending");

        } catch (Exception e) {
            String petUid = req.getParameter("petUid");
            forwardBackWithError(req, res, petUid, "Failed to process appointment request: " + e.getMessage());
        }
    }

    private void forwardBackWithError(HttpServletRequest req, HttpServletResponse res,
                                      String petUid, String msg) throws IOException {
        req.setAttribute("error", msg);
        try {
            if (petUid != null && !petUid.isBlank()) {
                try {
                    req.setAttribute("pet", PetDAO.findByUid(petUid));
                } catch (Exception ignored) {
                }
            }
            RequestDispatcher rd = req.getRequestDispatcher("/views/appointment-management/appointment_request.jsp");
            rd.forward(req, res);
        } catch (Exception ex) {
            res.sendError(400, msg);
        }
    }
}
