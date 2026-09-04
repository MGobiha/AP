package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.Users;

public class AuthUtil {

    private AuthUtil() {
    }

    public static Users currentUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return null;
        }
        Object raw = session.getAttribute("user");
        return (raw instanceof Users) ? (Users) raw : null;
    }

    public static boolean isAdmin(Users user) {
        return user != null && user.getRole() != null && "ADMIN".equalsIgnoreCase(user.getRole());
    }

    public static boolean isStaff(Users user) {
        return user != null && user.getRole() != null && user.getRole().toUpperCase().startsWith("STAFF");
    }

    public static boolean isClient(Users user) {
        if (user == null || user.getRole() == null) {
            return false;
        }
        String role = user.getRole().toUpperCase();
        return "CLIENT".equals(role) || "VIP_CLIENT".equals(role);
    }

    public static boolean canManageReservations(Users user) {
        return isAdmin(user) || isStaff(user);
    }
}
