package com.happypaws.petcare.servlet.payment;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.stripe.Stripe;
import com.stripe.model.PaymentIntent;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.Map;

@WebServlet("/pay/online/confirm")
public class OnlinePaymentConfirmServlet extends HttpServlet {
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            Map<?,?> payload = mapper.readValue(req.getInputStream(), Map.class);
            Integer appointmentId = (Integer) payload.get("appointmentId");
            String paymentIntentId = String.valueOf(payload.get("paymentIntentId"));

            if (appointmentId == null || paymentIntentId == null) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", "Missing fields"));
                return;
            }

            Stripe.apiKey = System.getenv("STRIPE_SECRET_KEY");
            PaymentIntent pi = PaymentIntent.retrieve(paymentIntentId);

            if ("succeeded".equalsIgnoreCase(pi.getStatus())) {
                AppointmentDAO.markPaid(appointmentId, paymentIntentId);
                mapper.writeValue(res.getOutputStream(), Collections.singletonMap("status", "paid"));
            } else {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", "Payment not successful"));
            }
        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", e.getMessage()));
        }
    }
}



