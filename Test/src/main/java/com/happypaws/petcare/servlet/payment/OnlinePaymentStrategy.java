package com.happypaws.petcare.servlet.payment;

import com.happypaws.petcare.model.Appointment;
import com.happypaws.petcare.servlet.payment.NextAction;
import com.happypaws.petcare.servlet.payment.RedirectAction;
import com.happypaws.petcare.servlet.payment.PaymentStrategy;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class OnlinePaymentStrategy implements PaymentStrategy {

    @Override
    public void updateAppointment(Appointment appointment) {
        appointment.setPaymentMethod("online");
        appointment.setPaymentStatus("unpaid");
        // paymentRef will be set after gateway success
    }

    @Override
    public NextAction processPayment(Appointment appointment, HttpServletRequest req, HttpServletResponse res) {
        String url = req.getContextPath() + "/pay/online/start?appointmentId=" + appointment.getAppointmentId();
        return new RedirectAction(url);
    }
}

