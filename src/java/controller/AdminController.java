package controller;

import dao.PackageDAO;
import dao.RoomDAO;
import dao.UserDAO;
import dao.ReservationDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Package;
import model.Room;
import model.Users;

import java.io.IOException;

@WebServlet("/admin")
public class AdminController extends HttpServlet {

    private final PackageDAO packageDAO = new PackageDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    // =========================
    // AUTH CHECK (ADMIN ONLY)
    // =========================
    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;

        Users u = (Users) session.getAttribute("user");
        return (u != null && "ADMIN".equalsIgnoreCase(u.getRole()));
    }

    // =========================
    // LOAD ADMIN PAGES (GET)
    // =========================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String page = req.getParameter("page");
        if (page == null) page = "dashboard";

        switch (page) {

            case "dashboard":
                // ✅ load recent reservations for dashboard table
                req.setAttribute("recentReservations", reservationDAO.findRecent(10));
                req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
                return;

            case "packages":
                req.setAttribute("packages", packageDAO.findAll());
                req.getRequestDispatcher("admin_packages.jsp").forward(req, resp);
                return;

            case "rooms":
                req.setAttribute("rooms", roomDAO.findAll());
                req.setAttribute("packages", packageDAO.findAll());
                req.getRequestDispatcher("admin_rooms.jsp").forward(req, resp);
                return;

            case "staff":
                // if you use staff levels, use a method like findStaffAllLevels()
                req.setAttribute("staff", userDAO.findStaff()); 
                req.getRequestDispatcher("admin_staff.jsp").forward(req, resp);
                return;

            case "clients":
                req.setAttribute("clients", userDAO.findClients()); // CLIENT + VIP_CLIENT
                req.getRequestDispatcher("admin_clients.jsp").forward(req, resp);
                return;

            default:
                resp.sendRedirect(req.getContextPath() + "/admin?page=dashboard");
        }
    }

    // =========================
    // HANDLE ADMIN ACTIONS (POST)
    // =========================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin?page=dashboard");
            return;
        }

        System.out.println("ADMIN POST action=" + action + " id=" + req.getParameter("id"));

        // -------------------------
        // PACKAGES
        // -------------------------
        if ("package_add".equals(action)) {
            Package p = new Package();
            p.setName(req.getParameter("name"));
            p.setDescription(req.getParameter("description"));
            p.setPricePerNight(Double.parseDouble(req.getParameter("price")));
            p.setStatus(req.getParameter("status"));

            packageDAO.insert(p);
            resp.sendRedirect(req.getContextPath() + "/admin?page=packages");
            return;
        }

        if ("package_update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));

            Package p = new Package();
            p.setId(id);
            p.setName(req.getParameter("name"));
            p.setDescription(req.getParameter("description"));
            p.setPricePerNight(Double.parseDouble(req.getParameter("price")));
            p.setStatus(req.getParameter("status"));

            packageDAO.update(p);
            resp.sendRedirect(req.getContextPath() + "/admin?page=packages");
            return;
        }

        if ("package_delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            packageDAO.delete(id);

            resp.sendRedirect(req.getContextPath() + "/admin?page=packages");
            return;
        }

        // -------------------------
        // ROOMS
        // -------------------------
        if ("room_add".equals(action)) {
            Room r = new Room();
            r.setRoomNo(req.getParameter("roomNo"));
            r.setRoomType(req.getParameter("roomType"));
            r.setPrice(Double.parseDouble(req.getParameter("price")));
            r.setStatus(req.getParameter("status"));
            r.setPackageId(Integer.parseInt(req.getParameter("packageId")));

            roomDAO.insert(r);
            resp.sendRedirect(req.getContextPath() + "/admin?page=rooms");
            return;
        }

        if ("room_update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));

            Room r = new Room();
            r.setId(id);
            r.setRoomNo(req.getParameter("roomNo"));
            r.setRoomType(req.getParameter("roomType"));
            r.setPrice(Double.parseDouble(req.getParameter("price")));
            r.setStatus(req.getParameter("status"));
            r.setPackageId(Integer.parseInt(req.getParameter("packageId")));

            roomDAO.update(r);
            resp.sendRedirect(req.getContextPath() + "/admin?page=rooms");
            return;
        }

        if ("room_delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            roomDAO.delete(id);

            resp.sendRedirect(req.getContextPath() + "/admin?page=rooms");
            return;
        }

        // -------------------------
        // STAFF
        // -------------------------
        if ("staff_add".equals(action)) {
            String role = req.getParameter("role"); // STAFF_L1/STAFF_L2/STAFF_L3
            if (role == null || role.isEmpty()) role = "STAFF_L1";

            userDAO.insertUser(
                    req.getParameter("fullName"),
                    req.getParameter("phone"),
                    req.getParameter("address"),
                    req.getParameter("username"),
                    req.getParameter("password"),
                    role
            );

            resp.sendRedirect(req.getContextPath() + "/admin?page=staff");
            return;
        }

        if ("staff_update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));

            String role = req.getParameter("role");
            if (role == null || role.isEmpty()) role = "STAFF_L1";

            // ✅ you must have this method in UserDAO
            userDAO.updateUserWithRole(
                    id,
                    req.getParameter("fullName"),
                    req.getParameter("phone"),
                    req.getParameter("address"),
                    req.getParameter("username"),
                    role
            );

            resp.sendRedirect(req.getContextPath() + "/admin?page=staff");
            return;
        }

        if ("staff_delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            userDAO.deleteUser(id);

            resp.sendRedirect(req.getContextPath() + "/admin?page=staff");
            return;
        }

        // -------------------------
        // CLIENTS
        // -------------------------
        if ("client_add".equals(action)) {
            String role = req.getParameter("role");
            if (!"VIP_CLIENT".equalsIgnoreCase(role)) role = "CLIENT";

            userDAO.insertUser(
                    req.getParameter("fullName"),
                    req.getParameter("phone"),
                    req.getParameter("address"),
                    req.getParameter("username"),
                    req.getParameter("password"),
                    role
            );

            resp.sendRedirect(req.getContextPath() + "/admin?page=clients");
            return;
        }

        if ("client_update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));

            userDAO.updateUser(
                    id,
                    req.getParameter("fullName"),
                    req.getParameter("phone"),
                    req.getParameter("address"),
                    req.getParameter("username")
            );

            String role = req.getParameter("role");
            if (!"VIP_CLIENT".equalsIgnoreCase(role)) role = "CLIENT";
            userDAO.updateRole(id, role);

            resp.sendRedirect(req.getContextPath() + "/admin?page=clients");
            return;
        }

        if ("client_delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            userDAO.deleteUser(id);

            resp.sendRedirect(req.getContextPath() + "/admin?page=clients");
            return;
        }

        // fallback
        resp.sendRedirect(req.getContextPath() + "/admin?page=dashboard");
    }
}