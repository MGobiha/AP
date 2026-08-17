<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%
    Users u = (Users) session.getAttribute("user");
    if(u == null){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>My Profile</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:Segoe UI,Arial,sans-serif;}
    body{background:#f5f7fb;}
    .wrap{max-width:700px;margin:30px auto;padding:0 16px;}
    .card{background:#fffefe;border-radius:18px;padding:22px;box-shadow:0 10px 22px rgba(0,0,0,.08);}
    h2{margin-bottom:10px;color:#1b4fff;}
    .row{display:grid;grid-template-columns:160px 1fr;gap:12px;padding:10px 0;border-bottom:1px solid #eef1f6;}
    .row:last-child{border-bottom:none;}
    .label{color:#666;font-weight:700;}
    .value{color:#111;}
    .btn{display:inline-block;margin-top:14px;text-decoration:none;background:#1b4fff;color:#fff;padding:10px 14px;border-radius:12px;font-weight:700;}
    .btn.gray{background:#4b5563;}
    .btn.logout{
  background:#dc2626;
}
  </style>
</head>
<body>
    <jsp:include page="components/header.jsp"/>
  <div class="wrap">
    <div class="card">
      <h2>My Profile</h2>

      <div class="row"><div class="label">Username</div><div class="value"><%= u.getUsername() %></div></div>
      <div class="row"><div class="label">Role</div><div class="value"><%= u.getRole() %></div></div>
      <div class="row"><div class="label">Full Name</div><div class="value"><%= u.getFullName() == null ? "-" : u.getFullName() %></div></div>
      <div class="row"><div class="label">Phone</div><div class="value"><%= u.getPhone() == null ? "-" : u.getPhone() %></div></div>
      <div class="row"><div class="label">Address</div><div class="value"><%= u.getAddress() == null ? "-" : u.getAddress() %></div></div>

      <a class="btn" href="profile_edit.jsp">Edit Profile</a>
        <a class="btn gray" href="dashboard.jsp">Back</a>
        <a class="btn gray" href="<%=request.getContextPath()%>/logout">Logout</a>
    </div>
  </div>
</body>
</html>