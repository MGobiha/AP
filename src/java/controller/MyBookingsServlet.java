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

@WebServlet("/myBookings")
public class MyBookingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Users user = AuthUtil.currentUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        if (AuthUtil.isClient(user)) {
            req.setAttribute("reservations",
                    DAOFactory.getInstance().createReservationDAO().findByUserId(user.getId()));
        } else {
            req.setAttribute("reservations",
                    DAOFactory.getInstance().createReservationDAO().findRecent(50));
        }
        req.getRequestDispatcher("my_bookings.jsp").forward(req, resp);
    }
}
