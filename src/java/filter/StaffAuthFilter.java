package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Users;

@WebFilter(urlPatterns = {"/staff", "/staff/*"})
public class StaffAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        Users user = (Users) req.getSession().getAttribute("user");
        String role = (user == null || user.getRole() == null) ? "" : user.getRole().toUpperCase();

        if (user == null || !role.startsWith("STAFF")) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}