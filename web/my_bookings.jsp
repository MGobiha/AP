<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.ReservationView"%>
<%@page import="model.Users"%>
<%
  Users user = (Users) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  List<ReservationView> list = (List<ReservationView>) request.getAttribute("reservations");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>My bookings</title>
  <style>
    body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;}
    .wrap{max-width:1000px;margin:30px auto;padding:0 16px;}
    .card{background:#fff;border:1px solid #e9edf5;border-radius:16px;padding:22px;}
    table{width:100%;border-collapse:collapse;}
    th,td{padding:10px;border-bottom:1px solid #eef1f6;text-align:left;font-size:13px;}
    th{background:#1b4fff;color:#fff;}
    a{color:#1b4fff;font-weight:700;}
  </style>
</head>
<body>
<jsp:include page="components/header.jsp"/>
<div class="wrap">
  <div class="card">
    <h2>Reservations</h2>
    <table>
      <tr>
        <th>Number</th><th>Guest</th><th>Room</th><th>Check-in</th><th>Check-out</th><th>Total</th><th>Bill</th>
      </tr>
      <% if (list == null || list.isEmpty()) { %>
        <tr><td colspan="7">No bookings found.</td></tr>
      <% } else {
           for (ReservationView v : list) { %>
        <tr>
          <td><a href="<%=request.getContextPath()%>/searchReservation?resNo=<%= v.getReservationNo() %>"><%= v.getReservationNo() %></a></td>
          <td><%= v.getClientName() %></td>
          <td><%= v.getRoomNo() %> (<%= v.getRoomType() %>)</td>
          <td><%= v.getCheckIn() %></td>
          <td><%= v.getCheckOut() %></td>
          <td>LKR <%= String.format("%.2f", v.getTotalAmount()) %></td>
          <td><a href="<%=request.getContextPath()%>/printBill?resNo=<%= v.getReservationNo() %>">Print</a></td>
        </tr>
      <% } } %>
    </table>
  </div>
</div>
</body>
</html>
