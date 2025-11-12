package com.happypaws.petcare.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Set;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    // Constants for path strings
    private static final String ACCESS_DENIED_PAGE = "/access-denied.jsp";
    private static final String RECEPTIONIST_DASHBOARD = "/views/appointment-management/receptionist-dashboard.jsp";
    private static final String MEDICAL_RECORDS_PAGE = "/medical/records";
    private static final String INVENTORY_PATH = "/views/inventory-management/";
    private static final String STAFF_PATH = "/staff/";
    private static final String USER_MGMT_PATH = "/views/user-management/";
    private static final String APPOINTMENT_PATH = "/views/appointment-management/";
    private static final String MEDICAL_PATH = "/views/medical-management/";
    private static final String MANAGEMENT_SUFFIX = "management";
    private static final String ADMIN_SUFFIX = "admin";
    
    // Constants for role strings
    private static final String MANAGER_ROLE = "manager";
    private static final String PHARMACIST_ROLE = "pharmacist";
    private static final String RECEPTIONIST_ROLE = "receptionist";
    private static final String VETERINARIAN_ROLE = "veterinarian";
    private static final String VET_ROLE = "vet";  // Short form for veterinarian
    private static final String GROOMER_ROLE = "groomer";
    
    // Authentication type constants
    private static final String AUTH_TYPE_STAFF = "staff";
    private static final String AUTH_TYPE_OWNER = "owner";
    
    // Public pages that do NOT require login
    private static final Set<String> PUBLIC_PATHS = Set.of(
            "/", "/index.jsp",
            "/login", "/logout",
            "/views/user-management/login.jsp",
            "/views/user-management/signup.jsp",
            "/owner-signup", "/owner-signup.jsp",
            ACCESS_DENIED_PAGE
    );

    // API endpoints that require authentication but are accessible to all authenticated users
    private static final Set<String> API_PATHS = Set.of(
            "/appointments", "/appointments/reminder", "/session-check",
            "/api/pets/by-uid", 
            "/api/pets/search",
            "/api/staff/search",
            "/inventory/api/product",
            "/inventory/api/products",
            "/inventory/api/low-stock",
            "/sales/api/product",
            "/sales/api/sale-items",
            "/sales/api/stats"
    );    // Public prefixes (static assets etc.)
    private static final Set<String> PUBLIC_PREFIXES = Set.of(
            "/assets/", "/static/", "/css/", "/js/", "/images/", "/img/", "/fonts/", "/favicon", "/webjars/"
    );

    // Staff-only screens
    private static final Set<String> STAFF_ONLY_PATHS = Set.of(
            RECEPTIONIST_DASHBOARD,
            INVENTORY_PATH + "inventory_management_home.jsp",
            USER_MGMT_PATH + ADMIN_SUFFIX + ".jsp",
            STAFF_PATH + MANAGEMENT_SUFFIX
    );

    // Staff-only prefixes
    private static final Set<String> STAFF_ONLY_PREFIXES = Set.of(
            APPOINTMENT_PATH + "receptionist-dashboard",
            INVENTORY_PATH,
            USER_MGMT_PATH + ADMIN_SUFFIX,
            STAFF_PATH,
            "/api/staff/",
            "/sales/",  // Sales functionality for staff
            MEDICAL_PATH,  // Medical records management
            "/medical/",  // Medical records servlet
            "/views/grooming-management/",  // Grooming records management
            "/grooming/"  // Grooming sessions servlet
    );

    // Owner-only screens
    private static final Set<String> OWNER_ONLY_PATHS = Set.of(
            APPOINTMENT_PATH + "user_appointments.jsp",
            APPOINTMENT_PATH + "appointment_request.jsp",
            "/owner-change-password",
            "/views/owner-change-password-simple.jsp",
            "/views/owner-profile-simple.jsp"
    );

    // Owner-only prefixes
    private static final Set<String> OWNER_ONLY_PREFIXES = Set.of(
            APPOINTMENT_PATH + "user_appointments",
            APPOINTMENT_PATH + "appointment_request",
            "/owner/",
            "/views/owner-"
    );

    // Static file extensions that should always pass
    private static final String[] STATIC_EXTS = {
            ".css", ".js", ".map", ".png", ".jpg", ".jpeg", ".gif", ".svg", ".ico", ".webp",
            ".woff", ".woff2", ".ttf", ".eot", ".pdf"
    };

    @Override
    public void doFilter(ServletRequest sreq, ServletResponse sres, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) sreq;
        HttpServletResponse res = (HttpServletResponse) sres;

        String ctx = req.getContextPath();
        String uri = req.getRequestURI().substring(ctx.length()); // path within app, starts with "/"
        if (uri.isEmpty()) uri = "/";

        // 1) Always allow static resources & explicitly public pages
        if (isStatic(uri) || isPublic(uri)) {
            chain.doFilter(req, res);
            return;
        }

        // 2) Check session
        HttpSession session = req.getSession(false);
        String authType = (session != null) ? (String) session.getAttribute("authType") : null;

        // 3) If not logged in → send to login with ?next=
        if (authType == null) {
            // Add no-cache headers to prevent back button issues after logout
            res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            res.setHeader("Pragma", "no-cache");
            res.setDateHeader("Expires", 0);
            
            redirectToLogin(req, res, ctx, uri);
            return;
        }

        // 4) Allow API endpoints for all authenticated users
        if (isApiPath(uri)) {
            chain.doFilter(req, res);
            return;
        }

        // 5) Role-based checks
        if (AUTH_TYPE_STAFF.equals(authType)) {
            // Block staff from owner-only pages
            if (isOwnerOnly(uri)) {
                String role = (String) session.getAttribute("staffRole");
                redirectToStaffDashboard(res, ctx, role);
                return;
            }
            
            // Check if staff has permission for specific staff areas
            String staffRole = (String) session.getAttribute("staffRole");
            if (!hasStaffPermission(uri, staffRole)) {
                res.sendRedirect(ctx + ACCESS_DENIED_PAGE);
                return;
            }
            
            chain.doFilter(req, res);
            return;
        }

        if (AUTH_TYPE_OWNER.equals(authType)) {
            // Block owners from staff-only pages
            if (isStaffOnly(uri)) {
                res.sendRedirect(ctx + ACCESS_DENIED_PAGE);
                return;
            }
            chain.doFilter(req, res);
            return;
        }

        // Unknown authType → force re-login
        redirectToLogin(req, res, ctx, uri);
    }

    private boolean isPublic(String uri) {
        if (PUBLIC_PATHS.contains(uri)) return true;
        return startsWithAny(uri, PUBLIC_PREFIXES);
    }

    private boolean isApiPath(String uri) {
        return API_PATHS.contains(uri);
    }

    private boolean isStatic(String uri) {
        for (String ext : STATIC_EXTS) {
            if (uri.endsWith(ext)) return true;
        }
        return false;
    }

    private boolean isStaffOnly(String uri) {
        if (STAFF_ONLY_PATHS.contains(uri)) return true;
        return startsWithAny(uri, STAFF_ONLY_PREFIXES);
    }

    private boolean isOwnerOnly(String uri) {
        if (OWNER_ONLY_PATHS.contains(uri)) return true;
        return startsWithAny(uri, OWNER_ONLY_PREFIXES);
    }

    private boolean startsWithAny(String value, Set<String> prefixes) {
        for (String p : prefixes) {
            if (value.equals(p) || value.startsWith(p)) return true;
        }
        return false;
    }

    private boolean hasStaffPermission(String uri, String staffRole) {
        // Admin role has access to all staff areas
        if (ADMIN_SUFFIX.equals(staffRole)) {
            return true;
        }
        
        // Manager role restrictions
        if (MANAGER_ROLE.equals(staffRole)) {
            // Managers can access staff management and most admin features
            return !uri.startsWith(INVENTORY_PATH) || uri.contains(AUTH_TYPE_STAFF) || uri.contains(MANAGEMENT_SUFFIX);
        }
        
        // Pharmacist role restrictions
        if (PHARMACIST_ROLE.equals(staffRole)) {
            // Pharmacists can only access inventory management and basic appointment viewing
            return uri.startsWith(INVENTORY_PATH) || 
                   uri.equals(RECEPTIONIST_DASHBOARD) ||
                   !uri.startsWith(USER_MGMT_PATH) && !uri.startsWith(STAFF_PATH);
        }
        
        // Receptionist role restrictions
        if (RECEPTIONIST_ROLE.equals(staffRole)) {
            // Receptionists can access appointment management but not admin or staff management
            return uri.startsWith(APPOINTMENT_PATH) && 
                   !uri.startsWith(USER_MGMT_PATH) && 
                   !uri.startsWith(STAFF_PATH) &&
                   !uri.startsWith(INVENTORY_PATH);
        }
        
        // Veterinarian role restrictions
        if (VETERINARIAN_ROLE.equals(staffRole) || VET_ROLE.equals(staffRole)) {
            // Vets can access appointment management and medical records
            return (uri.startsWith(APPOINTMENT_PATH) || uri.startsWith(MEDICAL_PATH) || uri.startsWith("/medical/")) && 
                   !uri.startsWith(USER_MGMT_PATH) && 
                   !uri.startsWith(STAFF_PATH) &&
                   !uri.startsWith(INVENTORY_PATH);
        }
        
        // Groomer role restrictions
        if (GROOMER_ROLE.equals(staffRole)) {
            // Groomers can access appointment management and grooming sessions
            return (uri.startsWith(APPOINTMENT_PATH) || uri.startsWith("/views/grooming-management/") || uri.startsWith("/grooming/")) && 
                   !uri.startsWith(USER_MGMT_PATH) && 
                   !uri.startsWith(STAFF_PATH) &&
                   !uri.startsWith(INVENTORY_PATH);
        }
        
        // Default: deny access
        return false;
    }

    private void redirectToStaffDashboard(HttpServletResponse res, String ctx, String role) throws IOException {
        String dashboardUrl = RECEPTIONIST_DASHBOARD; // default
        
        if (MANAGER_ROLE.equals(role)) {
            dashboardUrl = STAFF_PATH + MANAGEMENT_SUFFIX;
        } else if (PHARMACIST_ROLE.equals(role)) {
            dashboardUrl = INVENTORY_PATH + "inventory_management_home.jsp";
        } else if (ADMIN_SUFFIX.equals(role)) {
            dashboardUrl = USER_MGMT_PATH + ADMIN_SUFFIX + ".jsp";
        } else if (VETERINARIAN_ROLE.equals(role) || VET_ROLE.equals(role)) {
            dashboardUrl = MEDICAL_RECORDS_PAGE;
        }
        
        res.sendRedirect(ctx + dashboardUrl);
    }

    private void redirectToLogin(HttpServletRequest req, HttpServletResponse res, String ctx, String uri) throws IOException {
        String next = uri;
        String qs = req.getQueryString();
        if (qs != null && !qs.isEmpty()) next += "?" + qs;
        String encoded = URLEncoder.encode(next, StandardCharsets.UTF_8.name());
        res.sendRedirect(ctx + "/views/user-management/login.jsp?next=" + encoded);
    }
}


