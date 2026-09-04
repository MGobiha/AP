<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%@page import="util.AuthUtil"%>
<%
  Users user = (Users) session.getAttribute("user");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
  if (!AuthUtil.isClient(user)) { response.sendRedirect("index.jsp"); return; }
  if (request.getAttribute("roomId") == null) { response.sendRedirect("packages.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Booking Summary</title>
  <style>
    body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;}
    .card{max-width:560px;margin:40px auto;background:#fff;padding:24px;border-radius:16px;border:1px solid #e9edf5;}
    .row{display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #eef1f6;}
    .btn{margin-top:16px;background:#1b4fff;color:#fff;border:none;border-radius:12px;padding:12px 16px;font-weight:800;cursor:pointer;}
    a{color:#1b4fff;}
  </style>
</head>
<body>
<jsp:include page="components/header.jsp"/>
<div class="card">
  <h2>Booking summary</h2>
  <div class="row"><span>Guest</span><b><%= user.getFullName() != null ? user.getFullName() : user.getUsername() %></b></div>
  <div class="row"><span>Room</span><b><%= request.getAttribute("roomNo") %> (<%= request.getAttribute("roomType") %>)</b></div>
  <div class="row"><span>Price per night</span><b>LKR <%= request.getAttribute("price") %></b></div>
  <div class="row"><span>Check-in</span><b><%= request.getAttribute("checkIn") %></b></div>
  <div class="row"><span>Check-out</span><b><%= request.getAttribute("checkOut") %></b></div>
  <div class="row"><span>Room total</span><b>LKR <%= request.getAttribute("total") %></b></div>

  <form action="<%= request.getContextPath() %>/confirmBooking" method="post">
    <input type="hidden" name="roomId" value="<%= request.getAttribute("roomId") %>">
    <input type="hidden" name="checkIn" value="<%= request.getAttribute("checkIn") %>">
    <input type="hidden" name="checkOut" value="<%= request.getAttribute("checkOut") %>">
    <button class="btn" type="submit">Confirm booking</button>
  </form>
  <p><a href="packages.jsp">Back to packages</a></p>
</div>
</body>
</html>
