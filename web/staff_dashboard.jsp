<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.ReservationView"%>
<%@page import="model.Users"%>
<%@page import="util.AuthUtil"%>
<%
  Users user = (Users) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  if (!AuthUtil.isStaff(user)) { response.sendRedirect("index.jsp"); return; }
  List<ReservationView> recent = (List<ReservationView>) request.getAttribute("recentReservations");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Staff desk</title>
  <style>
    body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;}
    .wrap{max-width:1100px;margin:24px auto;padding:0 16px 40px;}
    .card{background:#fff;border:1px solid #e9edf5;border-radius:16px;padding:20px;margin-bottom:14px;}
    .grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;}
    a.tile{display:block;background:#f3f6ff;border-radius:12px;padding:16px;text-decoration:none;color:#1b4fff;font-weight:800;}
    table{width:100%;border-collapse:collapse;}
    th,td{padding:10px;border-bottom:1px solid #eef1f6;text-align:left;font-size:13px;}
    th{background:#1b4fff;color:#fff;}
    input{padding:10px;border:1px solid #ddd;border-radius:10px;}
    .btn{background:#1b4fff;color:#fff;border:none;border-radius:10px;padding:10px 14px;font-weight:800;}
  </style>
</head>
<body>
<jsp:include page="components/header.jsp"/>
<div class="wrap">
  <div class="card">
    <h2>Staff desk</h2>
    <p>Welcome, <b><%= user.getFullName() != null ? user.getFullName() : user.getUsername() %></b> (<%= user.getRole() %>).</p>
    <div class="grid">
      <a class="tile" href="<%=request.getContextPath()%>/searchReservation">Find a booking</a>
      <a class="tile" href="<%=request.getContextPath()%>/help.jsp">Help / training</a>
      <a class="tile" href="<%=request.getContextPath()%>/myBookings">Recent reservations</a>
    </div>
  </div>
  <div class="card">
    <h3>Quick search</h3>
    <form action="<%=request.getContextPath()%>/searchReservation" method="get">
      <input type="text" name="resNo" placeholder="Reservation number" required>
      <button class="btn" type="submit">Search</button>
    </form>
  </div>
  <div class="card">
    <h3>Latest reservations</h3>
    <table>
      <tr>
        <th>Reservation</th><th>Guest</th><th>Room</th><th>Dates</th><th>Total</th><th>Status</th>
      </tr>
      <% if (recent == null || recent.isEmpty()) { %>
        <tr><td colspan="6">No reservations yet.</td></tr>
      <% } else {
           for (ReservationView v : recent) { %>
        <tr>
          <td><a href="<%=request.getContextPath()%>/searchReservation?resNo=<%= v.getReservationNo() %>"><%= v.getReservationNo() %></a></td>
          <td><%= v.getClientName() %></td>
          <td><%= v.getRoomNo() %></td>
          <td><%= v.getCheckIn() %> → <%= v.getCheckOut() %></td>
          <td>LKR <%= String.format("%.2f", v.getTotalAmount()) %></td>
          <td><%= v.getStatus() %></td>
        </tr>
      <% } } %>
    </table>
  </div>
</div>
</body>
</html>
