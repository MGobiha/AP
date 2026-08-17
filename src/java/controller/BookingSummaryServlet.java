/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.ReservationDAO;
import dao.ReservationDAO.RoomInfo;
import jakarta.servlet.http.*;
import model.Users;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/bookingSummary")
public class BookingSummaryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Users user = (Users) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect("login.jsp"); return; }
        if (!"CLIENT".equalsIgnoreCase(user.getRole())) { resp.sendRedirect("index.jsp"); return; }

        int roomId = Integer.parseInt(req.getParameter("roomId"));
        LocalDate checkIn = LocalDate.parse(req.getParameter("checkIn"));
        LocalDate checkOut = LocalDate.parse(req.getParameter("checkOut"));

        ReservationDAO dao = new ReservationDAO();
        RoomInfo room = dao.getRoomInfo(roomId);

        if (room == null) { resp.sendRedirect("packages.jsp"); return; }

        double total = dao.calculateTotal(room.price, checkIn, checkOut);

        // Pass data to JSP
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
    // If someone opens /bookingSummary directly, send them back
    resp.sendRedirect("packages.jsp");
}
}