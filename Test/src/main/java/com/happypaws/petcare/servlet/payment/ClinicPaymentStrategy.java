package com.happypaws.petcare.servlet.payment;

import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.model.Appointment;
import com.happypaws.petcare.model.Owner;
import com.happypaws.petcare.servlet.payment.ForwardAction;
import com.happypaws.petcare.servlet.payment.NextAction;
import com.happypaws.petcare.servlet.payment.PaymentStrategy;
import com.happypaws.petcare.service.EmailService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ClinicPaymentStrategy implements PaymentStrategy {

    @Override
    public void updateAppointment(Appointment appointment) {
        appointment.setPaymentMethod("clinic");
        appointment.setPaymentStatus("unpaid");
        appointment.setPaymentRef("CLINIC");
    }

    @Override
    public NextAction processPayment(Appointment appointment, HttpServletRequest req, HttpServletResponse res) throws Exception {
        try {
            Owner owner = OwnerDAO.findById(appointment.getOwnerId());
            if (owner != null && owner.getEmail() != null && !owner.getEmail().trim().isEmpty()) {
                EmailService.sendClinicPaymentConfirmation(owner, appointment);
            }
        } catch (Exception emailEx) {
            // replace with logger in production
            System.err.println("Failed to send clinic payment confirmation email: " + emailEx.getMessage());
        }
        req.setAttribute("appt", appointment);
        return new ForwardAction("/views/payment-management/payment_clinic.jsp");
    }
}

