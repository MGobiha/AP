<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.RoomDAO"%>
<%@page import="java.util.*"%>
<%@page import="model.Room"%>
<%@page import="model.Users"%>

<%
    Users user = (Users) session.getAttribute("user"); // can be null (guest can browse)
    RoomDAO dao = new RoomDAO();

    List<Room> deluxe = dao.getRoomsByType("Deluxe");
    List<Room> luxury = dao.getRoomsByType("Luxury");
%>

<!DOCTYPE html>
<html>
<head>
<title>Packages</title>

<style>
  body{font-family:Arial;background:#f5f7fb;}
  .container{max-width:900px;margin:30px auto;padding:0 16px;}
  .package{background:#fff;padding:18px;border-radius:14px;margin-bottom:14px;box-shadow:0 8px 20px rgba(0,0,0,.08);cursor:pointer;}
  .rooms{display:none;margin-top:12px;background:#eef2ff;border-radius:12px;padding:12px;}
  .row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid rgba(0,0,0,.06);}
  .row:last-child{border-bottom:none;}
  .tagA{color:green;font-weight:800;}
  .tagB{color:red;font-weight:800;}
  .btn{background:#1b4fff;color:#fff;border:none;border-radius:10px;padding:8px 12px;cursor:pointer;}
  .btn:disabled{background:#9aa7ff;cursor:not-allowed;}
</style>
<script>
  function toggleRooms(id){
    const el = document.getElementById(id);
    el.style.display = (el.style.display === "block") ? "none" : "block";
  }
</script>
</head>
<body>
    <jsp:include page="header.jsp"/>
<div class="container">

  <h2>Room Packages</h2>
  <p style="color:#444;margin:8px 0 18px;">
    Select a package → choose an available room → continue booking.
  </p>

  <!-- Deluxe -->
  <div class="package" onclick="toggleRooms('deluxeRooms')">
    <h3>Deluxe Package</h3>
    <p>$120 / Night</p>

    <div class="rooms" id="deluxeRooms" onclick="event.stopPropagation();">
      <% for(Room r : deluxe){ %>
        <div class="row">
          <div>
            <b>Room <%= r.getRoomNo() %></b> — $<%= r.getPrice() %>
          </div>

          <% if("AVAILABLE".equalsIgnoreCase(r.getStatus())){ %>
            <form action="book.jsp" method="get" style="margin:0;">
              <input type="hidden" name="roomId" value="<%= r.getId() %>">
              <button class="btn" type="submit">Select</button>
            </form>
          <% } else { %>
            <span class="tagB">Booked</span>
          <% } %>
        </div>
      <% } %>
    </div>
  </div>

  <!-- Luxury -->
  <div class="package" onclick="toggleRooms('luxuryRooms')">
    <h3>Luxury Package</h3>
    <p>$200 / Night</p>

    <div class="rooms" id="luxuryRooms" onclick="event.stopPropagation();">
      <% for(Room r : luxury){ %>
        <div class="row">
          <div>
            <b>Room <%= r.getRoomNo() %></b> — $<%= r.getPrice() %>
          </div>

          <% if("AVAILABLE".equalsIgnoreCase(r.getStatus())){ %>
            <form action="book.jsp" method="get" style="margin:0;">
              <input type="hidden" name="roomId" value="<%= r.getId() %>">
              <button class="btn" type="submit">Select</button>
            </form>
          <% } else { %>
            <span class="tagB">Booked</span>
          <% } %>
        </div>
      <% } %>
    </div>
  </div>

</div>
</body>
</html>