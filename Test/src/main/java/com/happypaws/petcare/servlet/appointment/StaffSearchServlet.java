package com.happypaws.petcare.servlet.appointment;

import com.happypaws.petcare.dao.appointment.AppointmentStaffDAO;
import com.happypaws.petcare.model.Staff;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Staff Search API Servlet
 * Allows both staff and owners to search for staff members.
 * Used for appointment booking where owners can select preferred groomers/veterinarians.
 */
@WebServlet("/api/staff/search")
public class StaffSearchServlet extends HttpServlet {
    private final ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());

    private static final String ERROR_KEY = "error";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        
        try {
            // Check if user is authenticated
            HttpSession session = req.getSession(false);
            if (session == null) {
                res.setStatus(401);
                mapper.writeValue(res.getOutputStream(), 
                        Collections.singletonMap(ERROR_KEY, "Authentication required"));
                return;
            }

            String authType = (String) session.getAttribute("authType");
            if (authType == null) {
                res.setStatus(403);
                mapper.writeValue(res.getOutputStream(), 
                        Collections.singletonMap(ERROR_KEY, "Access denied"));
                return;
            }

            String searchTerm = req.getParameter("q");
            String roleFilter = req.getParameter("role");

            List<Staff> staffList;
            AppointmentStaffDAO appointmentStaffDAO = new AppointmentStaffDAO();

            if (roleFilter != null && !roleFilter.trim().isEmpty()) {
                // Filter by specific role
                staffList = appointmentStaffDAO.getStaffByRole(roleFilter.trim());
            } else if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                // Search by name or role
                if (searchTerm.trim().length() < 2) {
                    mapper.writeValue(res.getOutputStream(), Collections.emptyList());
                    return;
                }
                staffList = appointmentStaffDAO.searchStaff(searchTerm.trim());
            } else {
                // Get all staff
                staffList = appointmentStaffDAO.getAllStaff();
            }

            // Remove sensitive information (password hash) before sending to frontend
            List<StaffInfo> publicStaffInfo = staffList.stream()
                    .map(staff -> new StaffInfo(
                            staff.getStaffId(),
                            staff.getFullName(),
                            staff.getRole(),
                            staff.getEmail(),
                            staff.getPhone()
                    ))
                    .collect(Collectors.toList());

            mapper.writeValue(res.getOutputStream(), publicStaffInfo);

        } catch (Exception e) {
            res.setStatus(500);
            mapper.writeValue(res.getOutputStream(), 
                    Collections.singletonMap(ERROR_KEY, "Search failed: " + e.getMessage()));
        }
    }

    // DTO for public staff information (without password hash)
    public static class StaffInfo {
        public Integer staffId;
        public String fullName;
        public String role;
        public String email;
        public String phone;

        public StaffInfo(Integer staffId, String fullName, String role, String email, String phone) {
            this.staffId = staffId;
            this.fullName = fullName;
            this.role = role;
            this.email = email;
            this.phone = phone;
        }
    }
}