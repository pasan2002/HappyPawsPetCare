package com.happypaws.petcare.servlet.user;

import com.happypaws.petcare.dao.user.StaffManagementDAO;
import com.happypaws.petcare.model.Staff;
import com.happypaws.petcare.util.PasswordUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/staff/add")
public class AddStaffServlet extends HttpServlet {
    private StaffManagementDAO staffManagementDAO;

    public void init() {
        staffManagementDAO = new StaffManagementDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is authenticated and has manager role
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login?next=" + request.getRequestURI());
            return;
        }

        String authType = (String) session.getAttribute("authType");
        String staffRole = (String) session.getAttribute("staffRole");
        
        if (!"staff".equals(authType) || !"manager".equals(staffRole)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        // Forward to add staff form
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/staffmanagement/add-staff-form.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        // Get parameters from request
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // Validate required fields
        if (!isValidInput(fullName, role, email, phone, password)) {
            response.sendRedirect(request.getContextPath() + "/staff/add?error=validation");
            return;
        }

        // Validate role
        if (!isValidRole(role)) {
            response.sendRedirect(request.getContextPath() + "/staff/add?error=invalid_role");
            return;
        }

        // Validate email format
        if (!isValidEmail(email)) {
            response.sendRedirect(request.getContextPath() + "/staff/add?error=invalid_email");
            return;
        }

        // Check if email already exists
        if (staffManagementDAO.isEmailExists(email)) {
            response.sendRedirect(request.getContextPath() + "/staff/add?error=duplicate_email");
            return;
        }

        // Validate password strength
        if (!isValidPassword(password)) {
            response.sendRedirect(request.getContextPath() + "/staff/add?error=weak_password");
            return;
        }

        try {
            // Hash password
            String hashedPassword = PasswordUtil.hash(password);
            
            // Create Staff object
            Staff staff = new Staff();
            staff.setFullName(fullName);
            staff.setRole(role);
            staff.setEmail(email);
            staff.setPhone(phone);
            staff.setPasswordHash(hashedPassword);
            
            // Add staff to database
            boolean success = staffManagementDAO.addStaff(staff);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/management?success=added");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/add?error=add_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/add?error=server_error");
        }
    }

    /**
     * Validate all required input fields
     */
    private boolean isValidInput(String fullName, String role, String email, String phone, String password) {
        return fullName != null && !fullName.trim().isEmpty() &&
                role != null && !role.trim().isEmpty() &&
                email != null && !email.trim().isEmpty() &&
                phone != null && !phone.trim().isEmpty() &&
                password != null && !password.trim().isEmpty();
    }

    /**
     * Validate email format
     */
    private boolean isValidEmail(String email) {
        if (email == null) return false;
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        return email.matches(emailRegex);
    }

    /**
     * Validate password strength
     */
    private boolean isValidPassword(String password) {
        if (password == null) return false;
        // Minimum 6 characters
        return password.length() >= 6;
    }

    /**
     * Validate role against allowed database values
     */
    private boolean isValidRole(String role) {
        if (role == null) return false;
        String[] allowedRoles = {"manager", "veterinarian", "pharmacist", "receptionist", "groomer"};
        for (String allowedRole : allowedRoles) {
            if (allowedRole.equals(role.toLowerCase())) {
                return true;
            }
        }
        return false;
    }
}