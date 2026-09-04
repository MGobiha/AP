<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.ReservationView"%>
<%
  ReservationView r = (ReservationView) request.getAttribute("reservation");
  if (r == null) { response.sendRedirect("searchReservation"); return; }
  Long nights = (Long) request.getAttribute("nights");
  Double roomTotal = (Double) request.getAttribute("roomTotal");
  Double serviceFee = (Double) request.getAttribute("serviceFee");
  Double grandTotal = (Double) request.getAttribute("grandTotal");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Guest bill | <%= r.getReservationNo() %></title>
  <style>
    body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;color:#111;}
    .wrap{max-width:720px;margin:30px auto;padding:0 16px;}
    .bill{background:#fff;border:1px solid #e9edf5;border-radius:16px;padding:28px;}
    .head{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:18px;}
    table{width:100%;border-collapse:collapse;}
    th,td{padding:10px 0;border-bottom:1px solid #eef1f6;text-align:left;}
    .right{text-align:right;}
    .total{font-size:18px;font-weight:800;}
    .btn{background:#1b4fff;color:#fff;border:none;border-radius:10px;padding:10px 14px;font-weight:800;cursor:pointer;}
    .muted{color:#666;font-size:13px;}
    @media print {
      .no-print{display:none !important;}
      body{background:#fff;}
      .bill{border:none;}
    }
  </style>
</head>
<body>
<div class="no-print"><jsp:include page="components/header.jsp"/></div>
<div class="wrap">
  <div class="bill">
    <div class="head">
      <div>
        <h2>Ocean View Resort</h2>
        <p class="muted">Guest bill / receipt</p>
      </div>
      <div class="right">
        <b><%= r.getReservationNo() %></b><br>
        Status: <%= r.getStatus() %>
      </div>
    </div>
    <p><b>Guest:</b> <%= r.getClientName() %><br>
       <b>Address:</b> <%= r.getClientAddress() %><br>
       <b>Contact:</b> <%= r.getClientPhone() %></p>
    <table>
      <tr><th>Description</th><th class="right">Amount (LKR)</th></tr>
      <tr>
        <td>Room <%= r.getRoomNo() %> (<%= r.getRoomType() %>)<br>
            <span class="muted"><%= r.getCheckIn() %> to <%= r.getCheckOut() %> · <%= nights %> night(s) × <%= String.format("%.2f", r.getPricePerNight()) %></span>
        </td>
        <td class="right"><%= String.format("%.2f", roomTotal) %></td>
      </tr>
      <tr>
        <td>Service / facility fee</td>
        <td class="right"><%= String.format("%.2f", serviceFee) %></td>
      </tr>
      <tr>
        <td class="total">Grand total</td>
        <td class="right total"><%= String.format("%.2f", grandTotal) %></td>
      </tr>
    </table>
    <p class="muted">Thank you for staying with Ocean View Resort. This receipt can be printed for the guest file.</p>
    <p class="no-print">
      <button class="btn" type="button" onclick="window.print()">Print bill</button>
    </p>
  </div>
</div>
</body>
</html>
