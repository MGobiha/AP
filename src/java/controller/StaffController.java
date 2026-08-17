package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Users;

@WebServlet("/staff")
public class StaffController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Users user = (Users) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String role = user.getRole() == null ? "" : user.getRole().toUpperCase();
        if (!role.startsWith("STAFF")) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        req.getRequestDispatcher("staff_dashboard.jsp").forward(req, resp);
    }
}