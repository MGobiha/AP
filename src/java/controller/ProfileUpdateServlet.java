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
import dao.UserDAO;
import jakarta.servlet.http.*;
import model.Users;

@WebServlet("/profileUpdate")
public class ProfileUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users u = (Users) request.getSession().getAttribute("user");
        if (u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        UserDAO dao = new UserDAO();
        boolean ok = dao.updateProfile(u.getId(), fullName, phone, address);

        if (ok) {
            // update session object so UI shows new values instantly
            u.setFullName(fullName);
            u.setPhone(phone);
            u.setAddress(address);
            request.getSession().setAttribute("user", u);

            response.sendRedirect("profile.jsp");
        } else {
            response.sendRedirect("profile_edit.jsp");
        }
    }
}