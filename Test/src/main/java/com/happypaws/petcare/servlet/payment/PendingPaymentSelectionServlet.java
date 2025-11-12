package com.happypaws.petcare.servlet.payment;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;
import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.model.Appointment;
import com.happypaws.petcare.model.Owner;
import com.happypaws.petcare.service.EmailService;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * Handles payment method selection for pending appointments.
 * Creates the appointment in DB only after payment method is selected.
 */
@WebServlet("/pay/select/pending")
public class PendingPaymentSelectionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<String, Object> pendingAppointment = (Map<String, Object>) session.getAttribute("pendingAppointment");
        
        if (pendingAppointment == null) {
            res.sendRedirect(req.getContextPath() + "/owner/dashboard");
            return;
        }

        // Create a temporary appointment object for display
        Appointment appt = new Appointment();
        appt.setPetUid((String) pendingAppointment.get("petUid"));
        appt.setOwnerId((Integer) pendingAppointment.get("ownerId"));
        appt.setStaffId((Integer) pendingAppointment.get("staffId"));
        appt.setType((String) pendingAppointment.get("type"));
        appt.setScheduledAt((LocalDateTime) pendingAppointment.get("scheduledAt"));
        appt.setPhoneNo((String) pendingAppointment.get("phoneNo"));
        appt.setFee((BigDecimal) pendingAppointment.get("fee"));
        appt.setStatus((String) pendingAppointment.get("status"));

        req.setAttribute("appt", appt);
        req.setAttribute("isPending", true);
        RequestDispatcher rd = req.getRequestDispatcher("/views/payment-management/payment_select.jsp");
        rd.forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<String, Object> pendingAppointment = (Map<String, Object>) session.getAttribute("pendingAppointment");
        
        if (pendingAppointment == null) {
            res.sendError(400, "No pending appointment found in session");
            return;
        }

        String method = req.getParameter("method"); // 'online' | 'clinic'
        if (method == null) {
            res.sendError(400, "Payment method required");
            return;
        }

        try {
            // Create appointment object from session data
            Appointment appt = new Appointment();
            appt.setPetUid((String) pendingAppointment.get("petUid"));
            appt.setOwnerId((Integer) pendingAppointment.get("ownerId"));
            appt.setStaffId((Integer) pendingAppointment.get("staffId"));
            appt.setType((String) pendingAppointment.get("type"));
            appt.setScheduledAt((LocalDateTime) pendingAppointment.get("scheduledAt"));
            appt.setPhoneNo((String) pendingAppointment.get("phoneNo"));
            appt.setFee((BigDecimal) pendingAppointment.get("fee"));
            appt.setStatus((String) pendingAppointment.get("status"));
            appt.setPaymentStatus("unpaid");

            // Set payment method based on selection
            if ("clinic".equalsIgnoreCase(method)) {
                appt.setPaymentMethod("clinic");
                
                // Insert appointment into database
                AppointmentDAO.insert(appt);
                
                // Send confirmation email for clinic payment
                try {
                    Owner owner = OwnerDAO.findById(appt.getOwnerId());
                    if (owner != null && owner.getEmail() != null && !owner.getEmail().trim().isEmpty()) {
                        EmailService.sendAppointmentConfirmation(owner, appt);
                    }
                } catch (Exception emailEx) {
                    System.err.println("Failed to send confirmation email: " + emailEx.getMessage());
                }
                
                // Clear pending appointment from session
                session.removeAttribute("pendingAppointment");
                
                // Forward to clinic payment success page
                req.setAttribute("appt", appt);
                RequestDispatcher rd = req.getRequestDispatcher("/views/payment-management/payment_clinic.jsp");
                rd.forward(req, res);
                
            } else if ("online".equalsIgnoreCase(method)) {
                appt.setPaymentMethod("online");
                
                // Insert appointment into database
                AppointmentDAO.insert(appt);
                
                // Clear pending appointment from session
                session.removeAttribute("pendingAppointment");
                
                // Redirect to online payment gateway
                res.sendRedirect(req.getContextPath() + "/pay/online/start?appointmentId=" + appt.getAppointmentId());
                
            } else {
                res.sendError(400, "Invalid payment method");
            }

        } catch (Exception e) {
            // If appointment creation fails, keep it in session
            res.sendError(500, "Failed to create appointment: " + e.getMessage());
        }
    }
}
