package com.happypaws.petcare.servlet.user;

import com.happypaws.petcare.dao.user.StaffManagementDAO;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/staff/delete")
public class DeleteStaffServlet extends HttpServlet {
    private StaffManagementDAO staffManagementDAO;

    public void init() {
        staffManagementDAO = new StaffManagementDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String authType = (String) session.getAttribute("authType");
        String staffRole = (String) session.getAttribute("staffRole");
        
        if (!"staff".equals(authType) || !"manager".equals(staffRole)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        try {
            // Get staff ID from request parameter
            String idParam = request.getParameter("id");

            // Validate ID parameter
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/management?error=invalid_id");
                return;
            }

            // Parse staff ID
            int staffId;
            try {
                staffId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/staff/management?error=invalid_id_format");
                return;
            }

            // Validate staff ID range
            if (staffId <= 0) {
                response.sendRedirect(request.getContextPath() + "/staff/management?error=invalid_id_range");
                return;
            }

            // Check if staff exists before deletion
            if (staffManagementDAO.getStaffById(staffId) == null) {
                response.sendRedirect(request.getContextPath() + "/staff/management?error=staff_not_found");
                return;
            }

            // Attempt to delete staff
            boolean success = staffManagementDAO.deleteStaff(staffId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/management?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/management?error=delete_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/management?error=server_error");
        }
    }

    // Handle POST requests for additional security
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}