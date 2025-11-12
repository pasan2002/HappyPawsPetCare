package com.happypaws.petcare.servlet.appointment;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;
import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.model.Appointment;
import com.happypaws.petcare.model.Owner;
import com.happypaws.petcare.service.EmailService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/appointments/reminder")
public class AppointmentReminderServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(AppointmentReminderServlet.class.getName());
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        
        try {
            // Check if user is authenticated and is staff/receptionist
            HttpSession session = req.getSession(false);
            if (session == null) {
                res.setStatus(401);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Authentication required"));
                return;
            }
            
            String authType = (String) session.getAttribute("authType");
            String staffRole = (String) session.getAttribute("staffRole");
            boolean isReceptionist = "staff".equalsIgnoreCase(authType) 
                && staffRole != null 
                && staffRole.trim().equalsIgnoreCase("receptionist");
            
            if (!isReceptionist) {
                res.setStatus(403);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Only receptionists can send reminders"));
                return;
            }
            
            // Parse request body
            @SuppressWarnings("unchecked")
            Map<String, Object> requestBody = mapper.readValue(req.getInputStream(), Map.class);
            Object appointmentIdObj = requestBody.get("appointmentId");
            
            if (appointmentIdObj == null) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "appointmentId is required"));
                return;
            }
            
            Integer appointmentId;
            try {
                appointmentId = Integer.valueOf(appointmentIdObj.toString());
            } catch (NumberFormatException e) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Invalid appointmentId format"));
                return;
            }
            
            // Get appointment details with better error handling
            Appointment appointment;
            try {
                appointment = AppointmentDAO.findById(appointmentId);
            } catch (RuntimeException e) {
                // Check if it's a database connection issue
                if (e.getCause() instanceof java.sql.SQLException) {
                    LOGGER.log(Level.WARNING, "Database connection issue when fetching appointment", e);
                    res.setStatus(503); // Service Unavailable
                    mapper.writeValue(res.getOutputStream(), 
                        Collections.singletonMap("error", "Database connection issue. Please try again in a moment."));
                    return;
                } else {
                    throw e; // Re-throw if it's not a DB connection issue
                }
            }
            
            if (appointment == null) {
                res.setStatus(404);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Appointment not found"));
                return;
            }
            
            // Date validation: Reminders can only be sent the day before the appointment
            // Using Sri Lanka timezone for consistent date calculations
            java.time.ZoneId sriLankaZone = java.time.ZoneId.of("Asia/Colombo");
            java.time.LocalDate appointmentDate = appointment.getScheduledAt().toLocalDate();
            java.time.LocalDate today = java.time.LocalDate.now(sriLankaZone);
            java.time.LocalDate tomorrow = today.plusDays(1);
            
            if (!appointmentDate.equals(tomorrow)) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", 
                        "Reminders can only be sent the day before the appointment. " +
                        "This appointment is scheduled for " + appointmentDate + 
                        " but today is " + today + " (Sri Lanka time)."));
                return;
            }

            // Check if reminder has already been sent (check both boolean and count)
            boolean reminderAlreadySent = (appointment.getReminderSent() != null && appointment.getReminderSent()) ||
                                        (appointment.getReminderCount() != null && appointment.getReminderCount() > 0);
            
            if (reminderAlreadySent) {
                int count = appointment.getReminderCount() != null ? appointment.getReminderCount() : 0;
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", 
                        "Reminder has already been sent for this appointment. " +
                        "Count: " + count + ". Only one reminder per appointment is allowed."));
                return;
            }
            
            // Get owner details
            Owner owner = OwnerDAO.findById(appointment.getOwnerId());
            if (owner == null) {
                res.setStatus(404);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Owner not found"));
                return;
            }
            
            // Check if owner has email
            if (owner.getEmail() == null || owner.getEmail().trim().isEmpty()) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Owner has no email address"));
                return;
            }
            
            // Send reminder email
            LOGGER.info("Attempting to send reminder email to: " + owner.getEmail() + " for appointment: " + appointmentId);
            boolean emailSent = EmailService.sendAppointmentReminder(owner, appointment);
            LOGGER.info("Email send result: " + emailSent);
            
            if (emailSent) {
                // Mark reminder as sent in database
                try {
                    AppointmentDAO.markReminderSent(appointmentId);
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Failed to mark reminder as sent for appointment: " + appointmentId, e);
                    // Don't fail the request - email was sent successfully
                }
                
                if (LOGGER.isLoggable(Level.INFO)) {
                    LOGGER.info(() -> "Reminder email sent for appointment ID: " + appointmentId + 
                        " to owner: " + owner.getEmail());
                }
                
                // Get updated appointment to return the reminder count
                Appointment updatedAppointment = null;
                int reminderCount = 1; // Default to 1
                try {
                    updatedAppointment = AppointmentDAO.findById(appointmentId);
                    if (updatedAppointment != null && updatedAppointment.getReminderCount() != null) {
                        reminderCount = updatedAppointment.getReminderCount();
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Failed to get updated reminder count for appointment: " + appointmentId, e);
                }
                
                Map<String, Object> response = new HashMap<>();
                response.put("message", "Reminder email sent successfully");
                response.put("reminderCount", reminderCount);
                
                mapper.writeValue(res.getOutputStream(), response);
            } else {
                res.setStatus(500);
                mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap("error", "Failed to send reminder email"));
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error sending appointment reminder", e);
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), 
                Collections.singletonMap("error", "Internal server error: " + e.getMessage()));
        }
    }
}