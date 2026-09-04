package controller;

import factory.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;
import util.ValidationUtil;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/profileUpdate")
public class ProfileUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users u = (Users) request.getSession().getAttribute("user");
        if (u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fullName = ValidationUtil.trim(request.getParameter("fullName"));
        String phone = ValidationUtil.trim(request.getParameter("phone"));
        String address = ValidationUtil.trim(request.getParameter("address"));

        if (!ValidationUtil.isValidName(fullName) || !ValidationUtil.isValidPhone(phone)
                || !ValidationUtil.isValidAddress(address)) {
            response.sendRedirect("profile_edit.jsp?error=" +
                    URLEncoder.encode("Please enter a valid name, phone and address.", StandardCharsets.UTF_8));
            return;
        }

        boolean ok = DAOFactory.getInstance().createUserDAO()
                .updateProfile(u.getId(), fullName, phone, address);

        if (ok) {
            u.setFullName(fullName);
            u.setPhone(phone);
            u.setAddress(address);
            request.getSession().setAttribute("user", u);
            response.sendRedirect("profile.jsp");
        } else {
            response.sendRedirect("profile_edit.jsp?error=" +
                    URLEncoder.encode("Could not save profile.", StandardCharsets.UTF_8));
        }
    }
}
