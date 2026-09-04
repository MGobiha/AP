package controller;

import factory.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ReservationView;
import model.Users;
import util.AuthUtil;
import util.ValidationUtil;

import java.io.IOException;

@WebServlet("/searchReservation")
public class SearchReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handle(req, resp);
    }

    private void handle(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Users user = AuthUtil.currentUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String resNo = ValidationUtil.trim(req.getParameter("resNo"));
        if (!ValidationUtil.isBlank(resNo)) {
            ReservationView found = DAOFactory.getInstance()
                    .createReservationDAO()
                    .findByReservationNo(resNo);

            if (found == null) {
                req.setAttribute("message", "No reservation found for " + resNo);
            } else if (AuthUtil.isClient(user) && found.getUserId() != user.getId()) {
                req.setAttribute("message", "You can only view your own reservations.");
            } else {
                req.setAttribute("reservation", found);
            }
        }

        req.getRequestDispatcher("reservation_search.jsp").forward(req, resp);
    }
}
