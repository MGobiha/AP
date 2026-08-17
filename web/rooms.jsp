<%@ page import="java.util.*" %>

<%
String pkg = request.getParameter("package");
%>

<!DOCTYPE html>
<html>
<head>
<title>Available Rooms</title>
<link rel="stylesheet" href="css/style.css">
<style>
body{font-family:Arial;background:#f4f6f9}
.container{max-width:1000px;margin:auto;padding:20px}
.grid{display:grid;grid-template-columns:repeat(4,1fr);gap:15px}
.room{background:white;padding:20px;border-radius:10px;text-align:center}
.available{border:2px solid green}
.booked{border:2px solid red}
.btn{background:#1b4fff;color:white;padding:6px 10px;text-decoration:none;border-radius:6px}
.bookedText{color:red}
</style>

</head>
<body>

<div class="container">

<h2>Rooms for <%= pkg %> Package</h2>

<div class="grid">

<div class="room available">
<h3>Room 101</h3>
<p>Status: Available</p>
<a class="btn" href="booking.jsp?room=101&package=<%=pkg%>">Select</a>
</div>

<div class="room booked">
<h3>Room 102</h3>
<p class="bookedText">Booked</p>
</div>

<div class="room available">
<h3>Room 103</h3>
<p>Status: Available</p>
<a class="btn" href="booking.jsp?room=103&package=<%=pkg%>">Select</a>
</div>

<div class="room available">
<h3>Room 104</h3>
<p>Status: Available</p>
<a class="btn" href="booking.jsp?room=104&package=<%=pkg%>">Select</a>
</div>

</div>

</div>

</body>
</html>