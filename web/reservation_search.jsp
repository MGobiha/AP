<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.ReservationView"%>
<%@page import="model.Users"%>
<%
  Users user = (Users) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  ReservationView r = (ReservationView) request.getAttribute("reservation");
  String message = (String) request.getAttribute("message");
  String q = request.getParameter("resNo");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Find reservation</title>
  <style>
    body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;}
    .wrap{max-width:760px;margin:30px auto;padding:0 16px;}
    .card{background:#fff;border:1px solid #e9edf5;border-radius:16px;padding:22px;}
    input{padding:10px 12px;border:1px solid #ddd;border-radius:10px;width:60%;}
    .btn{background:#1b4fff;color:#fff;border:none;border-radius:10px;padding:10px 14px;font-weight:800;cursor:pointer;}
    table{width:100%;border-collapse:collapse;margin-top:16px;}
    th,td{text-align:left;padding:10px;border-bottom:1px solid #eef1f6;}
    .alert{background:#ffecec;color:#c21818;padding:10px;border-radius:10px;}
    a.btnlink{display:inline-block;margin-top:12px;background:#1b4fff;color:#fff;text-decoration:none;padding:10px 14px;border-radius:10px;font-weight:800;}
  </style>
</head>
<body>
<jsp:include page="components/header.jsp"/>
<div class="wrap">
  <div class="card">
    <h2>Display reservation details</h2>
    <p>Search using the unique reservation number issued at booking.</p>
    <form action="<%=request.getContextPath()%>/searchReservation" method="get">
      <input type="text" name="resNo" placeholder="RES-YYYYMMDD-..." value="<%= q == null ? "" : q %>" required>
      <button class="btn" type="submit">Search</button>
    </form>
    <% if (message != null) { %>
      <p class="alert"><%= message %></p>
    <% } %>
    <% if (r != null) { %>
      <table>
        <tr><th>Reservation no</th><td><%= r.getReservationNo() %></td></tr>
        <tr><th>Guest name</th><td><%= r.getClientName() %></td></tr>
        <tr><th>Address</th><td><%= r.getClientAddress() %></td></tr>
        <tr><th>Contact</th><td><%= r.getClientPhone() %></td></tr>
        <tr><th>Room</th><td><%= r.getRoomNo() %> (<%= r.getRoomType() %>)</td></tr>
        <tr><th>Check-in</th><td><%= r.getCheckIn() %></td></tr>
        <tr><th>Check-out</th><td><%= r.getCheckOut() %></td></tr>
        <tr><th>Total</th><td>LKR <%= String.format("%.2f", r.getTotalAmount()) %></td></tr>
        <tr><th>Status</th><td><%= r.getStatus() %></td></tr>
      </table>
      <a class="btnlink" href="<%=request.getContextPath()%>/printBill?resNo=<%= r.getReservationNo() %>">Calculate / print bill</a>
    <% } %>
  </div>
</div>
</body>
</html>
