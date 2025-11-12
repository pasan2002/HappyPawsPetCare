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

@WebServlet("/pay/success")
public class PaymentSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String id = req.getParameter("appointmentId");
        if (id == null) {
            res.sendError(400, "appointmentId required");
            return;
        }
        try {
            Appointment appt = AppointmentDAO.findById(Integer.parseInt(id));
            if (appt == null) {
                res.sendError(404, "Appointment not found");
                return;
            }
            req.setAttribute("appt", appt);
            
            // Send payment confirmation email if payment is confirmed
            if ("paid".equalsIgnoreCase(appt.getPaymentStatus())) {
                try {
                    Owner owner = OwnerDAO.findById(appt.getOwnerId());
                    if (owner != null && owner.getEmail() != null && !owner.getEmail().trim().isEmpty()) {
                        EmailService.sendPaymentConfirmation(owner, appt);
                    }
                } catch (Exception emailEx) {
                    // Log email error but don't fail the success page display
                    System.err.println("Failed to send payment confirmation email: " + emailEx.getMessage());
                }
            }
            
            RequestDispatcher rd = req.getRequestDispatcher("/views/payment-management/payment_success.jsp");
            rd.forward(req, res);
        } catch (Exception e) {
            res.sendError(500, e.getMessage());
        }
    }
}



