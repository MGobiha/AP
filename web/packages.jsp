<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.RoomDAO"%>
<%@page import="java.util.*"%>
<%@page import="model.Room"%>
<%@page import="model.Users"%>
<%@page import="factory.DAOFactory"%>
<%
    Users user = (Users) session.getAttribute("user");
    List<Room> rooms = DAOFactory.getInstance().createRoomDAO().findAll();
    Map<String, List<Room>> byType = new LinkedHashMap<>();
    if (rooms != null) {
        for (Room r : rooms) {
            String type = r.getRoomType() == null ? "Standard" : r.getRoomType();
            byType.computeIfAbsent(type, k -> new ArrayList<>()).add(r);
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<title>Packages | Ocean View Resort</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
  body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;}
  .container{max-width:900px;margin:30px auto;padding:0 16px;}
  .package{background:#fff;padding:18px;border-radius:14px;margin-bottom:14px;border:1px solid #e9edf5;}
  .rooms{margin-top:12px;background:#eef2ff;border-radius:12px;padding:12px;}
  .row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid rgba(0,0,0,.06);gap:10px;}
  .row:last-child{border-bottom:none;}
  .tagB{color:#c21818;font-weight:800;}
  .btn{background:#1b4fff;color:#fff;border:none;border-radius:10px;padding:8px 12px;cursor:pointer;text-decoration:none;font-weight:700;}
  .alert{background:#ffecec;color:#c21818;padding:10px 12px;border-radius:10px;margin-bottom:14px;}
</style>
</head>
<body>
<jsp:include page="components/header.jsp"/>
<div class="container">
  <h2>Room Packages</h2>
  <p style="color:#444;margin:8px 0 18px;">Choose a room type, then continue to dates and billing.</p>
  <% if (request.getParameter("error") != null) { %>
    <div class="alert">Please choose a valid room and date range.</div>
  <% } %>
  <% if (byType.isEmpty()) { %>
    <p>No rooms are configured yet. Ask an administrator to add rooms.</p>
  <% } %>
  <% for (Map.Entry<String, List<Room>> entry : byType.entrySet()) { %>
    <div class="package">
      <h3><%= entry.getKey() %> Package</h3>
      <div class="rooms">
        <% for (Room r : entry.getValue()) { %>
          <div class="row">
            <div><b>Room <%= r.getRoomNo() %></b> — LKR <%= String.format("%.2f", r.getPrice()) %></div>
            <% if ("AVAILABLE".equalsIgnoreCase(r.getStatus())) { %>
              <form action="book.jsp" method="get" style="margin:0;">
                <input type="hidden" name="roomId" value="<%= r.getId() %>">
                <button class="btn" type="submit">Select</button>
              </form>
            <% } else { %>
              <span class="tagB"><%= r.getStatus() %></span>
            <% } %>
          </div>
        <% } %>
      </div>
    </div>
  <% } %>
</div>
</body>
</html>
