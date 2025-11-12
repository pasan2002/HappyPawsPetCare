package com.happypaws.petcare.servlet.appointment;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;
import com.happypaws.petcare.model.Appointment;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@WebServlet("/owner/reschedule")
public class OwnerRescheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        Integer ownerId = (session != null) ? (Integer) session.getAttribute("ownerId") : null;

        if (ownerId == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?e=Please+login");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null || !idStr.matches("\\d+")) {
            res.sendRedirect(req.getContextPath() + "/views/appointment-management/user_appointments.jsp?e=Missing+appointment");
            return;
        }

        try {
            int apptId = Integer.parseInt(idStr);
            Appointment appt = AppointmentDAO.findById(apptId);
            if (appt == null) {
                res.sendRedirect(req.getContextPath() + "/views/appointment-management/user_appointments.jsp?e=Model.AppointmentManagement.Appointment+not+found");
                return;
            }
            if (!ownerId.equals(appt.getOwnerId())) {
                res.sendRedirect(req.getContextPath() + "/views/appointment-management/user_appointments.jsp?e=Access+denied");
                return;
            }
            if (!"confirmed".equalsIgnoreCase(appt.getStatus())) {
                res.sendRedirect(req.getContextPath() + "/views/appointment-management/user_appointments.jsp?e=Only+confirmed+appointments+can+be+rescheduled");
                return;
            }

            // OK → show the owner reschedule page
            RequestDispatcher rd = req.getRequestDispatcher("/views/appointment-management/owner-reschedule.jsp");
            try { rd.forward(req, res); } catch (Exception ignore) {}
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/views/appointment-management/user_appointments.jsp?e=Server+error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        Integer ownerId = (session != null) ? (Integer) session.getAttribute("ownerId") : null;

        if (ownerId == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?e=Please+login");
            return;
        }

        String idStr = req.getParameter("appointmentId");
        String date  = req.getParameter("date");
        String time  = req.getParameter("time");

        if (idStr == null || !idStr.matches("\\d+") || date == null || date.isBlank() || time == null || time.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/views/appointment-management/owner-reschedule.jsp?id=" + (idStr==null?"":idStr) + "&e=All+fields+required");
            return;
        }

        try {
            int apptId = Integer.parseInt(idStr);
            Appointment appt = AppointmentDAO.findById(apptId);
            if (appt == null) {
                res.sendRedirect(req.getContextPath() + "/views/appointment-management/user_appointments.jsp?e=Model.AppointmentManagement.Appointment+not+found");
                return;
            }
            if (!ownerId.equals(appt.getOwnerId())) {
                res.sendRedirect(req.getContextPath() + "/views/appointment-management/user_appointments.jsp?e=Access+denied");
                return;
            }
            // ✅ enforce confirmed only
            if (!"confirmed".equalsIgnoreCase(appt.getStatus())) {
                res.sendRedirect(req.getContextPath() + "/views/appointment-management/user_appointments.jsp?e=Only+confirmed+appointments+can+be+rescheduled");
                return;
            }

            LocalDateTime newWhen = LocalDateTime.of(LocalDate.parse(date), LocalTime.parse(time));

            // Update: change the time AND reset status to pending (needs receptionist confirmation)
            Appointment patch = new Appointment();
            patch.setAppointmentId(apptId);
            patch.setScheduledAt(newWhen);
            patch.setStatus("pending"); // ✅ Reset to pending when owner reschedules
            // leave other fields null -> DAO.AppointmentDAO.update() keeps existing values
            AppointmentDAO.update(patch);

            // Done → back to owner dashboard with informative message
            res.sendRedirect(req.getContextPath() + "/views/appointment-management/user_appointments.jsp?ok=Reschedule+request+submitted.+Status+reset+to+pending+for+receptionist+confirmation.");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/views/appointment-management/owner-reschedule.jsp?id=" + idStr + "&e=Server+error");
        }
    }
}



