<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.DashboardDAO" %>
<%@ page import="java.util.*" %>
<%@page import="java.util.List"%>
<%@page import="model.ReservationView"%>

<%
List<ReservationView> recentReservations =
    (List<ReservationView>) request.getAttribute("recentReservations");
%>
<%
    DashboardDAO ddao = new DashboardDAO();

    int totalRooms = ddao.countRooms();
    int availableRooms = ddao.countAvailableRooms();
    int bookedRooms = ddao.countBookedRooms();
    int totalReservations = ddao.countReservations();

    List<String[]> recent = ddao.recentReservations();
%>

<jsp:include page="components/admin_layout_top.jsp">
  <jsp:param name="active" value="dashboard"/>
</jsp:include>

<style>
  .page-title{font-size:20px;font-weight:900;margin:4px 0 14px;}
  .grid{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;}
  .card{background:#fff;border:1px solid #e9edf5;border-radius:16px;padding:16px;box-shadow:0 10px 20px rgba(10,20,40,.06);}
  .label{font-size:12px;color:#666;font-weight:900;}
  .value{font-size:26px;font-weight:900;margin-top:6px;}
  .badge{display:inline-block;margin-top:10px;padding:6px 10px;border-radius:999px;font-size:12px;font-weight:900;background:#eafff1;color:#0e8a3a;border:1px solid #bff3d0;}

  .panel{margin-top:14px;background:#fff;border:1px solid #e9edf5;border-radius:16px;box-shadow:0 10px 20px rgba(10,20,40,.06);overflow:hidden;}
  .panel-head{padding:14px 16px;border-bottom:1px solid #e9edf5;display:flex;align-items:center;justify-content:space-between;}
  .panel-head h3{font-size:15px;font-weight:900;}
  table{width:100%;border-collapse:collapse;}
  th,td{padding:12px 14px;text-align:left;border-bottom:1px solid #eef1f6;font-size:13px;}
  th{color:#fff;font-weight:900;background:linear-gradient(180deg,#1b4fff,#1442d7);}
  tr:hover td{background:#fbfdff;}
  .status{display:inline-block;padding:5px 10px;border-radius:999px;font-weight:900;font-size:12px;border:1px solid transparent;}
  .ok{background:#eafff1;color:#0e8a3a;border-color:#bff3d0;}
  .bad{background:#ffecec;color:#c21818;border-color:#ffcaca;}
  .hold{background:#f1f5f9;color:#334155;border-color:#e2e8f0;}

  @media(max-width:1100px){ .grid{grid-template-columns:repeat(2,1fr);} }
  @media(max-width:820px){ .grid{grid-template-columns:1fr;} }
</style>

<div class="page-title">Admin Dashboard</div>

<!-- Stat Cards -->
<div class="grid">
    <div class="card">
        <div class="label">Total Rooms</div>
        <div class="value"><%= totalRooms %></div>
        <span class="badge">Live</span>
    </div>

    <div class="card">
        <div class="label">Available Rooms</div>
        <div class="value"><%= availableRooms %></div>
        <span class="badge">Ready</span>
    </div>

    <div class="card">
        <div class="label">Booked Rooms</div>
        <div class="value"><%= bookedRooms %></div>
        <span class="badge">Occupied</span>
    </div>

    <div class="card">
        <div class="label">Total Reservations</div>
        <div class="value"><%= totalReservations %></div>
        <span class="badge">All Time</span>
    </div>
</div>

<!-- Recent Reservations -->
<div class="panel">
    <div class="panel-head">
        <h3>Recent Reservations</h3>
        <!-- change/remove if you don't have admin_bookings.jsp -->
<!--        <a class="logout" style="padding:8px 12px;border-radius:10px;text-decoration:none;"
           href="admin_bookings.jsp">View All</a>-->
    </div>

   <div class="table-card">
    

    <table>
        <thead>
            <tr>
                <th>Reservation No</th>
                <th>Client</th>
                <th>Room</th>
                <th>Check-in</th>
                <th>Check-out</th>
                <th>Total</th>
                <th>Status</th>
            </tr>
        </thead>

        <tbody>

        <%
        if (recentReservations == null || recentReservations.isEmpty()) {
        %>

            <tr>
                <td colspan="7">No reservations yet.</td>
            </tr>

        <%
        } else {

            for (ReservationView r : recentReservations) {
        %>

            <tr>
                <td><%= r.getReservationNo() %></td>
                <td><%= r.getClientName() %></td>
                <td><%= r.getRoomNo() %></td>
                <td><%= r.getCheckIn() %></td>
                <td><%= r.getCheckOut() %></td>
                <td>$<%= r.getTotalAmount() %></td>
                <td><%= r.getStatus() %></td>
            </tr>

        <%
            }
        }
        %>

        </tbody>
    </table>
</div>
</div>

<jsp:include page="components/admin_layout_bottom.jsp"/>