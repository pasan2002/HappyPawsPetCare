package com.happypaws.petcare.servlet.payment;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;
import com.happypaws.petcare.model.Appointment;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Objects;

public class PaymentProcessor {
    private final PaymentStrategy strategy;

    public PaymentProcessor(PaymentStrategy strategy) {
        this.strategy = Objects.requireNonNull(strategy, "Payment strategy must not be null");
    }

    public NextAction process(Appointment appointment, HttpServletRequest req, HttpServletResponse res) throws Exception {
        // 1) Domain mutation
        strategy.updateAppointment(appointment);

        // 2) Persist (consider transaction mgmt in real systems)
        AppointmentDAO.update(appointment);

        // 3) Side-effects & determine next UI step
        return strategy.processPayment(appointment, req, res);
    }
}

