<%@page import="model.Users"%>
<%
    Users user = (Users) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }
    if(!"CLIENT".equalsIgnoreCase(user.getRole())){
        response.sendRedirect("index.jsp");
        return;
    }
    String roomId = request.getParameter("roomId");
%>

<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Select Dates</title></head>
<body>
<h2>Select Dates</h2>

<form action="<%= request.getContextPath() %>/bookingSummary" method="post">
    <input type="hidden" name="roomId" value="<%= roomId %>">
    Check-in: <input type="date" name="checkIn" required>
    Check-out: <input type="date" name="checkOut" required>
    <button type="submit">Continue</button>
</form>

</body>
</html>