package com.happypaws.petcare.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "SessionCheckServlet", urlPatterns = {"/session-check"})
public class SessionCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Prevent caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        HttpSession session = request.getSession(false);
        PrintWriter out = response.getWriter();
        
        if (session != null) {
            String authType = (String) session.getAttribute("authType");
            
            if (authType != null) {
                // User is logged in
                out.print("{");
                out.print("\"isLoggedIn\": true,");
                out.print("\"authType\": \"" + authType + "\"");
                
                if ("staff".equals(authType)) {
                    String staffRole = (String) session.getAttribute("staffRole");
                    Object staffIdObj = session.getAttribute("staffId");
                    if (staffRole != null) {
                        out.print(",\"staffRole\": \"" + staffRole + "\"");
                    }
                    if (staffIdObj != null) {
                        out.print(",\"staffId\": \"" + staffIdObj + "\"");
                    }
                } else if ("owner".equals(authType)) {
                    Object ownerIdObj = session.getAttribute("ownerId");
                    if (ownerIdObj != null) {
                        out.print(",\"ownerId\": \"" + ownerIdObj + "\"");
                    }
                }
                
                out.print("}");
            } else {
                // Session exists but no auth info
                out.print("{\"isLoggedIn\": false, \"authType\": null}");
            }
        } else {
            // No session
            out.print("{\"isLoggedIn\": false, \"authType\": null}");
        }
        
        out.flush();
    }
}