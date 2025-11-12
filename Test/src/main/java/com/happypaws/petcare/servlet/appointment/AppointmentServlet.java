package com.happypaws.petcare.servlet.appointment;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;
import com.happypaws.petcare.dao.pet.PetDAO;
import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.model.Appointment;
import com.happypaws.petcare.model.Pet;
import com.happypaws.petcare.model.Owner;
import com.happypaws.petcare.service.EmailService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.databind.SerializationFeature;

import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

@WebServlet("/appointments")
public class AppointmentServlet extends HttpServlet {
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule())
            .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

    // ---- Friendly error mapping for duplicate active slot ----
    private static final String ACTIVE_SLOT_CONSTRAINT = "UQ_appointments_Pet_Slot_Active"; // your constraint name

    private static boolean isActiveSlotViolation(Throwable t) {
        // Walk causes and JDBC nextException chain
        while (t != null) {
            if (t instanceof SQLException) {
                SQLException se = (SQLException) t;
                int code = se.getErrorCode(); // SQL Server: 2627(unique constraint), 2601(duplicate index key)
                String msg = se.getMessage() == null ? "" : se.getMessage();
                if ((code == 2627 || code == 2601) && msg.contains(ACTIVE_SLOT_CONSTRAINT)) {
                    return true;
                }
                if (se.getNextException() != null && se.getNextException() != se) {
                    t = se.getNextException();
                    continue;
                }
            }
            t = t.getCause();
        }
        return false;
    }

    private static String toFriendlyCreateError(Throwable t) {
        if (isActiveSlotViolation(t)) {
            return "This pet already has an appointment at this time. Please choose a different time.";
        }
        return "Failed to create appointment. Please try again or pick a different time.";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        try {
            // Automatically cancel expired appointments before fetching data
            AppointmentDAO.cancelExpiredAppointments();
            
            String idParam = req.getParameter("id");
            String petUidParam = req.getParameter("petUid");
            String typeParam = req.getParameter("type");
            String statusParam = req.getParameter("status");

            if (idParam != null) {
                int id = Integer.parseInt(idParam);
                Appointment appt = AppointmentDAO.findById(id);
                if (appt == null) {
                    res.setStatus(404);
                    mapper.writeValue(res.getOutputStream(),
                            Collections.singletonMap("error", "Model.AppointmentManagement.Appointment not found"));
                    return;
                }
                mapper.writeValue(res.getOutputStream(), appt);
            } else if ((petUidParam != null && !petUidParam.isBlank()) ||
                    (typeParam != null && !typeParam.isBlank()) ||
                    (statusParam != null && !statusParam.isBlank())) {
                List<Appointment> list = AppointmentDAO.search(petUidParam, typeParam, statusParam);
                mapper.writeValue(res.getOutputStream(), list);
            } else {
                List<Appointment> list = AppointmentDAO.getAll();
                mapper.writeValue(res.getOutputStream(), list);
            }
        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", e.getMessage()));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            String ct = req.getContentType();
            boolean isJson = ct != null && ct.toLowerCase().startsWith("application/json");

            if (isJson) {
                // JSON API path
                Appointment appt = mapper.readValue(req.getInputStream(), Appointment.class);
                if (appt.getPaymentStatus() == null) appt.setPaymentStatus("unpaid");
                try {
                    AppointmentDAO.insert(appt);
                } catch (Exception ex) {
                    if (isActiveSlotViolation(ex)) {
                        res.setStatus(409); // Conflict
                        res.setContentType("application/json; charset=UTF-8");
                        mapper.writeValue(res.getOutputStream(),
                                Collections.singletonMap("error",
                                        "That time slot is already booked for this pet. Please choose a different time."));
                        return;
                    }
                    throw ex;
                }
                res.setContentType("application/json; charset=UTF-8");
                mapper.writeValue(res.getOutputStream(),
                        Collections.singletonMap("status", "Model.AppointmentManagement.Appointment created"));
                return;
            }

            // ----- FORM PATH -----
            HttpSession session = req.getSession(false);
            if (session == null) { res.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

            // Role detection
            String authType = (String) session.getAttribute("authType");
            String staffRole = (String) session.getAttribute("staffRole");
            boolean isReceptionist = "staff".equalsIgnoreCase(authType)
                    && staffRole != null
                    && staffRole.trim().equalsIgnoreCase("receptionist");

            // Common form fields
            String petUid     = req.getParameter("petUid");
            String type       = req.getParameter("type");
            String date       = req.getParameter("date");
            String time       = req.getParameter("time");
            String phoneNo    = req.getParameter("phoneNo");
            String staffIdStr = req.getParameter("staffId");
            String feeStr     = req.getParameter("fee");
            String status     = req.getParameter("status");

            if (petUid == null || petUid.isBlank() ||
                    type   == null || type.isBlank()   ||
                    date   == null || date.isBlank()   ||
                    time   == null || time.isBlank()) {
                forwardBackWithError(req, res, petUid, isReceptionist,
                        "Please fill all required fields.");
                return;
            }

            // Resolve ownerId depending on role
            Integer ownerId = null;
            if (isReceptionist) {
                try { ownerId = Integer.valueOf(req.getParameter("ownerId")); } catch (Exception ignore) {}
                if (ownerId == null) {
                    forwardBackWithError(req, res, petUid, true, "Owner ID is required.");
                    return;
                }
            } else {
                Object o = session.getAttribute("ownerId");
                if (o instanceof Number) ownerId = ((Number) o).intValue();
                else if (o != null) { try { ownerId = Integer.valueOf(o.toString()); } catch (NumberFormatException ignored) {} }
                if (ownerId == null) { res.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
            }

            // Validate pet belongs to owner
            Pet pet;
            try { pet = PetDAO.findByUid(petUid); } catch (Exception ex) { pet = null; }
            if (pet == null) {
                forwardBackWithError(req, res, petUid, isReceptionist, "Pet not found.");
                return;
            }
            if (!ownerId.equals(pet.getOwnerId())) {
                forwardBackWithError(req, res, petUid, isReceptionist, "This pet does not belong to the owner.");
                return;
            }

            LocalDateTime when = LocalDateTime.parse(date + "T" + time);

            // Check daily appointment limit for the pet
            if (!isReceptionist) { // Only apply limit for regular bookings, not walk-ins
                String dailyLimitError = checkDailyAppointmentLimit(petUid, when.toLocalDate(), type);
                if (dailyLimitError != null) {
                    forwardBackWithError(req, res, petUid, isReceptionist, dailyLimitError);
                    return;
                }
            }

            Integer staffId = null;
            if (staffIdStr != null && !staffIdStr.isBlank()) {
                try { staffId = Integer.valueOf(staffIdStr); } catch (NumberFormatException ignored) {}
            }

            // Compute fee: provided value, else default by type
            BigDecimal fee = null;
            if (feeStr != null && !feeStr.isBlank()) {
                try { fee = new BigDecimal(feeStr.trim()); } catch (NumberFormatException ignored) {}
            }
            if (fee == null) {
                switch (type.trim().toLowerCase()) {
                    case "veterinary": fee = new BigDecimal("3500"); break;
                    case "grooming":   fee = new BigDecimal("3000"); break;
                    default:           fee = BigDecimal.ZERO;
                }
            }

            // Build the model
            Appointment appt = new Appointment();
            appt.setPetUid(petUid.trim());
            appt.setOwnerId(ownerId);
            appt.setStaffId(staffId);
            appt.setType(type.trim());
            appt.setScheduledAt(when);
            appt.setPhoneNo(phoneNo != null ? phoneNo.trim() : null);
            appt.setFee(fee);

            if (isReceptionist) {
                // Walk-in: save as PAID at clinic immediately
                appt.setStatus(status != null && !status.isBlank() ? status.trim() : "confirmed");
                appt.setPaymentMethod("clinic");
                appt.setPaymentStatus("paid");
                appt.setPaymentRef("CLINIC");  // Set reference for clinic payments
                appt.setPaidAt(LocalDateTime.now());
                try {
                    AppointmentDAO.insert(appt);
                } catch (Exception ex) {
                    forwardBackWithError(req, res, petUid, true, toFriendlyCreateError(ex));
                    return;
                }

                res.sendRedirect(req.getContextPath()
                        + "/views/appointment-management/receptionist-dashboard.jsp?ok=walkin-created&aid=" + appt.getAppointmentId());
                return;
            } else {
                // Owner flow: unpaid until payment flow
                appt.setStatus(status != null && !status.isBlank() ? status.trim() : "pending");
                appt.setPaymentMethod(null);
                appt.setPaymentStatus("unpaid");

                try {
                    AppointmentDAO.insert(appt);
                } catch (Exception ex) {
                    forwardBackWithError(req, res, petUid, false, toFriendlyCreateError(ex));
                    return;
                }
                res.sendRedirect(req.getContextPath() + "/pay/select?appointmentId=" + appt.getAppointmentId());
                return;
            }

        } catch (Exception e) {
            String petUid = req.getParameter("petUid");
            // Try to infer role for forwarding
            HttpSession s = req.getSession(false);
            boolean isReceptionist = s != null
                    && "staff".equalsIgnoreCase(String.valueOf(s.getAttribute("authType")))
                    && "receptionist".equalsIgnoreCase(String.valueOf(s.getAttribute("staffRole")));
            forwardBackWithError(req, res, petUid, isReceptionist, toFriendlyCreateError(e));
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            Appointment incoming = mapper.readValue(req.getInputStream(), Appointment.class);
            if (incoming.getAppointmentId() == null) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", "appointmentId required"));
                return;
            }

            // Load current row
            Appointment db = AppointmentDAO.findById(incoming.getAppointmentId());
            if (db == null) {
                res.setStatus(404);
                mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", "Not found"));
                return;
            }

            // Guard: only allow "confirmed" if paid or clinic
            if ("confirmed".equalsIgnoreCase(String.valueOf(incoming.getStatus()))) {
                boolean canConfirm = "paid".equalsIgnoreCase(db.getPaymentStatus())
                        || "clinic".equalsIgnoreCase(db.getPaymentMethod());
                if (!canConfirm) {
                    res.setStatus(400);
                    mapper.writeValue(res.getOutputStream(),
                            Collections.singletonMap("error", "Cannot confirm until paid or pay-at-clinic chosen"));
                    return;
                }
            }

            // If marking as done and it was clinic & unpaid → auto mark paid now
            if ("done".equalsIgnoreCase(String.valueOf(incoming.getStatus()))) {
                // Date and time validation: Appointments can only be marked as done after the scheduled time
                LocalDateTime appointmentDateTime = db.getScheduledAt();
                LocalDateTime now = LocalDateTime.now();
                
                if (appointmentDateTime.isAfter(now)) {
                    res.setStatus(400);
                    mapper.writeValue(res.getOutputStream(),
                            Collections.singletonMap("error", 
                                "Appointments can only be marked as done after the scheduled time. " +
                                "This appointment is scheduled for " + appointmentDateTime + 
                                " but current time is " + now + ". Please wait until the appointment time has passed."));
                    return;
                }
                
                boolean clinicUnpaid = "clinic".equalsIgnoreCase(String.valueOf(db.getPaymentMethod()))
                        && !"paid".equalsIgnoreCase(String.valueOf(db.getPaymentStatus()));
                if (clinicUnpaid) {
                    incoming.setPaymentMethod("clinic");            // keep/ensure clinic
                    incoming.setPaymentStatus("paid");              // flip to paid
                    incoming.setPaidAt(java.time.LocalDateTime.now());
                    if (db.getPaymentRef() == null || db.getPaymentRef().isBlank()) {
                        incoming.setPaymentRef("CLINIC");
                    }
                }
            }

            try {
                AppointmentDAO.update(incoming);
                
                // Send confirmation email when appointment status changes to "confirmed"
                if ("confirmed".equalsIgnoreCase(String.valueOf(incoming.getStatus())) &&
                    !"confirmed".equalsIgnoreCase(String.valueOf(db.getStatus()))) {
                    
                    try {
                        Owner owner = OwnerDAO.findById(db.getOwnerId());
                        if (owner != null && owner.getEmail() != null && !owner.getEmail().trim().isEmpty()) {
                            // Get updated appointment data for email
                            Appointment updatedAppt = AppointmentDAO.findById(incoming.getAppointmentId());
                            if (updatedAppt != null) {
                                EmailService.sendAppointmentConfirmation(owner, updatedAppt);
                            }
                        }
                    } catch (Exception emailEx) {
                        // Log email error but don't fail the appointment update
                        System.err.println("Failed to send confirmation email: " + emailEx.getMessage());
                    }
                }
                
            } catch (Exception ex) {
                if (isActiveSlotViolation(ex)) {
                    res.setStatus(409);
                    res.setContentType("application/json; charset=UTF-8");
                    mapper.writeValue(res.getOutputStream(),
                            Collections.singletonMap("error",
                                    "That time slot is already booked for this pet. Please choose a different time."));
                    return;
                }
                throw ex;
            }

            res.setContentType("application/json; charset=UTF-8");
            mapper.writeValue(res.getOutputStream(),
                    Collections.singletonMap("status", "Model.AppointmentManagement.Appointment updated"));
        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", e.getMessage()));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            AppointmentDAO.delete(id);
            res.setContentType("application/json; charset=UTF-8");
            mapper.writeValue(res.getOutputStream(),
                    Collections.singletonMap("status", "Model.AppointmentManagement.Appointment deleted"));
        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", e.getMessage()));
        }
    }

    /**
     * Forwards back to the appropriate form with an error message.
     * Receptionist → add-appointment.jsp
     * Owner        → appointment_request.jsp
     */
    /**
     * Check if pet exceeds daily appointment limit
     * Business rules:
     * - Regular appointments: max 1 per day per pet
     * - Emergency/urgent: exempt from daily limits
     * - Different service types can share the same day if medically necessary
     */
    private String checkDailyAppointmentLimit(String petUid, LocalDate appointmentDate, String appointmentType) {
        try {
            // Skip limit check for emergency/urgent appointments
            if ("emergency".equalsIgnoreCase(appointmentType) || "urgent".equalsIgnoreCase(appointmentType)) {
                return null;
            }

            // Count existing appointments for this pet on the same date
            int existingAppointments = AppointmentDAO.countAppointmentsByPetAndDate(petUid, appointmentDate);
            
            // Allow max 1 regular appointment per day per pet
            if (existingAppointments >= 1) {
                return "This pet already has an appointment scheduled for " + appointmentDate + 
                       ". Please select a different date or contact reception for urgent care.";
            }
            
            return null; // No limit violation
        } catch (Exception e) {
            // Log error but don't block appointment - fail open for better user experience
            return null;
        }
    }

    private void forwardBackWithError(HttpServletRequest req, HttpServletResponse res,
                                      String petUid, boolean isReceptionist, String msg) throws IOException {
        req.setAttribute("error", msg);
        try {
            if (petUid != null && !petUid.isBlank()) {
                try { req.setAttribute("pet", PetDAO.findByUid(petUid)); } catch (Exception ignored) {}
            }
            String jsp = isReceptionist ? "/views/appointment-management/add-appointment.jsp" : "/views/appointment-management/appointment_request.jsp";
            RequestDispatcher rd = req.getRequestDispatcher(jsp);
            rd.forward(req, res);
        } catch (Exception ex) {
            res.sendError(400, msg);
        }
    }
}



