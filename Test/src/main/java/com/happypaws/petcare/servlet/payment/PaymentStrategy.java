package com.happypaws.petcare.servlet.payment;

import com.happypaws.petcare.model.Appointment;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface PaymentStrategy {
    /** Mutate appointment domain fields (method/status/ref/etc). */
    void updateAppointment(Appointment appointment);

    /** Return the next UI action (redirect/forward) after any side-effects (e.g. email). */
    NextAction processPayment(Appointment appointment, HttpServletRequest req, HttpServletResponse res) throws Exception;
}

