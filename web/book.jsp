<%@page import="model.Users"%>
<%@page import="util.AuthUtil"%>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (!AuthUtil.isClient(user)) {
        response.sendRedirect("index.jsp");
        return;
    }
    String roomId = request.getParameter("roomId");
    if (roomId == null || roomId.isBlank()) {
        response.sendRedirect("packages.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Select Dates</title>
  <style>
    body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;}
    .card{max-width:520px;margin:40px auto;background:#fff;padding:24px;border-radius:16px;border:1px solid #e9edf5;}
    label{display:block;font-weight:700;margin:12px 0 6px;}
    input{width:100%;padding:10px;border:1px solid #ddd;border-radius:10px;box-sizing:border-box;}
    .btn{margin-top:16px;background:#1b4fff;color:#fff;border:none;border-radius:12px;padding:12px 16px;font-weight:800;cursor:pointer;}
    .alert{background:#ffecec;color:#c21818;padding:10px;border-radius:10px;}
  </style>
</head>
<body>
<jsp:include page="components/header.jsp"/>
<div class="card">
  <h2>Select stay dates</h2>
  <% if (request.getParameter("error") != null) { %>
    <p class="alert">Check-out must be after check-in.</p>
  <% } %>
  <form action="<%= request.getContextPath() %>/bookingSummary" method="post">
    <input type="hidden" name="roomId" value="<%= roomId %>">
    <label>Check-in</label>
    <input type="date" name="checkIn" required>
    <label>Check-out</label>
    <input type="date" name="checkOut" required>
    <button class="btn" type="submit">Continue to summary</button>
  </form>
</div>
</body>
</html>
