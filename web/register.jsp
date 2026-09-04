<%-- 
    Document   : register
    Created on : Mar 4, 2026, 4:17:25 PM
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Create Client Account | Ocean View Resort</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:Segoe UI, Arial, sans-serif;}
    body{
      min-height:100vh;display:flex;align-items:center;justify-content:center;
      background:linear-gradient(rgba(0,0,0,.6), rgba(0,0,0,.6)),
      url("https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1600&q=70");
      background-size:cover;background-position:center;
    }
    .card{background:rgba(255,255,255,.95);width:100%;max-width:460px;
      padding:34px;border-radius:20px;box-shadow:0 20px 50px rgba(0,0,0,.3);}
    h2{text-align:center;color:#1b4fff;margin-bottom:18px;}
    .row{margin:12px 0;}
    label{display:block;font-size:13px;font-weight:700;color:#555;margin-bottom:6px;}
    input{width:100%;padding:12px;border:1px solid #ddd;border-radius:12px;outline:none;}
    input:focus{border-color:#1b4fff;box-shadow:0 0 0 3px rgba(27,79,255,.12);}
    .btn{width:100%;border:none;border-radius:14px;padding:12px;background:#1b4fff;color:#fff;
      font-size:15px;font-weight:700;cursor:pointer;margin-top:10px;}
    .btn:hover{filter:brightness(.95);}
    .small{text-align:center;margin-top:12px;font-size:13px;}
    .small a{color:#1b4fff;text-decoration:none;font-weight:700;}
    .hint{
      margin-top:10px;background:#f3f6ff;border:1px solid #dbe3ff;color:#1b4fff;
      padding:10px;border-radius:12px;font-size:13px;
    }
  </style>
</head>
<body>
  <div class="card">
    <h2>Create Client Account</h2>

    <div class="hint">
      Only guests/clients can create accounts here. Staff/admin accounts are created by management.
    </div>

    <form action="register" method="post">
      <% String regError = request.getParameter("error"); %>
      <% if (regError != null && !regError.isBlank()) { %>
        <p style="background:#ffecec;color:#c21818;padding:10px;border-radius:12px;margin:12px 0;font-size:13px;"><%= regError %></p>
      <% } %>
      <div class="row">
        <label>Full Name</label>
        <input type="text" name="fullName" required>
      </div>

      <div class="row">
        <label>Phone</label>
        <input type="text" name="phone" required>
      </div>

      <div class="row">
        <label>Address</label>
        <input type="text" name="address" required>
      </div>

      <div class="row">
        <label>Username</label>
        <input type="text" name="username" required>
      </div>

      <div class="row">
        <label>Password</label>
        <input type="password" name="password" required>
      </div>

      <button class="btn" type="submit">Create Account</button>
    </form>

    <div class="small">
      Already have an account? <a href="login.jsp">Login</a> | <a href="index.jsp">Home</a>
    </div>
  </div>
</body>
</html>
