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
  <title>Edit Profile</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:Segoe UI,Arial,sans-serif;}
    body{background:#f5f7fb;}
    .wrap{max-width:520px;margin:30px auto;padding:0 16px;}
    .card{background:#fff;border-radius:18px;padding:22px;box-shadow:0 10px 22px rgba(0,0,0,.08);}
    h2{margin-bottom:14px;color:#1b4fff;}
    label{display:block;font-weight:800;color:#555;font-size:13px;margin-top:12px;margin-bottom:6px;}
    input{width:100%;padding:12px;border:1px solid #ddd;border-radius:12px;outline:none;}
    input:focus{border-color:#1b4fff;box-shadow:0 0 0 3px rgba(27,79,255,.12);}
    .btn{margin-top:16px;width:100%;border:none;border-radius:14px;padding:12px;background:#1b4fff;color:#fff;font-weight:800;cursor:pointer;}
    .btn:hover{filter:brightness(.95);}
    .link{display:block;text-align:center;margin-top:10px;color:#1b4fff;text-decoration:none;font-weight:800;}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="card">
      <h2>Edit Profile</h2>

      <form action="profileUpdate" method="post">
        <label>Full Name</label>
        <input type="text" name="fullName" value="<%= u.getFullName()==null? "": u.getFullName() %>" required>

        <label>Phone</label>
        <input type="text" name="phone" value="<%= u.getPhone()==null? "": u.getPhone() %>" required>

        <label>Address</label>
        <input type="text" name="address" value="<%= u.getAddress()==null? "": u.getAddress() %>" required>

        <button class="btn" type="submit">Save</button>
      </form>

      <a class="link" href="profile.jsp">Cancel</a>
    </div>
  </div>
</body>
</html>