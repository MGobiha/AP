package controller;

import dao.ReservationDAO;
import factory.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;
import util.AuthUtil;
import util.ValidationUtil;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;

@WebServlet("/confirmBooking")
public class ConfirmBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Users user = AuthUtil.currentUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        if (!AuthUtil.isClient(user)) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        String[] roomIds = req.getParameterValues("roomId");
        if (roomIds == null || roomIds.length == 0) {
            resp.sendRedirect(req.getContextPath() + "/bookNow");
            return;
        }

        ReservationDAO dao = DAOFactory.getInstance().createReservationDAO();
        String reservationNo = dao.generateReservationNo();
        int booked = 0;

        for (String rid : roomIds) {
            int roomId;
            try {
                roomId = Integer.parseInt(rid);
            } catch (NumberFormatException e) {
                continue;
            }

            String inStr = firstNonBlank(
                    req.getParameter("checkIn_" + roomId),
                    req.getParameter("checkIn")
            );
            String outStr = firstNonBlank(
                    req.getParameter("checkOut_" + roomId),
                    req.getParameter("checkOut")
            );

            if (ValidationUtil.isBlank(inStr) || ValidationUtil.isBlank(outStr)) {
                continue;
            }

            LocalDate checkIn;
            LocalDate checkOut;
            try {
                checkIn = LocalDate.parse(inStr);
                checkOut = LocalDate.parse(outStr);
            } catch (Exception e) {
                continue;
            }

            if (!ValidationUtil.isValidDateRange(checkIn, checkOut)) {
                continue;
            }

            boolean ok = dao.createReservationAndBookRoom(
                    reservationNo,
                    user.getId(),
                    roomId,
                    checkIn,
                    checkOut
            );
            if (ok) {
                booked++;
            }
        }

        if (booked > 0) {
            resp.sendRedirect(req.getContextPath() + "/booking_success.jsp?resNo=" +
                    URLEncoder.encode(reservationNo, StandardCharsets.UTF_8));
        } else {
            resp.sendRedirect(req.getContextPath() + "/booking_failed.jsp");
        }
    }

    private String firstNonBlank(String a, String b) {
        if (!ValidationUtil.isBlank(a)) {
            return a.trim();
        }
        if (!ValidationUtil.isBlank(b)) {
            return b.trim();
        }
        return null;
    }
}
