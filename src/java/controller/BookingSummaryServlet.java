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
import java.time.LocalDate;

@WebServlet("/bookingSummary")
public class BookingSummaryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Users user = AuthUtil.currentUser(req);
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        if (!AuthUtil.isClient(user)) {
            resp.sendRedirect("index.jsp");
            return;
        }

        String roomIdRaw = req.getParameter("roomId");
        String inStr = req.getParameter("checkIn");
        String outStr = req.getParameter("checkOut");

        if (ValidationUtil.isBlank(roomIdRaw) || ValidationUtil.isBlank(inStr) || ValidationUtil.isBlank(outStr)) {
            resp.sendRedirect("packages.jsp?error=dates");
            return;
        }

        int roomId;
        LocalDate checkIn;
        LocalDate checkOut;
        try {
            roomId = Integer.parseInt(roomIdRaw);
            checkIn = LocalDate.parse(inStr);
            checkOut = LocalDate.parse(outStr);
        } catch (Exception e) {
            resp.sendRedirect("packages.jsp?error=dates");
            return;
        }

        if (!ValidationUtil.isValidDateRange(checkIn, checkOut)) {
            resp.sendRedirect("book.jsp?roomId=" + roomId + "&error=range");
            return;
        }

        ReservationDAO dao = DAOFactory.getInstance().createReservationDAO();
        ReservationDAO.RoomInfo room = dao.getRoomInfo(roomId);

        if (room == null) {
            resp.sendRedirect("packages.jsp?error=room");
            return;
        }

        double total = dao.calculateTotal(room.price, checkIn, checkOut);

        req.setAttribute("roomId", roomId);
        req.setAttribute("roomNo", room.roomNo);
        req.setAttribute("roomType", room.roomType);
        req.setAttribute("price", room.price);
        req.setAttribute("checkIn", checkIn.toString());
        req.setAttribute("checkOut", checkOut.toString());
        req.setAttribute("total", total);

        req.getRequestDispatcher("booking_summary.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect("packages.jsp");
    }
}
