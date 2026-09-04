package controller;

import factory.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import util.AuthUtil;
import util.ValidationUtil;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = ValidationUtil.trim(req.getParameter("username"));
        String password = req.getParameter("password");

        if (ValidationUtil.isBlank(username) || ValidationUtil.isBlank(password)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=required");
            return;
        }

        Users user = DAOFactory.getInstance().createUserDAO().login(username, password);

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=1");
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("user", user);

        if (AuthUtil.isAdmin(user)) {
            resp.sendRedirect(req.getContextPath() + "/admin?page=dashboard");
            return;
        }
        if (AuthUtil.isStaff(user)) {
            resp.sendRedirect(req.getContextPath() + "/staff");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }
}
