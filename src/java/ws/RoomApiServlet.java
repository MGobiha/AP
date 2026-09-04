package ws;

import factory.DAOFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Room;
import util.JsonUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * REST web service for room inventory.
 * GET /api/rooms
 * GET /api/rooms?status=AVAILABLE
 */
@WebServlet("/api/rooms")
public class RoomApiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        if (!ReservationApiServlet.isAuthorized(req)) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(JsonUtil.error(401, "Provide a valid X-Api-Key header or a logged-in session."));
            return;
        }

        String status = req.getParameter("status");
        List<Room> rooms;
        if (status == null || status.isBlank()) {
            rooms = DAOFactory.getInstance().createRoomDAO().findAll();
        } else {
            rooms = DAOFactory.getInstance().createRoomDAO().findByStatus(status);
        }

        StringBuilder sb = new StringBuilder();
        sb.append("{\"ok\":true,\"count\":").append(rooms.size()).append(",\"rooms\":[");
        for (int i = 0; i < rooms.size(); i++) {
            Room r = rooms.get(i);
            if (i > 0) {
                sb.append(",");
            }
            sb.append(JsonUtil.object(
                    "id", String.valueOf(r.getId()),
                    "roomNo", JsonUtil.quote(r.getRoomNo()),
                    "roomType", JsonUtil.quote(r.getRoomType()),
                    "price", String.valueOf(r.getPrice()),
                    "status", JsonUtil.quote(r.getStatus())
            ));
        }
        sb.append("]}");
        out.print(sb);
    }
}
