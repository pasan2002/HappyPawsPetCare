package com.happypaws.petcare.servlet.user;

import com.happypaws.petcare.dao.user.OwnerDAO;
import com.happypaws.petcare.dao.user.StaffDAO;
import com.happypaws.petcare.model.Owner;
import com.happypaws.petcare.model.Staff;
import com.happypaws.petcare.util.PasswordUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/owner-signup")
public class OwnerSignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");

        if (fullName==null || email==null || phone==null || password==null || confirm==null
                || fullName.isBlank() || email.isBlank() || phone.isBlank() || password.isBlank() || confirm.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/views/user-management/signup.jsp?e=All+fields+are+required");
            return;
        }
        if (!password.equals(confirm)) {
            res.sendRedirect(req.getContextPath() + "/views/user-management/signup.jsp?e=Passwords+do+not+match");
            return;
        }

        try {
            boolean ownerExists = OwnerDAO.emailExists(email);
            Staff s = StaffDAO.findByEmail(email);
            if (ownerExists || s != null) {
                res.sendRedirect(req.getContextPath() + "/views/user-management/signup.jsp?e=Email+already+in+use");
                return;
            }

            Owner o = new Owner();
            o.setFullName(fullName);
            o.setEmail(email);
            o.setPhone(phone);
            o.setPasswordHash(PasswordUtil.hash(password));
            OwnerDAO.insert(o);

            res.sendRedirect(req.getContextPath() + "/views/user-management/login.jsp?ok=Account+created.+Please+sign+in");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/views/user-management/signup.jsp?e=Server+error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.sendRedirect(req.getContextPath() + "/views/user-management/signup.jsp");
    }
}



