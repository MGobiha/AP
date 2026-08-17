package controller;

import dao.UserDAO;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        UserDAO dao = new UserDAO();
        Users user = dao.login(username, password);

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=1");
            return;
        }

        // ✅ Save session
        HttpSession session = req.getSession(true);
        session.setAttribute("user", user);

        // ✅ Role based redirect
        String role = user.getRole() == null ? "" : user.getRole().toUpperCase();

        if ("ADMIN".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/admin"); // goes to AdminController doGet (page null → dashboard)
            return;
        }

        // If you use STAFF_L1 / STAFF_L2 / STAFF_L3
        if (role.startsWith("STAFF")) {
           resp.sendRedirect(req.getContextPath() + "/staff_dashboard.jsp");
            return;
        }

        // CLIENT / VIP_CLIENT
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }
}