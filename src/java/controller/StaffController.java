package controller;

import factory.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;
import util.AuthUtil;

import java.io.IOException;

@WebServlet("/staff")
public class StaffController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Users user = AuthUtil.currentUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        if (!AuthUtil.isStaff(user)) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        req.setAttribute("recentReservations",
                DAOFactory.getInstance().createReservationDAO().findRecent(15));
        req.getRequestDispatcher("staff_dashboard.jsp").forward(req, resp);
    }
}
