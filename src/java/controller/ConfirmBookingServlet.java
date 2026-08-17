package controller;

import dao.ReservationDAO;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;

@WebServlet("/confirmBooking")
public class ConfirmBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Users user = (Users) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String[] roomIds = req.getParameterValues("roomId");
        if (roomIds == null || roomIds.length == 0) {
            resp.sendRedirect(req.getContextPath() + "/bookNow");
            return;
        }

        ReservationDAO dao = new ReservationDAO();
        String reservationNo = dao.generateReservationNo();

        boolean allOk = true;

        for (String rid : roomIds) {
            int roomId = Integer.parseInt(rid);

            String inStr = req.getParameter("checkIn_" + roomId);
            String outStr = req.getParameter("checkOut_" + roomId);

            if (inStr == null || outStr == null || inStr.isBlank() || outStr.isBlank()) {
                allOk = false;
                continue;
            }

            LocalDate checkIn = LocalDate.parse(inStr);
            LocalDate checkOut = LocalDate.parse(outStr);

            // basic validation
            if (!checkOut.isAfter(checkIn)) {
                allOk = false;
                continue;
            }

            boolean ok = dao.createReservationAndBookRoom(
                    reservationNo,
                    user.getId(),
                    roomId,
                    checkIn,
                    checkOut
            );

            if (!ok) allOk = false;
        }

        if (allOk) {
            resp.sendRedirect(req.getContextPath() + "/booking_success.jsp?resNo=" +
                    URLEncoder.encode(reservationNo, StandardCharsets.UTF_8));
        } else {
            resp.sendRedirect(req.getContextPath() + "/booking_failed.jsp");
        }
    }
}