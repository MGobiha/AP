<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.DashboardDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ReservationView" %>
<%@ page import="factory.DAOFactory" %>
<%
    DashboardDAO ddao = DAOFactory.getInstance().createDashboardDAO();
    int totalRooms = ddao.countRooms();
    int availableRooms = ddao.countAvailableRooms();
    int bookedRooms = ddao.countBookedRooms();
    int confirmed = ddao.countConfirmed();
    double revenue = ddao.sumConfirmedRevenue();
    List<ReservationView> recentReservations =
        (List<ReservationView>) request.getAttribute("recentReservations");
    double occupancy = totalRooms == 0 ? 0 : (bookedRooms * 100.0 / totalRooms);
%>
<jsp:include page="components/admin_layout_top.jsp">
  <jsp:param name="active" value="reports"/>
</jsp:include>
<style>
  .page-title{font-size:20px;font-weight:900;margin:4px 0 14px;}
  .grid{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;}
  .card{background:#fff;border:1px solid #e9edf5;border-radius:16px;padding:16px;}
  .label{font-size:12px;color:#666;font-weight:900;}
  .value{font-size:24px;font-weight:900;margin-top:6px;}
  table{width:100%;border-collapse:collapse;margin-top:16px;}
  th,td{padding:12px 14px;text-align:left;border-bottom:1px solid #eef1f6;font-size:13px;}
  th{color:#fff;background:#1b4fff;}
  @media(max-width:1100px){ .grid{grid-template-columns:repeat(2,1fr);} }
</style>
<div class="page-title">Management reports</div>
<div class="grid">
  <div class="card"><div class="label">Occupancy</div><div class="value"><%= String.format("%.0f", occupancy) %>%</div></div>
  <div class="card"><div class="label">Available rooms</div><div class="value"><%= availableRooms %></div></div>
  <div class="card"><div class="label">Confirmed bookings</div><div class="value"><%= confirmed %></div></div>
  <div class="card"><div class="label">Confirmed revenue</div><div class="value">LKR <%= String.format("%.2f", revenue) %></div></div>
</div>
<table>
  <thead>
    <tr>
      <th>Reservation</th><th>Guest</th><th>Room</th><th>Check-in</th><th>Check-out</th><th>Total</th><th>Status</th>
    </tr>
  </thead>
  <tbody>
  <% if (recentReservations == null || recentReservations.isEmpty()) { %>
    <tr><td colspan="7">No reservations yet.</td></tr>
  <% } else {
       for (ReservationView r : recentReservations) { %>
    <tr>
      <td><a href="<%=request.getContextPath()%>/searchReservation?resNo=<%= r.getReservationNo() %>"><%= r.getReservationNo() %></a></td>
      <td><%= r.getClientName() %></td>
      <td><%= r.getRoomNo() %></td>
      <td><%= r.getCheckIn() %></td>
      <td><%= r.getCheckOut() %></td>
      <td>LKR <%= String.format("%.2f", r.getTotalAmount()) %></td>
      <td><%= r.getStatus() %></td>
    </tr>
  <% } } %>
  </tbody>
</table>
<jsp:include page="components/admin_layout_bottom.jsp"/>
