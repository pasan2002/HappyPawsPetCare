package com.happypaws.petcare.servlet.user;

import com.happypaws.petcare.dao.user.StaffManagementDAO;
import com.happypaws.petcare.model.Staff;
import com.happypaws.petcare.util.PasswordUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/staff/edit")
public class EditStaffServlet extends HttpServlet {
    private StaffManagementDAO staffManagementDAO;

    public void init() {
        staffManagementDAO = new StaffManagementDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is authenticated and has manager role
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"manager".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        String staffIdStr = request.getParameter("id");
        
        if (staffIdStr == null || staffIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/management?error=invalid_id");
            return;
        }

        try {
            int staffId = Integer.parseInt(staffIdStr.trim());
            Staff staff = staffManagementDAO.getStaffById(staffId);
            
            if (staff == null) {
                response.sendRedirect(request.getContextPath() + "/staff/management?error=staff_not_found");
                return;
            }

            request.setAttribute("staff", staff);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/staffmanagement/edit-staff-form.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/management?error=invalid_id_format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/management?error=server_error");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is authenticated and has manager role
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"manager".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        try {
            // Get form parameters
            String staffIdStr = request.getParameter("staffId");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String staffRole = request.getParameter("role");
            String password = request.getParameter("password");

            // Validate required fields
            if (staffIdStr == null || staffIdStr.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                staffRole == null || staffRole.trim().isEmpty()) {
                
                response.sendRedirect(request.getContextPath() + "/staff/management?error=missing_fields");
                return;
            }

            int staffId = Integer.parseInt(staffIdStr.trim());
            
            // Get existing staff to update
            Staff existingStaff = staffManagementDAO.getStaffById(staffId);
            if (existingStaff == null) {
                response.sendRedirect(request.getContextPath() + "/staff/management?error=staff_not_found");
                return;
            }

            // Update staff properties
            existingStaff.setFullName(fullName.trim());
            existingStaff.setEmail(email.trim().toLowerCase());
            existingStaff.setPhone(phone.trim());
            existingStaff.setRole(staffRole.trim());

            // Update basic staff information in database
            boolean updated = staffManagementDAO.updateStaff(existingStaff);
            
            // Update password separately if provided
            if (updated && password != null && !password.trim().isEmpty()) {
                String hashedPassword = PasswordUtil.hash(password.trim());
                updated = staffManagementDAO.updateStaffPassword(staffId, hashedPassword);
            }

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/staff/management?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/management?error=update_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/management?error=invalid_id_format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/management?error=server_error");
        }
    }
}