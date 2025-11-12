package com.happypaws.petcare.servlet.payment;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;
import com.happypaws.petcare.model.Appointment;
import com.stripe.Stripe;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/pay/online/start")
public class OnlinePaymentStartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String id = req.getParameter("appointmentId");
        if (id == null) { res.sendError(400, "appointmentId required"); return; }
        try {
            Appointment appt = AppointmentDAO.findById(Integer.parseInt(id));
            if (appt == null) { res.sendError(404, "Appointment not found"); return; }
            if (appt.getFee() == null) { res.sendError(400, "Fee is required before payment"); return; }

            Stripe.apiKey = System.getenv("STRIPE_SECRET_KEY");

            long amountCents = appt.getFee().multiply(new BigDecimal("100")).longValueExact();

            PaymentIntentCreateParams params = PaymentIntentCreateParams.builder()
                    .setAmount(amountCents)
                    .setCurrency("lkr")
                    .setDescription("Happy Paws appointment #" + appt.getAppointmentId())
                    .putMetadata("appointment_id", String.valueOf(appt.getAppointmentId()))
                    .build();

            PaymentIntent pi = PaymentIntent.create(params);

            req.setAttribute("publishableKey", System.getenv("STRIPE_PUBLISHABLE_KEY"));
            req.setAttribute("clientSecret", pi.getClientSecret());
            req.setAttribute("appointmentId", appt.getAppointmentId());
            req.setAttribute("amount", appt.getFee());
            RequestDispatcher rd = req.getRequestDispatcher("/views/payment-management/payment_online.jsp");
            rd.forward(req, res);

        } catch (Exception e) {
            res.sendError(500, e.getMessage());
        }
    }
}



