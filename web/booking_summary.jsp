<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%
  Users user = (Users) session.getAttribute("user");
  if(user == null){ response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Booking Summary</title></head>
<body>

<h2>Booking Summary</h2>

<p><b>User:</b> <%= user.getUsername() %></p>
<p><b>Room:</b> <%= request.getAttribute("roomNo") %> (<%= request.getAttribute("roomType") %>)</p>
<p><b>Price per Night:</b> $<%= request.getAttribute("price") %></p>
<p><b>Check-in:</b> <%= request.getAttribute("checkIn") %></p>
<p><b>Check-out:</b> <%= request.getAttribute("checkOut") %></p>
<p><b>Total:</b> $<%= request.getAttribute("total") %></p>

<form action="<%= request.getContextPath() %>/confirmBooking" method="post">
  <input type="hidden" name="roomId" value="<%= request.getAttribute("roomId") %>">
  <input type="hidden" name="checkIn" value="<%= request.getAttribute("checkIn") %>">
  <input type="hidden" name="checkOut" value="<%= request.getAttribute("checkOut") %>">
  <input type="hidden" name="total" value="<%= request.getAttribute("total") %>">
  <button type="submit">Confirm Book Now</button>
</form>

<br>
<a href="packages.jsp">Back to Packages</a>

</body>
</html>