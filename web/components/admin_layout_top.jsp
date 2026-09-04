<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Users" %>
<%
  Users u = (Users) session.getAttribute("user");
  if(u == null){ response.sendRedirect("login.jsp"); return; }
  if(!"ADMIN".equalsIgnoreCase(u.getRole())){ response.sendRedirect("index.jsp"); return; }

  String active = request.getParameter("active");
  if(active == null) active = request.getParameter("page");
  if(active == null) active = "dashboard";

  String uname = u.getUsername();
%>

<style>
  *{box-sizing:border-box;margin:0;padding:0;font-family:Segoe UI, Arial, sans-serif;}
  body{background:#f3f5f9;color:#111;}

  .app{display:flex;min-height:100vh;}
  .sidebar{width:260px;background:#fff;border-right:1px solid #e9edf5;position:sticky;top:0;height:100vh;}
  .brand{display:flex;align-items:center;gap:10px;padding:18px;border-bottom:1px solid #e9edf5;font-weight:900;color:#1b4fff;}
  .logo{width:34px;height:34px;border-radius:10px;background:#1b4fff;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:900;}

  .profile{padding:18px;border-bottom:1px solid #e9edf5;display:flex;gap:12px;align-items:center;}
  .avatar{width:52px;height:52px;border-radius:50%;background:linear-gradient(135deg,#1b4fff,#6b8cff);color:#fff;display:flex;align-items:center;justify-content:center;font-size:18px;font-weight:900;}
  .pname{font-weight:900;}
  .prole{font-size:12px;color:#666;margin-top:2px;}

  .nav{padding:10px;}
  .nav a{display:flex;align-items:center;gap:10px;padding:12px;margin:6px 0;border-radius:12px;text-decoration:none;color:#2b2f38;font-weight:700;font-size:14px;}
  .nav a:hover{background:#f3f6ff;color:#1b4fff;}
  .nav a.active{background:#1b4fff;color:#fff;}
  /*.dot{width:9px;height:9px;border-radius:50%;background:currentColor;opacity:.85;}*/

  .main{flex:1;display:flex;flex-direction:column;}
  .topbar{height:68px;background:#fff;border-bottom:1px solid #e9edf5;display:flex;align-items:center;justify-content:space-between;padding:0 18px;position:sticky;top:0;z-index:5;}
  .search{flex:1;max-width:520px;display:flex;align-items:center;gap:10px;background:#f3f5f9;border:1px solid #e9edf5;border-radius:999px;padding:10px 14px;}
  .search input{border:none;outline:none;background:transparent;width:100%;font-size:14px;}
  .right{display:flex;align-items:center;gap:14px;}
  .chip{background:#f3f6ff;border:1px solid #dbe3ff;color:#1b4fff;padding:8px 12px;border-radius:999px;font-weight:800;font-size:13px;}
  .logout{text-decoration:none;background:#1b4fff;color:#fff;padding:10px 14px;border-radius:12px;font-weight:900;font-size:13px;}
  .logout:hover{filter:brightness(.95);}

  .content{padding:18px;}

  @media(max-width:820px){ .sidebar{display:none;} .search{max-width:100%;} }
</style>

<div class="app">

  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="brand"><div class="logo">OV</div>Ocean View Resort</div>

    <div class="profile">
      <div class="avatar"><%= uname.substring(0,1).toUpperCase() %></div>
      <div>
        <div class="pname"><%= uname %></div>
        <div class="prole">Administrator</div>
      </div>
    </div>

    <div class="nav">
      <a class="<%= "dashboard".equals(active) ? "active" : "" %>" href="<%=request.getContextPath()%>/admin?page=dashboard"><span class="dot"></span> Dashboard</a>
      <a class="<%= "packages".equals(active) ? "active" : "" %>" href="<%=request.getContextPath()%>/admin?page=packages"><span class="dot"></span> Packages</a>
      <a class="<%= "rooms".equals(active) ? "active" : "" %>" href="<%=request.getContextPath()%>/admin?page=rooms"><span class="dot"></span> Rooms</a>
      <a class="<%= "staff".equals(active) ? "active" : "" %>" href="<%=request.getContextPath()%>/admin?page=staff"><span class="dot"></span> Staff</a>
      <a class="<%= "clients".equals(active) ? "active" : "" %>" href="<%=request.getContextPath()%>/admin?page=clients"><span class="dot"></span> Clients</a>
      <a class="<%= "reports".equals(active) ? "active" : "" %>" href="<%=request.getContextPath()%>/admin?page=reports"><span class="dot"></span> Reports</a>
      <a href="<%=request.getContextPath()%>/searchReservation"><span class="dot"></span> Find booking</a>
<!--      <a href="<%=request.getContextPath()%>/help.jsp"><span class="dot"></span> Help</a>-->
    </div>
  </aside>

  <!-- Main -->
  <main class="main">

    <!-- Topbar -->
    <div class="topbar">
      <div class="search">
        <form action="<%=request.getContextPath()%>/searchReservation" method="get" style="display:flex;width:100%;gap:8px;">
          <input type="text" name="resNo" placeholder="Search reservation number (RES-...)" />
        </form>
      </div>
      <div class="right">
        <span class="chip">My Account: <%= uname %></span>
        <a class="logout" href="<%=request.getContextPath()%>/logout">Logout</a>
      </div>
    </div>

    <div class="content">