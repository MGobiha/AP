package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Force role = CLIENT (clients only)
        String role = "CLIENT";

        UserDAO dao = new UserDAO();

        // Prevent staff/admin keywords (optional extra safety)
        if ("ADMIN".equalsIgnoreCase(username) || "STAFF".equalsIgnoreCase(username)) {
            response.sendRedirect("register.jsp");
            return;
        }

        boolean ok = dao.registerClient(fullName, phone, address, username, password, role);

        if (ok) {
            response.sendRedirect("login.jsp"); // after registration go to login
        } else {
            response.sendRedirect("register.jsp"); // username exists or error
        }
    }
    
    
}