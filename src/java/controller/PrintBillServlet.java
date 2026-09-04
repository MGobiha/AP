package controller;

import factory.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ReservationView;
import model.Users;
import service.BillingService;
import util.AuthUtil;
import util.ValidationUtil;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/printBill")
public class PrintBillServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Users user = AuthUtil.currentUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String resNo = ValidationUtil.trim(req.getParameter("resNo"));
        if (ValidationUtil.isBlank(resNo)) {
            resp.sendRedirect(req.getContextPath() + "/searchReservation");
            return;
        }

        ReservationView found = DAOFactory.getInstance()
                .createReservationDAO()
                .findByReservationNo(resNo);

        if (found == null) {
            req.setAttribute("message", "Reservation not found.");
            req.getRequestDispatcher("reservation_search.jsp").forward(req, resp);
            return;
        }

        if (AuthUtil.isClient(user) && found.getUserId() != user.getId()) {
            resp.sendRedirect(req.getContextPath() + "/searchReservation?error=forbidden");
            return;
        }

        BillingService billing = new BillingService();
        LocalDate in = found.getCheckIn().toLocalDate();
        LocalDate out = found.getCheckOut().toLocalDate();
        long nights = billing.countNights(in, out);
        double roomTotal = billing.calculateRoomTotal(found.getPricePerNight(), in, out);
        double serviceFee = BillingService.CONSULTATION_EQUIVALENT_FEE;
        double grandTotal = roomTotal + serviceFee;

        req.setAttribute("reservation", found);
        req.setAttribute("nights", nights);
        req.setAttribute("roomTotal", roomTotal);
        req.setAttribute("serviceFee", serviceFee);
        req.setAttribute("grandTotal", grandTotal);
        req.getRequestDispatcher("bill.jsp").forward(req, resp);
    }
}
