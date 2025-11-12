package com.happypaws.petcare.servlet.user;

import com.happypaws.petcare.dao.user.StaffDAO;
import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.model.Owner;
import com.happypaws.petcare.model.Staff;
import com.happypaws.petcare.util.PasswordUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Set;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Staff-only areas (for 'next' allowlist checks for owners)
    private static final Set<String> STAFF_ONLY_PREFIXES = Set.of(
            "/views/appointment-management/receptionist-dashboard.jsp",
            "/views/staff-home.jsp",
            "/views/staff", // subpages
            "/views/inventory-management" // pharmacy areas
    );

    // Owner default safe pages (optional guardrail)
    private static final Set<String> OWNER_DEFAULT_PAGES = Set.of(
            "/views/appointment-management/user_appointments.jsp",
            "/views/user-appointments.jsp", // in case you used a hyphen elsewhere
            "/index.jsp",
            "/"
    );

    // ===== Helpers for 'next' =====
    private static boolean isAbsoluteOrExternal(String path) {
        if (path == null) return false;
        String p = path.trim();
        return p.startsWith("http://") || p.startsWith("https://");
    }

    private static String sanitizeNext(String next) {
        if (next == null) return null;
        next = next.trim();
        // Must be internal absolute path, no CRLF
        if (next.isEmpty() || isAbsoluteOrExternal(next) || !next.startsWith("/")) return null;
        if (next.contains("\r") || next.contains("\n")) return null;
        return next;
    }

    private static boolean startsWithAny(String value, Set<String> prefixes) {
        if (value == null) return false;
        for (String p : prefixes) {
            if (value.equals(p) || value.startsWith(p)) return true;
        }
        return false;
    }

    // ===== Session bootstrapping per role =====

    /** Creates a fresh session for STAFF and sets common + role-specific attributes. */
    private static HttpSession createStaffSession(HttpServletRequest req, Staff staff) {
        // Prevent session fixation: invalidate any existing session first
        HttpSession old = req.getSession(false);
        if (old != null) old.invalidate();

        HttpSession s = req.getSession(true);
        s.setAttribute("authType", "staff");                 // <— primary role discriminator
        String role = staff.getRole() == null ? "" : staff.getRole().trim().toLowerCase();
        s.setAttribute("staffRole", role);                   // e.g. "receptionist", "vet"
        s.setAttribute("staffId", staff.getStaffId());
        s.setAttribute("staffName", staff.getFullName());
        s.setAttribute("email", staff.getEmail());

        // Optional convenience flags (use in JSP/servlets if handy)
        s.setAttribute("isReceptionist", "receptionist".equals(role));
        s.setAttribute("isVet", "vet".equals(role));
        s.setAttribute("isPharmacist", "pharmacist".equals(role));

        // Optional: shorter timeout for staff (minutes)
        s.setMaxInactiveInterval(60 * 30); // 30 minutes

        return s;
    }

    /** Creates a fresh session for OWNER and sets common attributes. */
    private static HttpSession createOwnerSession(HttpServletRequest req, Owner owner) {
        // Prevent session fixation: invalidate any existing session first
        HttpSession old = req.getSession(false);
        if (old != null) old.invalidate();

        HttpSession s = req.getSession(true);
        s.setAttribute("authType", "owner");                 // <— primary role discriminator
        s.setAttribute("ownerId", owner.getOwnerId());
        s.setAttribute("ownerName", owner.getFullName());
        s.setAttribute("email", owner.getEmail());

        // Optional: longer timeout for owners
        s.setMaxInactiveInterval(60 * 60); // 60 minutes

        return s;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String email   = req.getParameter("email");
        String password= req.getParameter("password");
        String rawNext = req.getParameter("next");
        String next    = sanitizeNext(rawNext);

        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp?e=Email+and+password+required");
            return;
        }

        try {
            // ===== Try STAFF first =====
            Staff staff = StaffDAO.findByEmail(email);
            if (staff != null && PasswordUtil.verify(password, staff.getPasswordHash())) {
                HttpSession s = createStaffSession(req, staff);

                // Role-based default landing
                String role = ((String) s.getAttribute("staffRole"));
                String defaultStaffHome = "/views/staff-home.jsp";
                if ("receptionist".equals(role)) {
                    defaultStaffHome = "/views/appointment-management/receptionist-dashboard.jsp";
                } else if ("pharmacist".equals(role)) {
                    defaultStaffHome = "/views/inventory-management/inventory_management_home.jsp";
                } else if ("manager".equals(role)) {
                    defaultStaffHome = "/staff/management";
                } else if ("vet".equals(role) || "veterinarian".equals(role)) {
                    defaultStaffHome = "/medical/records";
                } else if ("groomer".equals(role)) {
                    defaultStaffHome = "/grooming/sessions";
                }

                // Staff can go to any internal 'next'
                String dest = (next != null) ? next : defaultStaffHome;
                res.sendRedirect(req.getContextPath() + dest);
                return;
            }

            // ===== Try OWNER next =====
            Owner owner = OwnerDAO.findByEmail(email);
            if (owner != null && PasswordUtil.verify(password, owner.getPasswordHash())) {
                createOwnerSession(req, owner);

                String defaultOwnerHome = "/owner/dashboard";

                // If 'next' points to a staff-only area, ignore it
                String dest;
                if (next != null && !startsWithAny(next, STAFF_ONLY_PREFIXES)) {
                    dest = next;
                } else {
                    dest = defaultOwnerHome;
                }

                res.sendRedirect(req.getContextPath() + dest);
                return;
            }

            // No match
            res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp?e=Invalid+credentials");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/login.jsp?e=Server+error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp");
    }
}



