package controller;

import dao.UserDAO;
import factory.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.ValidationUtil;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = ValidationUtil.trim(request.getParameter("fullName"));
        String phone = ValidationUtil.trim(request.getParameter("phone"));
        String address = ValidationUtil.trim(request.getParameter("address"));
        String username = ValidationUtil.trim(request.getParameter("username"));
        String password = request.getParameter("password");

        String error = null;
        if (!ValidationUtil.isValidName(fullName)) {
            error = "Enter a full name with at least 3 characters.";
        } else if (!ValidationUtil.isValidPhone(phone)) {
            error = "Enter a valid phone number (9 to 15 digits).";
        } else if (!ValidationUtil.isValidAddress(address)) {
            error = "Enter a complete address.";
        } else if (!ValidationUtil.isValidUsername(username)) {
            error = "Username must be 4-50 letters, numbers, dot, underscore or hyphen.";
        } else if (!ValidationUtil.isValidPassword(password)) {
            error = "Password must be at least 6 characters.";
        } else if ("ADMIN".equalsIgnoreCase(username) || username.toUpperCase().startsWith("STAFF")) {
            error = "That username is reserved.";
        }

        UserDAO dao = DAOFactory.getInstance().createUserDAO();
        if (error == null && dao.usernameExists(username)) {
            error = "Username already exists. Please choose another.";
        }

        if (error != null) {
            response.sendRedirect("register.jsp?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8));
            return;
        }

        boolean ok = dao.registerClient(fullName, phone, address, username, password, "CLIENT");
        if (ok) {
            response.sendRedirect("login.jsp?registered=1");
        } else {
            response.sendRedirect("register.jsp?error=" + URLEncoder.encode("Could not create the account. Try again.", StandardCharsets.UTF_8));
        }
    }
}
