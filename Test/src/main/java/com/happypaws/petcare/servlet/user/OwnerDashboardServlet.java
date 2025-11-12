package com.happypaws.petcare.servlet.user;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/owner/dashboard")
public class OwnerDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Check if user is authenticated as owner
        HttpSession session = req.getSession(false);
        if (session == null || !"owner".equals(session.getAttribute("authType"))) {
            res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp?error=Please+login+as+owner");
            return;
        }

        // Forward to owner dashboard JSP
        RequestDispatcher rd = req.getRequestDispatcher("/views/user-management/owner-dashboard.jsp");
        rd.forward(req, res);
    }
}