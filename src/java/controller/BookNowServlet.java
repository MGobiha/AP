package controller;

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

@WebServlet("/bookNow")
public class BookNowServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Users user = AuthUtil.currentUser(req);
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        req.setAttribute("availableRooms", DAOFactory.getInstance().createRoomDAO().findAvailableRooms());
        req.getRequestDispatcher("booking_select_rooms.jsp").forward(req, resp);
    }
}
