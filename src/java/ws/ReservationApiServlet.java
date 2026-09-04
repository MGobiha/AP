package ws;

import dao.ReservationDAO;
import factory.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ReservationView;
import util.JsonUtil;
import util.ValidationUtil;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * REST web service for reservation lookup.
 * GET /api/reservations?resNo=RES-20260902-123
 */
@WebServlet("/api/reservations")
public class ReservationApiServlet extends HttpServlet {

    public static final String API_KEY = "oceanview-demo-key";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        if (!isAuthorized(req)) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(JsonUtil.error(401, "Provide a valid X-Api-Key header or a logged-in session."));
            return;
        }

        String resNo = ValidationUtil.trim(req.getParameter("resNo"));
        if (ValidationUtil.isBlank(resNo)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(JsonUtil.error(400, "Query parameter resNo is required."));
            return;
        }

        ReservationView found = DAOFactory.getInstance().createReservationDAO().findByReservationNo(resNo);
        if (found == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print(JsonUtil.error(404, "Reservation not found."));
            return;
        }

        out.print(JsonUtil.object(
                "ok", "true",
                "reservationNo", JsonUtil.quote(found.getReservationNo()),
                "guestName", JsonUtil.quote(found.getClientName()),
                "phone", JsonUtil.quote(found.getClientPhone()),
                "address", JsonUtil.quote(found.getClientAddress()),
                "roomNo", JsonUtil.quote(found.getRoomNo()),
                "roomType", JsonUtil.quote(found.getRoomType()),
                "checkIn", JsonUtil.quote(String.valueOf(found.getCheckIn())),
                "checkOut", JsonUtil.quote(String.valueOf(found.getCheckOut())),
                "totalAmount", String.valueOf(found.getTotalAmount()),
                "status", JsonUtil.quote(found.getStatus())
        ));
    }

    static boolean isAuthorized(HttpServletRequest req) {
        String key = req.getHeader("X-Api-Key");
        if (API_KEY.equals(key)) {
            return true;
        }
        return req.getSession(false) != null && req.getSession(false).getAttribute("user") != null;
    }
}
