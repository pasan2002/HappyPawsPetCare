package com.happypaws.petcare.servlet.appointment;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;
import com.happypaws.petcare.model.Appointment;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@WebServlet("/my-appointments")
public class MyAppointmentsServlet extends HttpServlet {
    private static final int UNASSIGNED_STAFF_ID = 1;

    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule())
            .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

    private Integer requireOwner(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || !"owner".equals(s.getAttribute("authType"))) {
            res.setStatus(401);
            mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", "Not signed in as owner"));
            return null;
        }
        return (Integer) s.getAttribute("ownerId");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        Integer ownerId = requireOwner(req, res);
        if (ownerId == null) return;

        try {
            String idParam = req.getParameter("id");
            String type = req.getParameter("type");
            String status = req.getParameter("status");

            if (idParam != null) {
                int id = Integer.parseInt(idParam);
                Appointment appt = AppointmentDAO.findByIdForOwner(id, ownerId);
                if (appt == null) {
                    res.setStatus(404);
                    mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", "Not found"));
                    return;
                }
                mapper.writeValue(res.getOutputStream(), appt);
                return;
            }

            List<Appointment> list = AppointmentDAO.findByOwner(ownerId, type, status);
            mapper.writeValue(res.getOutputStream(), list);

        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", e.getMessage()));
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        Integer ownerId = requireOwner(req, res);
        if (ownerId == null) return;

        try {
            String ct = req.getContentType();
            boolean isJson = ct != null && ct.toLowerCase().startsWith("application/json");

            String petUid, type, date, time;
            if (isJson) {
                Map<?,?> body = mapper.readValue(req.getInputStream(), Map.class);
                petUid = String.valueOf(body.get("petUid"));
                type   = String.valueOf(body.get("type"));
                date   = String.valueOf(body.get("date"));
                time   = String.valueOf(body.get("time"));
            } else {
                petUid = req.getParameter("petUid");
                type   = req.getParameter("type");
                date   = req.getParameter("date");
                time   = req.getParameter("time");
            }

            if (petUid == null || petUid.isBlank() ||
                    type == null || type.isBlank() ||
                    date == null || date.isBlank() ||
                    time == null || time.isBlank()) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", "All fields are required"));
                return;
            }

            LocalDateTime when = LocalDateTime.parse(date + "T" + time);

            Appointment appt = new Appointment();
            appt.setPetUid(petUid.trim());
            appt.setOwnerId(ownerId);
            appt.setStaffId(null);
            appt.setType(type.trim());
            appt.setScheduledAt(when);
            appt.setStaffId(UNASSIGNED_STAFF_ID);
            appt.setStatus("pending");

            AppointmentDAO.insert(appt);
            mapper.writeValue(res.getOutputStream(), Collections.singletonMap("status", "created"));

        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", e.getMessage()));
        }
    }

    // Update by owner: action=cancel OR action=reschedule
    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        Integer ownerId = requireOwner(req, res);
        if (ownerId == null) return;

        try {
            Map<?,?> body = mapper.readValue(req.getInputStream(), Map.class);
            Integer appointmentId = (Integer) body.get("appointmentId");
            String action = body.get("action") != null ? String.valueOf(body.get("action")) : "";

            if (appointmentId == null) {
                res.setStatus(400);
                mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", "appointmentId required"));
                return;
            }

            Appointment target = AppointmentDAO.findByIdForOwner(appointmentId, ownerId);
            if (target == null) {
                res.setStatus(404);
                mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", "Model.AppointmentManagement.Appointment not found"));
                return;
            }

            if ("cancel".equalsIgnoreCase(action)) {
                target.setStatus("cancelled");      // owner cancels → immediately cancelled
                AppointmentDAO.update(target);
                mapper.writeValue(res.getOutputStream(), Collections.singletonMap("status", "cancelled"));
                return;
            }

            if ("reschedule".equalsIgnoreCase(action)) {
                String date = body.get("date") != null ? String.valueOf(body.get("date")) : null;
                String time = body.get("time") != null ? String.valueOf(body.get("time")) : null;
                if (date == null || time == null) {
                    res.setStatus(400);
                    mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", "date and time required"));
                    return;
                }
                LocalDateTime when = LocalDateTime.parse(date + "T" + time);
                target.setScheduledAt(when);
                target.setStatus("pending"); // reschedule request returns to pending
                AppointmentDAO.update(target);
                mapper.writeValue(res.getOutputStream(), Collections.singletonMap("status", "rescheduled"));
                return;
            }

            res.setStatus(400);
            mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", "Unknown action"));

        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), Collections.singletonMap("error", e.getMessage()));
        }
    }
}



