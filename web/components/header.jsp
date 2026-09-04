<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%
    Users u = (Users) session.getAttribute("user");
    boolean loggedIn = (u != null);
    String username = loggedIn ? u.getUsername() : "";
    String role = loggedIn && u.getRole() != null ? u.getRole() : "";
    String avatarLetter = "U";
    if (loggedIn && username != null && username.length() > 0) {
        avatarLetter = username.substring(0, 1).toUpperCase();
    }
    boolean isAdmin = "ADMIN".equalsIgnoreCase(role);
    boolean isStaff = role.toUpperCase().startsWith("STAFF");
    boolean isClient = "CLIENT".equalsIgnoreCase(role) || "VIP_CLIENT".equalsIgnoreCase(role);
%>
<style>
  .nav{position:sticky;top:0;z-index:10;background:#fff;border-bottom:1px solid #eef1f6;}
  .container{max-width:1100px;margin:0 auto;padding:0 18px;}
  .nav-inner{height:70px;display:flex;align-items:center;justify-content:space-between;gap:12px;}
  .brand{font-weight:800;font-size:20px;letter-spacing:.2px;color:#111;text-decoration:none;}
  .menu{display:flex;gap:8px;align-items:center;flex-wrap:wrap;}
  .menu a{text-decoration:none;color:#444;font-size:14px;padding:8px 10px;border-radius:10px;}
  .menu a:hover{background:#f3f6ff;color:#1b4fff;}
  .actions{display:flex;gap:10px;align-items:center;flex-wrap:wrap;}
  .btn{text-decoration:none;font-size:14px;font-weight:600;padding:10px 14px;border-radius:999px;display:inline-block;border:1px solid #dbe3ff;}
  .btn-outline{color:#1b4fff;background:#fff;}
  .btn-outline:hover{background:#f3f6ff;}
  .btn-primary{background:#1b4fff;color:#fff;border-color:#1b4fff;}
  .user-pill{display:flex;gap:10px;align-items:center;padding:8px 12px;border-radius:999px;border:1px solid #eef1f6;background:#fff;text-decoration:none;color:#111;}
  .avatar{width:34px;height:34px;border-radius:50%;background:#1b4fff;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;}
  .name{font-weight:700;font-size:14px;max-width:140px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
</style>
<div class="nav">
  <div class="container">
    <div class="nav-inner">
      <a class="brand" href="<%=request.getContextPath()%>/index.jsp">OceanView</a>
      <div class="menu">
        <a href="<%=request.getContextPath()%>/index.jsp#packages">Packages</a>
        <a href="<%=request.getContextPath()%>/packages.jsp">Rooms</a>
        <a href="<%=request.getContextPath()%>/searchReservation">Find booking</a>
        <!--<a href="<%=request.getContextPath()%>/help.jsp">Help</a>-->
      </div>
      <div class="actions">
        <a class="btn btn-primary" href="<%=request.getContextPath()%>/bookNow">Book Now</a>
        <% if(!loggedIn){ %>
          <a class="btn btn-outline" href="<%=request.getContextPath()%>/login.jsp">Sign in</a>
          <a class="btn btn-outline" href="<%=request.getContextPath()%>/register.jsp">Register</a>
        <% } else { %>
          <a class="user-pill" href="<%=request.getContextPath()%>/profile.jsp">
            <div class="avatar"><%= avatarLetter %></div>
            <div class="name"><%= username %></div>
          </a>
          <% if(isAdmin){ %>
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/admin">Dashboard</a>
          <% } else if(isStaff){ %>
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/staff">Staff desk</a>
          <% } else if(isClient){ %>
            <a class="btn btn-outline" href="<%=request.getContextPath()%>/myBookings">My bookings</a>
          <% } %>
          <a class="btn btn-outline" href="<%=request.getContextPath()%>/logout">Logout</a>
        <% } %>
      </div>
    </div>
  </div>
</div>
