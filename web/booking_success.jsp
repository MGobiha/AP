<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Booking Success</title>
  <style>
    body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;}
    .box{max-width:720px;margin:60px auto;background:#fff;padding:24px;border-radius:16px;border:1px solid #e9edf5;}
    .btn{display:inline-block;margin:8px 8px 0 0;background:#1b4fff;color:#fff;padding:10px 14px;border-radius:12px;text-decoration:none;font-weight:800;}
    .btn.gray{background:#4b5563;}
  </style>
</head>
<body>
<jsp:include page="components/header.jsp"/>
  <div class="box">
    <h2>Booking confirmed</h2>
    <p>Your reservation number is: <b><%= request.getParameter("resNo") %></b></p>
    <p>Keep this number. Staff can search it, and you can print the bill.</p>
    <a class="btn" href="<%=request.getContextPath()%>/printBill?resNo=<%= request.getParameter("resNo") %>">Print bill</a>
    <a class="btn gray" href="<%=request.getContextPath()%>/searchReservation?resNo=<%= request.getParameter("resNo") %>">View details</a>
    <a class="btn gray" href="index.jsp">Go home</a>
  </div>
</body>
</html>
