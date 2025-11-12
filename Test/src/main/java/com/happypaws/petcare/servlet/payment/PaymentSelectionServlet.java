package com.happypaws.petcare.servlet.payment;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;
import com.happypaws.petcare.model.Appointment;
import com.happypaws.petcare.servlet.payment.ForwardAction;
import com.happypaws.petcare.servlet.payment.NextAction;
import com.happypaws.petcare.servlet.payment.PaymentProcessor;
import com.happypaws.petcare.servlet.payment.PaymentStrategy;
import com.happypaws.petcare.servlet.payment.PaymentStrategyFactory;
import com.happypaws.petcare.servlet.payment.RedirectAction;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/pay/select")
public class PaymentSelectionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String id = req.getParameter("appointmentId");
        if (id == null) { res.sendError(400, "appointmentId required"); return; }
        try {
            Appointment appt = AppointmentDAO.findById(Integer.parseInt(id));
            if (appt == null) { res.sendError(404, "Appointment not found"); return; }
            req.setAttribute("appt", appt);
            RequestDispatcher rd = req.getRequestDispatcher("/views/payment-management/payment_select.jsp");
            rd.forward(req, res);
        } catch (Exception e) {
            res.sendError(500, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String id = req.getParameter("appointmentId");
        String method = req.getParameter("method"); // 'online' | 'clinic'
        String feeStr = req.getParameter("fee");
        if (id == null || method == null) { res.sendError(400, "Missing fields"); return; }

        try {
            Appointment appt = AppointmentDAO.findById(Integer.parseInt(id));
            if (appt == null) { res.sendError(404, "Appointment not found"); return; }

            // Optional: update fee if provided (basic validation)
            if (feeStr != null && !feeStr.isBlank()) {
                try {
                    appt.setFee(new BigDecimal(feeStr));
                } catch (NumberFormatException nfe) {
                    res.sendError(400, "Invalid fee format");
                    return;
                }
            }

            PaymentStrategy strategy = PaymentStrategyFactory.get(method);
            PaymentProcessor processor = new PaymentProcessor(strategy);
            NextAction action = processor.process(appt, req, res);

            // Perform the UI action here (keeps I/O in servlet)
            if (action instanceof RedirectAction) {
                res.sendRedirect(((RedirectAction) action).url());
            } else if (action instanceof ForwardAction) {
                req.getRequestDispatcher(((ForwardAction) action).jspPath()).forward(req, res);
            } else {
                res.sendError(500, "Unknown next action");
            }
        } catch (Exception e) {
            res.sendError(500, e.getMessage());
        }
    }
}
