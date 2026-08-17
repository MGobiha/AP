<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Booking Success</title>
  <style>
    body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;}
    .box{max-width:720px;margin:60px auto;background:#fff;padding:24px;border-radius:16px;border:1px solid #e9edf5;}
    .btn{display:inline-block;margin-top:14px;background:#1b4fff;color:#fff;padding:10px 14px;border-radius:12px;text-decoration:none;font-weight:800;}
  </style>
</head>
<body>
  <div class="box">
    <h2>Booking Confirmed ✅</h2>
    <p>Your reservation number is: <b><%= request.getParameter("resNo") %></b></p>
    <a class="btn" href="index.jsp">Go Home</a>
  </div>
</body>
</html>