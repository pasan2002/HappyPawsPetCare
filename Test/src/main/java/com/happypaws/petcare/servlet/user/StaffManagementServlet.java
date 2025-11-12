package com.happypaws.petcare.servlet.user;

import com.happypaws.petcare.dao.user.StaffManagementDAO;
import com.happypaws.petcare.model.Staff;
import com.happypaws.petcare.util.PasswordUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/management")
public class StaffManagementServlet extends HttpServlet {
    private StaffManagementDAO staffManagementDAO;

    @Override
    public void init() {
        staffManagementDAO = new StaffManagementDAO();
    }

    @Override
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
        
        // Only staff with manager role can access staff management
        if (!"staff".equals(authType) || !"manager".equals(staffRole)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        try {
            // Check for edit action
            String action = request.getParameter("action");
            if ("edit".equals(action)) {
                handleEditRequest(request, response);
                return;
            }

            // Get optional search and filter parameters
            String searchTerm = request.getParameter("search");
            String roleFilter = request.getParameter("role");
            String sortBy = request.getParameter("sort");
            String sortOrder = request.getParameter("order");

            List<Staff> staffList;

            // Apply search filter if search term is provided
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                staffList = staffManagementDAO.searchStaffByName(searchTerm.trim());
                request.setAttribute("searchTerm", searchTerm);
            }
            // Apply role filter if role is provided
            else if (roleFilter != null && !roleFilter.trim().isEmpty()) {
                staffList = staffManagementDAO.getStaffByRole(roleFilter.trim());
                request.setAttribute("roleFilter", roleFilter);
            }
            // Get all staff by default
            else {
                staffList = staffManagementDAO.getAllStaff();
            }

            // Get statistics
            int totalStaffCount = staffManagementDAO.getTotalStaffCount();
            int uniqueRolesCount = staffManagementDAO.getUniqueRolesCount();

            // Set attributes for the JSP
            request.setAttribute("staffList", staffList);
            request.setAttribute("totalStaffCount", totalStaffCount);
            request.setAttribute("uniqueRolesCount", uniqueRolesCount);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);

            // Forward to staff management index page
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/staffmanagement/index.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/staffmanagement/index.jsp?error=server_error");
        }
    }

    private void handleEditRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is authenticated and has manager role
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String authType = (String) session.getAttribute("authType");
        String staffRole = (String) session.getAttribute("staffRole");
        
        if (!"staff".equals(authType) || !"manager".equals(staffRole)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }

        try {
            // Get form parameters
            String staffIdStr = request.getParameter("staffId");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String password = request.getParameter("password");

            // Validate required fields
            if (staffIdStr == null || staffIdStr.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                role == null || role.trim().isEmpty()) {
                
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
            existingStaff.setRole(role.trim());

            // Update basic staff information in database
            boolean updated = staffManagementDAO.updateStaff(existingStaff);
            
            // Update password separately if provided
            if (updated && password != null && !password.trim().isEmpty()) {
                String hashedPassword = PasswordUtil.hash(password.trim());
                updated = staffManagementDAO.updateStaffPassword(existingStaff.getStaffId(), hashedPassword);
            }

            // Update staff in database
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